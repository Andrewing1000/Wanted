"""
Database models for the post app.
"""
from django.db import models
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.core.validators import MinValueValidator, MaxValueValidator
from datetime import date

from os import path
from uuid import uuid4

def create_image_path(instance, filename: str):
    ext = path.splitext(filename)[-1]
    generated_filename = f'{uuid4()}{ext}'
    return path.join('upload', generated_filename)

class Species(models.Model):
    value = models.CharField(max_length=255)
    
    def __str__(self):
        return "Specie: " + self.value

class Breed(models.Model):
    value = models.CharField(max_length=255)

    def __str__(self):
        return "Breed: " + self.value

class Post(models.Model):
    user = models.ForeignKey(
        get_user_model(),
        on_delete=models.CASCADE,
        related_name='posts',
    )
    description = models.TextField(blank=True, null=True)
    creation_date = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-creation_date']

    def __str__(self): 
        return f"Post by: {self.user}"


class PetPhoto(models.Model):
    "Images for posts"
    photo = models.ImageField(upload_to=create_image_path)
    post = models.ForeignKey(Post,
                            null=False,
                            blank=False,
                            on_delete=models.CASCADE, 
                            related_name = 'photos')
    
    class Meta:
        ordering = ['-id']

class LostPetPost(Post):
    """Model for lost pet posts."""

    pet_name = models.CharField(max_length=100)
    species = models.ForeignKey(Species,
                                on_delete=models.RESTRICT,
                                blank=False,
                                null=False, 
                                related_name="lost_posts")
    breed = models.ForeignKey(Breed,
                                on_delete=models.RESTRICT,
                                blank=False,
                                null=False,
                                related_name="lost_posts")
    color = models.CharField(max_length=6, blank=False, null=False)
    date_lost = models.DateField()
    latitude = models.DecimalField( max_digits=255,
                                    decimal_places=7,
                                    blank=True,
                                    null=True, 
                                    default=None,
                                    validators=[MaxValueValidator(limit_value=90), MinValueValidator(limit_value=-90),])
    longitude = models.DecimalField(max_digits=255,
                                    decimal_places=7,
                                    blank=True,
                                    null=True,
                                    default=None, 
                                    validators=[MaxValueValidator(limit_value=180), MinValueValidator(limit_value=-180),])
    reward_amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, default=None)

    def __str__(self):
        return f"{self.pet_name} ({self.species})"


class PetSightingPost(Post):
    """Model for pet sighting posts."""

    species = models.ForeignKey(Species,
                                on_delete=models.RESTRICT,
                                blank=False, 
                                null=False,
                                related_name="sighting_posts",)
    breed = models.ForeignKey(Breed, 
                              on_delete=models.RESTRICT,
                              blank=False,
                              null=False, 
                              related_name="sighting_posts",)
    
    color = models.CharField(max_length=6, blank=False, null=False)
    date_sighted = models.DateField(blank=False, null=False, default=date.today)
    latitude = models.DecimalField( max_digits=255,
                                    decimal_places=7,
                                    blank=False,
                                    null=False, 
                                    validators=[MaxValueValidator(limit_value=90), MinValueValidator(limit_value=-90),])
    longitude = models.DecimalField(max_digits=255,
                                    decimal_places=7,
                                    blank=False,
                                    null=False, 
                                    validators=[MaxValueValidator(limit_value=180), MinValueValidator(limit_value=-180),])


    def __str__(self):
        return f"Sighting of {self.species} at ({self.latitude},{self.longitude})"


class Comment(models.Model):
    """Model for comments on posts and comments (nested comments)."""

    user = models.ForeignKey(
        get_user_model(),
        on_delete=models.CASCADE,
        related_name='comments'
    )
    content = models.TextField()
    creation_date = models.DateTimeField(auto_now_add=True)

    post = models.ForeignKey(
        Post,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='comments'
    )

    parent = models.ForeignKey(
        'self',
        null=True,
        blank=True,
        related_name='replies',
        on_delete=models.CASCADE
    )

    class Meta:
        ordering = ['-creation_date']

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
