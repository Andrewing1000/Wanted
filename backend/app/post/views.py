"""
Views for the post app using viewsets.
"""
from rest_framework import viewsets, permissions, authentication, status
from rest_framework.response import Response
from rest_framework.decorators import action
from post.models import LostPetPost, PetSightingPost, Comment, Message
from post.serializers import (
    LostPetPostSerializer,
    PetSightingPostSerializer,
    CommentSerializer,
    MessageSerializer,
)
from django.contrib.contenttypes.models import ContentType
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated


class LostPetPostViewSet(viewsets.ModelViewSet):
    """ViewSet for lost pet posts."""
    queryset = LostPetPost.objects.all()
    serializer_class = LostPetPostSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    def perform_update(self, serializer):
        if self.request.user != serializer.instance.owner:
            raise permissions.PermissionDenied("You do not have permission to edit this post.")
        serializer.save()

    def perform_destroy(self, instance):
        if self.request.user != instance.owner:
            raise permissions.PermissionDenied("You do not have permission to delete this post.")
        instance.delete()


class PetSightingPostViewSet(viewsets.ModelViewSet):
    """ViewSet for pet sighting posts."""
    queryset = PetSightingPost.objects.all()
    serializer_class = PetSightingPostSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(reporter=self.request.user)

    def perform_update(self, serializer):
        if self.request.user != serializer.instance.reporter:
            raise permissions.PermissionDenied("You do not have permission to edit this post.")
        serializer.save()

    def perform_destroy(self, instance):
        if self.request.user != instance.reporter:
            raise permissions.PermissionDenied("You do not have permission to delete this post.")
        instance.delete()


class CommentViewSet(viewsets.ModelViewSet):
    """ViewSet for comments."""
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        queryset = super().get_queryset()
        content_type = self.request.query_params.get('content_type')
        object_id = self.request.query_params.get('object_id')
        parent_id = self.request.query_params.get('parent_id')

        if parent_id:
            queryset = queryset.filter(parent_id=parent_id)
        elif content_type and object_id:
            try:
                content_type_instance = ContentType.objects.get(model=content_type)
                queryset = queryset.filter(
                    content_type=content_type_instance,
                    object_id=object_id,
                    parent__isnull=True
                )
            except ContentType.DoesNotExist:
                queryset = queryset.none()
        else:
            queryset = queryset.filter(parent__isnull=True)
        return queryset

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        if self.request.user != serializer.instance.user:
            raise permissions.PermissionDenied("You do not have permission to edit this comment.")
        serializer.save()

    def perform_destroy(self, instance):
        if self.request.user != instance.user:
            raise permissions.PermissionDenied("You do not have permission to delete this comment.")
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
