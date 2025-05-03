"""
Views for the post app using viewsets.
"""
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework import viewsets, authentication, status
from core.permissions import IsAdmin, IsLogged, IsAdminOrReadOnly
from rest_framework.response import Response
from rest_framework.decorators import action
from post.models import Breed, Species, LostPetPost, PetSightingPost, Comment, Message, PetPhoto
from post.serializers import (
    BreedSerializer, 
    SpeciesSerializer,
    LostPetPostSerializer,
    PetSightingPostSerializer,
    CommentSerializer,
    MessageSerializer,
    PetPhotoSerializer, 
)

from django.shortcuts import get_object_or_404
from django.core.exceptions import PermissionDenied
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.exceptions import ValidationError

from PIL import Image
import math

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample
from drf_spectacular.types import OpenApiTypes

@extend_schema(
    tags=["breeds"],
)
class BreedViewSet(viewsets.ModelViewSet): 
    "Viewset pet breeds."
    queryset = Breed.objects.all()
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAdminOrReadOnly]
    serializer_class = BreedSerializer 

@extend_schema(
    tags=["species"],
)
class SpeciesViewSet(viewsets.ModelViewSet):
    "Viewset for pet sepecies."
    queryset = Species.objects.all()
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAdminOrReadOnly]
    serializer_class = SpeciesSerializer

