"""
Database models for the post app.
"""
from django.db import models
from django.conf import settings
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType


class LostPetPost(models.Model):
    """Model for lost pet posts."""

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='lost_pet_posts'
    )
    pet_name = models.CharField(max_length=100)
    species = models.CharField(max_length=50)
    breed = models.CharField(max_length=100, blank=True, null=True)
    color = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    photo = models.ImageField(upload_to='lost_pets/', null=True, blank=True)
    date_lost = models.DateField()
    last_seen_location = models.CharField(max_length=255)
    reward_amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    date_created = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-date_created']

    def __str__(self):
        return f"{self.pet_name} ({self.species})"


class PetSightingPost(models.Model):
    """Model for pet sighting posts."""

    reporter = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='pet_sighting_posts'
    )
    lost_pet_post = models.ForeignKey(
        LostPetPost,
        on_delete=models.CASCADE,
        related_name='sightings',
        null=True,
        blank=True
    )
    species = models.CharField(max_length=50)
    color = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    photo = models.ImageField(upload_to='pet_sightings/', null=True, blank=True)
    date_sighted = models.DateField()
    location = models.CharField(max_length=255)
    date_created = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-date_created']

    def __str__(self):
        return f"Sighting of {self.species} at {self.location}"


class Comment(models.Model):
    """Model for comments on posts and comments (nested comments)."""

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='comments'
    )
    content = models.TextField()
    date_created = models.DateTimeField(auto_now_add=True)

    # For nested comments
    parent = models.ForeignKey(
        'self',
        null=True,
        blank=True,
        related_name='replies',
        on_delete=models.CASCADE
    )

    # Generic relationship to LostPetPost or PetSightingPost
    content_type = models.ForeignKey(
        ContentType,
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    object_id = models.PositiveIntegerField(null=True, blank=True)
    content_object = GenericForeignKey('content_type', 'object_id')

    class Meta:
        ordering = ['date_created']

    def __str__(self):
        return f"Comment by {self.user.email}"


class Message(models.Model):
    """Model for messages between users."""

    sender = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='sent_messages'
    )
    receiver = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='received_messages'
    )
    subject = models.CharField(max_length=255)
    body = models.TextField()
    date_sent = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)

    class Meta:
        ordering = ['-date_sent']

    def __str__(self):
        return f"Message from {self.sender.email} to {self.receiver.email}"
