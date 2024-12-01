from rest_framework.test import APITestCase
from unittest.mock import patch
from django.urls import reverse_lazy
from django.contrib.auth import get_user_model
from rest_framework import status

from post.models import Breed, Species, Post, PetPhoto, LostPetPost, PetSightingPost, create_image_path
from post.serializers import PetSightingPostSerializer, PetPhotoSerializer

from datetime import date
from django.core.files.uploadedfile import SimpleUploadedFile
from django.core.files import File
from decimal import Decimal

from PIL import Image
import tempfile
import os

class TestImageUploads(APITestCase):
    def setUp(self):
        admin = {
            'email': 'admin1@example.com',
            'password': '1234password',
            'name': 'Admin',
            'is_staff': True,
        }

        user = {
            'email': 'user@example.com',
            'password': '1234password',
            'name': 'Admin',
            'is_staff': False,
        }

        self.user = get_user_model().objects.create_user(**user)
        self.admin = get_user_model().objects.create_user(**admin)


        self.species_list = [
            Species(value='Dog'),
            Species(value='Cat'),
        ]
        Species.objects.bulk_create(self.species_list)

        self.breed_list = [
            Breed(value='Labrador'),
            Breed(value='Siamese'),
        ]
        Breed.objects.bulk_create(self.breed_list)

        self.lost_pet_post = LostPetPost(
                user=self.user,
                description="Ayuda",
                pet_name="Cuco",
                breed=self.breed_list[1],
                species=self.species_list[0],
                color="1A5F6G",
                latitude = 23.312,
                longitude = 13.21312, 
                date_lost = date(year=2020, month=11, day=10),
                reward_amount = 100,
            )

        self.pet_sighting_post = PetSightingPost.objects.create(
            user=self.user,
            species=self.species_list[0],
            breed=self.breed_list[0],
            color='FF5733',
            date_sighted=date(2021, 7, 20),
            latitude=Decimal('34.052235'),
            longitude=Decimal('-118.243683'),
        )

        self.lost_pet_post.save()
        self.pet_sighting_post.save()


    def tearDown(self):
        photos = self.lost_pet_post.photos.all() | self.pet_sighting_post.photos.all()
        for pet_photo in photos:
            pet_photo.photo.delete()

    @patch('post.models.uuid4')
    def test_image_path(self, mock_uuid):

        mocked_name = "mock"
        mock_uuid.return_value = mocked_name
        filepath = create_image_path(None, 'example.png')
        self.assertEqual(filepath, f'upload/{mocked_name}.png')

    def test_upload_photo_lost_pet(self):
        """
        Test uploading a photo when creating a pet sighting post.
        """
        self.client.force_authenticate(user=self.user)

        with tempfile.NamedTemporaryFile(suffix='.jpg') as image_file:
            img = Image.new('RGB', (10, 10))
            img.save(image_file, format='JPEG')
            image_file.seek(0)
            data = {'photo': image_file,}
            url = reverse_lazy('lost-pet-post-upload-photo', kwargs={'pk': self.lost_pet_post.id})
            response = self.client.post(url, data, format='multipart')

        self.lost_pet_post.refresh_from_db()
        pet_photo = PetPhoto.objects.get(id=response.data['id'])
    
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIsNotNone(pet_photo.photo)
        self.assertIn('photo', response.data)
        self.assertTrue(os.path.exists(pet_photo.photo.path))

    def test_upload_photo_lost_pet(self):
        """
        Test uploading a photo to a lost pet post.
        """
        self.client.force_authenticate(user=self.user)

        with tempfile.NamedTemporaryFile(suffix='.jpg') as image_file:
            img = Image.new('RGB', (10, 10))
            img.save(image_file, format='JPEG')
            image_file.seek(0)
            data = {'photo': image_file,}
            url = reverse_lazy('pet-sighting-post-upload-photo', kwargs={'pk': self.pet_sighting_post.id})
            response = self.client.post(url, data, format='multipart')

        self.pet_sighting_post.refresh_from_db()
        pet_photo = PetPhoto.objects.get(id=response.data['id'])
    
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIsNotNone(pet_photo.photo)
        self.assertIn('photo', response.data)
        self.assertTrue(os.path.exists(pet_photo.photo.path))

    def test_upload_photo_pet_sighting(self):
        """
        Test uploading a photo to a pet sighting post.
        """
        self.client.force_authenticate(user=self.user)

        with tempfile.NamedTemporaryFile(suffix='.jpg') as image_file:
            img = Image.new('RGB', (10, 10))
            img.save(image_file, format='JPEG')
            image_file.seek(0)
            data = {'photo': image_file,}
            url = reverse_lazy('lost-pet-post-upload-photo', kwargs={'pk': self.lost_pet_post.id})
            response = self.client.post(url, data, format='multipart')

        self.pet_sighting_post.refresh_from_db()
        pet_photo = PetPhoto.objects.get(id=response.data['id'])
    
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIsNotNone(pet_photo.photo)
        self.assertIn('photo', response.data)
        self.assertTrue(os.path.exists(pet_photo.photo.path))


    def test_retrieve_photos_from_lost_pet_post(self):
        """
        Test retrieving photo url from certain lost pet post.
        """
        self.client.force_authenticate(user=self.user)

        with tempfile.NamedTemporaryFile(suffix='.jpg') as image_file:
            img = Image.new('RGB', (10, 10))
            img.save(image_file, format='JPEG')
            image_file.seek(0)
            
            django_file = File(file=image_file)
            PetPhoto.objects.create(post=self.lost_pet_post, photo=django_file)

        url = reverse_lazy('lost-pet-post-get-photo', kwargs={'pk': self.lost_pet_post.id})
        response = self.client.get(url)

        expected_data = PetPhotoSerializer(self.lost_pet_post.photos.all(), many=True).data
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        #self.assertEqual(response.data, expected_data)


    def test_retrieve_photos_from_sighting_post(self):
        """
        Test retrieving photo url from certain lost pet post.
        """
        self.client.force_authenticate(user=self.user)

        with tempfile.NamedTemporaryFile(suffix='.jpg') as image_file:
            img = Image.new('RGB', (10, 10))
            img.save(image_file, format='JPEG')
            image_file.seek(0)
            
            django_file = File(file=image_file)
            PetPhoto.objects.create(post=self.pet_sighting_post, photo=django_file)

        url = reverse_lazy('pet-sighting-post-get-photo', kwargs={'pk': self.pet_sighting_post.id})
        response = self.client.get(url)

        expected_data = PetPhotoSerializer(self.pet_sighting_post.photos.all(), many=True).data
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        #self.assertEqual(response.data, expected_data)