@extend_schema(
    tags=['lost pet posts']
)
class LostPetPostViewSet(viewsets.ModelViewSet):
    """ViewSet for lost pet posts."""
    queryset = LostPetPost.objects.all()
    serializer_class = LostPetPostSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        if not self.request.user.is_staff and self.request.user != serializer.instance.user:
            raise PermissionDenied("You do not have permission to edit this post.")
        serializer.save()

    def perform_destroy(self, instance):
        if not self.request.user.is_staff and self.request.user != instance.user:
            raise PermissionDenied("You do not have permission to delete this post.")
        instance.delete()

    def get_serializer_class(self):
        if self.action in ['upload_photo', 'get_photo']:
            return PetPhotoSerializer
        return super().get_serializer_class()


    @extend_schema(
            operation_id='nearby_search',
            summary='Find posts made within an area',
            description='Provide a center an a lookup radius',
            tags = ['lookup'],

            parameters=[
                OpenApiParameter(
                    name = 'center_latitude',
                    description = 'lookup center latitude',
                    type = OpenApiTypes.DECIMAL,
                    examples= [OpenApiExample(name='latitude', value='12.2132')],
                    required=True,
                ),

                OpenApiParameter(
                    name = 'center_longitude',
                    description= 'lookup center longitude',
                    type = OpenApiTypes.DECIMAL,
                    examples= [OpenApiExample(name='longitude', value='34.2343')],
                    required=True,
                ),
                OpenApiParameter(
                    name='radius',
                    description='lookup radius',
                    type = OpenApiTypes.DECIMAL,
                    examples=[OpenApiExample(name='radius', value='343.3')],
                    required=True,
                )
            ]

    )
    @action(methods=['GET'], detail=False, url_path='near')
    def find_near(self, request, pk=None):
        
        query_lat = request.query_params.get('center_latitude', None)
        query_lon = request.query_params.get('center_longitude', None)
        radius = request.query_params.get('radius', None)
        
        fail = False
        error = {'center_latitude': [], 'center_longitude': [], 'radius': []}
        if not query_lat:
            fail = True
            error['center_latitude'].append('Missing')    
        if not query_lon:
            fail = True
            error['center_longitude'].append('Missing')  
        if not radius:
            fail = True
            error['radius'].append('Missing')  

        try:
            query_lat = float(query_lat)
            if not isinstance(query_lat, float) or query_lat<-90 or query_lat>90:
                fail = True
                error['center_latitude'].append('Out of range')     
        except:
            if query_lat:
                fail = True
                error['center_latitude'].append('Not valid type')
        
        try: 
            query_lon = float(query_lon)
            if not isinstance(query_lon, float) or query_lon<-180 or query_lat>180:
                fail = True
                error['center_longitude'].append('Out of range')  
        except:
            if query_lon:
                fail = True
                error['center_longitude'].append('Not valid type') 
        
        try:
            radius = float(radius)
            if not isinstance(radius, float) or radius<0:
                fail = True
                error['radius'].append('Out of range') 
        except:
            if radius:
                fail =True
                error['radius'].append('Not valid type')
        
        if fail:
            return Response(error, status=status.HTTP_400_BAD_REQUEST)

        
        query_lat, query_lon = map(math.radians, [query_lat, query_lon])
        def earth_distance_to(id, latitude, longitude, earth_radius=6371.0):
            latitude, longitude = map(math.radians, [latitude, longitude])
            dlat = query_lat - latitude
            dlon = query_lon - longitude
            a = math.sin(dlat / 2)**2 + math.cos(latitude) * math.cos(query_lat) * math.sin(dlon / 2)**2
            c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
            distance = earth_radius * c
            return distance

        id_coordinates = LostPetPost.objects.values_list('id', 'latitude', 'longitude').order_by('id')
        filtered_ids = []
        for tuple in id_coordinates:
            if earth_distance_to(*tuple) <=  radius + 1e-6:
                filtered_ids.append(tuple[0])

        return_data = LostPetPostSerializer(LostPetPost.objects.filter(id__in=filtered_ids), many=True).data
        return Response(data=return_data, status=status.HTTP_200_OK)


    @action(methods=['POST', 'PUT', 'PATCH'], detail=True, url_path='photos/upload')
    def upload_photo(self, request, pk=None):
        instance = self.get_object()
        if not instance:
            return Response({'error': 'No se encontro el post'},
                             status=status.HTTP_400_BAD_REQUEST)
        data = dict()
        data['post'] = instance.post_ptr.id
        data['photo'] = request.FILES['photo']
        serializer = self.get_serializer(data=data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response({'error': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
    
    @action(methods=['GET'], detail=True, url_path='photos')
    def get_photo(self, request, pk=None):
        instance = self.get_object()

        if not instance:
            return Response({'error': 'No se encontro el post'},
                             status=status.HTTP_400_BAD_REQUEST)
        
        pet_photos = instance.photos.all()
        serializer = self.get_serializer(instance = pet_photos, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)
    
    @action(methods=['DELETE'], detail=True, url_path='photo/delete')
    def delete_photo(self, request, pk=None):
        if not pk:
            return Response({'photo':'Photo id missing'}, status=status.HTTP_400_BAD_REQUEST)
        
        photo_instance = get_object_or_404(PetPhoto, id=pk)
        if not photo_instance:
            return Response({'photo':'Photo could not be found'}, status=status.HTTP_404_NOT_FOUND)
        
        try:
            photo_instance.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@extend_schema(
    tags=['pet sighting posts']
)
class PetSightingPostViewSet(viewsets.ModelViewSet):
    """ViewSet for pet sighting posts."""
    queryset = PetSightingPost.objects.all()
    serializer_class = PetSightingPostSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]


    @extend_schema(
        operation_id='find_posts',
        summary='Get a description of the lost-pet-posts',
        description= 'Retrieve post information, or filter by species',
        parameters=[
            OpenApiParameter(
                name='species',
                description='species id',
                type= OpenApiTypes.INT,
                examples=[
                    OpenApiExample('Example Species', value='1',)
                ],
                required=False,
            ),
        ]
    )
    def list(self, request, *args, **kwargs):
        return super().list(request, *args, **kwargs)

    def get_queryset(self):
        species = self.request.query_params.get('species', None)
        if not species: return PetSightingPost.objects.all()

        try:
            species = int(species)
        except Exception as e:
            raise ValidationError(detail='species must be a number', code=status.HTTP_400_BAD_REQUEST)
        else: return PetSightingPost.objects.filter(species=species)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        if (not self.request.user.is_staff and 
            self.request.user != serializer.instance.user):
            raise PermissionDenied("You do not have permission to edit this post.")
        serializer.save()

    def perform_destroy(self, instance):
        if (not self.request.user.is_staff and
             self.request.user != instance.user):
            raise PermissionDenied("You do not have permission to delete this post.")
        instance.delete()

    def get_serializer_class(self):
        if self.action in ['upload_photo', 'get_photo']:
            return PetPhotoSerializer
        return super().get_serializer_class()

    @action(methods=['POST', 'PUT', 'PATCH'], detail=True, url_path='photos/upload')
    def upload_photo(self, request, pk=None):
        instance = self.get_object()
        if not instance:
            return Response({'error': 'No se encontro el post'},
                            status=status.HTTP_400_BAD_REQUEST)
        data = dict()
        data['post'] = instance.post_ptr.id
        data['photo'] = request.FILES['photo']
        serializer = self.get_serializer(data=data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response({'error': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
    
    @action(methods=['GET'], detail=True, url_path='photos')
    def get_photo(self, request, pk=None):
        instance = self.get_object()

        if not instance:
            return Response({'error': 'No se encontro el post'},
                             status=status.HTTP_400_BAD_REQUEST)
        
        pet_photos = instance.photos.all()
        serializer = self.get_serializer(instance=pet_photos, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    @action(methods=['DELETE'], detail=True, url_path='photo/delete')
    def delete_photo(self, request, pk=None):
        if not pk:
            return Response({'photo':'Photo id missing'}, status=status.HTTP_400_BAD_REQUEST)
        
        photo_instance = get_object_or_404(PetPhoto, id=pk)
        if not photo_instance:
            return Response({'photo':'Photo could not be found'}, status=status.HTTP_404_NOT_FOUND)
        
        try:
            photo_instance.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @extend_schema(
        operation_id='nearby_search',
        summary='Find posts made within an area',
        description='Provide a center an a lookup radius',
        tags = ['lookup'],

        parameters=[
            OpenApiParameter(
                name = 'center_latitude',
                description = 'lookup center latitude',
                type = OpenApiTypes.DECIMAL,
                examples= [OpenApiExample(name='latitude', value='12.2132')],
                required=True,
            ),

            OpenApiParameter(
                name = 'center_longitude',
                description= 'lookup center longitude',
                type = OpenApiTypes.DECIMAL,
                examples= [OpenApiExample(name='longitude', value='34.2343')],
                required=True,
            ),
            OpenApiParameter(
                name='radius',
                description='lookup radius',
                type = OpenApiTypes.DECIMAL,
                examples=[OpenApiExample(name='radius', value='343.3')],
                required=True,
            )
        ]

    )
    @action(methods=['GET'], detail=False, url_path='near')
    def find_near(self, request, pk=None):
        
        query_lat = request.query_params.get('center_latitude', None)
        query_lon = request.query_params.get('center_longitude', None)
        radius = request.query_params.get('radius', None)
        
        fail = False
        error = {'center_latitude': [], 'center_longitude': [], 'radius': []}
        if not query_lat:
            fail = True
            error['center_latitude'].append('Missing')    
        if not query_lon:
            fail = True
            error['center_longitude'].append('Missing')  
        if not radius:
            fail = True
            error['radius'].append('Missing')  

        try:
            query_lat = float(query_lat)
            if not isinstance(query_lat, float) or query_lat<-90 or query_lat>90:
                fail = True
                error['center_latitude'].append('Out of range')     
        except:
            if query_lat:
                fail = True
                error['center_latitude'].append('Not valid type')
        
        try: 
            query_lon = float(query_lon)
            if not isinstance(query_lon, float) or query_lon<-180 or query_lat>180:
                fail = True
                error['center_longitude'].append('Out of range')  
        except:
            if query_lon:
                fail = True
                error['center_longitude'].append('Not valid type') 
        
        try:
            radius = float(radius)
            if not isinstance(radius, float) or radius<0:
                fail = True
                error['radius'].append('Out of range') 
        except:
            if radius:
                fail =True
                error['radius'].append('Not valid type')
        
        if fail:
            return Response(error, status=status.HTTP_400_BAD_REQUEST)

        
        query_lat, query_lon = map(math.radians, [query_lat, query_lon])
        def earth_distance_to(id, latitude, longitude, earth_radius=6371.0):
            latitude, longitude = map(math.radians, [latitude, longitude])
            dlat = query_lat - latitude
            dlon = query_lon - longitude
            a = math.sin(dlat / 2)**2 + math.cos(latitude) * math.cos(query_lat) * math.sin(dlon / 2)**2
            c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
            distance = earth_radius * c
            return distance

        id_coordinates = PetSightingPost.objects.values_list('id', 'latitude', 'longitude').order_by('id')
        filtered_ids = []
        for tuple in id_coordinates:
            if earth_distance_to(*tuple) <=  radius + 1e-6:
                filtered_ids.append(tuple[0])

        return_data = PetSightingPostSerializer(PetSightingPost.objects.filter(id__in=filtered_ids), many=True).data
        return Response(data=return_data, status=status.HTTP_200_OK)


@extend_schema(
    summary='User comments API',
    description='CRUD opeartions for user comments',
    tags = ['comments']
)
class CommentViewSet(viewsets.ModelViewSet):
    """ViewSet for comments."""
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    @extend_schema(
            operation_id='get-comments',
            parameters=[
                OpenApiParameter(name='parent',
                                description='parent comment id',
                                type= OpenApiTypes.INT,
                                examples=[
                                    OpenApiExample(
                                        name='parent_id',
                                        value='1',
                                    )
                                ],
                                required=False,
                                ),
            ]
    )
    def list(self, request, *args, **kwargs):
        return super().list(request, *args, **kwargs)

    def get_queryset(self):
        parent = self.request.query_params.get('parent', None)

        if not parent:
            return Comment.objects.all()
        
        try:
            parent = int(parent)
        except:
            raise ValidationError(detail='Parent must be a pk', code=status.HTTP_400_BAD_REQUEST)
        
        return Comment.objects.filter(parent=parent)
        

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        if self.request.user != serializer.instance.user:
            raise PermissionDenied("You do not have permission to edit this comment.")
        serializer.save()

    def perform_destroy(self, instance):
        if not self.request.user.is_staff and self.request.user != instance.user:
            raise PermissionDenied("You do not have permission to delete this comment.")
        instance.delete()

@extend_schema(
    tags=['messages']
)
class MessageViewSet(viewsets.ModelViewSet):
    """ViewSet for messages."""
    serializer_class = MessageSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """Return messages for the authenticated user."""
        return Message.objects.filter(receiver=self.request.user)

    def perform_create(self, serializer):
        serializer.save()

    @action(detail=True, methods=['get'])
    def mark_as_read(self, request, pk=None):
        """Mark message as read."""
        message = self.get_object()
        if message.receiver != request.user:
            raise permissions.PermissionDenied("You do not have permission to mark this message.")
        if not message.is_read:
            message.is_read = True
            message.save()
        serializer = self.get_serializer(message)
        return Response(serializer.data)
