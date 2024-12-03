"""
URL configurations for the post app using routers.
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from post import views

router = DefaultRouter()
router.register(r'breeds', views.BreedViewSet, basename="breeds")
router.register(r'species', views.SpeciesViewSet, basename='species')
router.register(r'lost-pets', views.LostPetPostViewSet, basename='lost-pet-post')
router.register(r'pet-sightings', views.PetSightingPostViewSet, basename='pet-sighting-post')
router.register(r'comments', views.CommentViewSet, basename='comment')
router.register(r'messages', views.MessageViewSet, basename='message')

urlpatterns = [
    path('', include(router.urls)),
]
