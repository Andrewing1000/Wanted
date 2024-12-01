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
from django.core.exceptions import PermissionDenied
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated

from PIL import Image


class BreedViewSet(viewsets.ModelViewSet): 
    "Viewset for pet breeds."
    queryset = Breed.objects.all()
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAdminOrReadOnly]
    serializer_class = BreedSerializer 


class SpeciesViewSet(viewsets.ModelViewSet):
    "Viewset for pet sepecies."
    queryset = Species.objects.all()
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAdminOrReadOnly]
    serializer_class = SpeciesSerializer

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

    # @action(methods=['GET'], detail=False, url_path='near')
    # def find_near(self, request, pk=None):
    #     id_coordinates = LostPetPost.objects.values_list()

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






class PetSightingPostViewSet(viewsets.ModelViewSet):
    """ViewSet for pet sighting posts."""
    queryset = PetSightingPost.objects.all()
    serializer_class = PetSightingPostSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]


    def get_queryset(self):
        species = self.request.query_params.get('species', None)
        if not species: return PetSightingPost.objects.all()
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

class CommentViewSet(viewsets.ModelViewSet):
    """ViewSet for comments."""
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        parent = self.request.query_params.get('parent', None)
        if parent:
            return Comment.objects.filter(parent=parent)
        return Comment.objects.all()

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
