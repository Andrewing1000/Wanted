from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth import get_user_model
from django.urls import reverse_lazy, reverse
from datetime import date
from decimal import Decimal
from post.models import LostPetPost, PetSightingPost, Breed, Species
from post.serializers import LostPetPostSerializer, PetSightingPostSerializer

class LostPetPostModelTests(APITestCase):
    def setUp(self):
        self.user_data = {
            'email': 'user@example.com',
            'name': 'User',
            'password': 'password123',
        }
        self.user = get_user_model().objects.create_user(**self.user_data)
        
        self.breed = Breed.objects.create(value='Breed1')
        self.species = Species.objects.create(value='Species1')
        
        self.posts = [
            LostPetPost.objects.create(
                user=self.user,
                description="Lost pet near New York City",
                pet_name="Buddy",
                breed=self.breed,
                species=self.species,
                color="FFFFFF",
                latitude=Decimal('40.7128'),  # New York City
                longitude=Decimal('-74.0060'),
                date_lost=date(2021, 1, 1),
                reward_amount=100.00,
            ),
            LostPetPost.objects.create(
                user=self.user,
                description="Lost pet near Los Angeles",
                pet_name="Max",
                breed=self.breed,
                species=self.species,
                color="000000",
                latitude=Decimal('34.0522'),  # Los Angeles
                longitude=Decimal('-118.2437'),
                date_lost=date(2021, 2, 1),
                reward_amount=200.00,
            ),
            LostPetPost.objects.create(
                user=self.user,
                description="Lost pet near Chicago",
                pet_name="Charlie",
                breed=self.breed,
                species=self.species,
                color="FF0000",
                latitude=Decimal('41.8781'),  # Chicago
                longitude=Decimal('-87.6298'),
                date_lost=date(2021, 3, 1),
                reward_amount=150.00,
            ),
        ]

    def test_find_near_posts_within_radius(self):
        """
        Test retrieving posts within a certain radius from a point.
        """
        url = reverse('lost-pet-post-find-near')
        center_latitude = '40.7128'   # New York City
        center_longitude = '-74.0060'
        radius = '1500'  # in kilometers

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Posts in NYC and Chicago should be within 1500 km of NYC
        expected_posts = [self.posts[0], self.posts[2]]
        expected_data = LostPetPostSerializer(expected_posts, many=True).data

        self.assertEqual(len(response.data), len(expected_data))
        for post_data in expected_data:
            self.assertIn(post_data, response.data)

    def test_find_near_posts_outside_radius(self):
        """
        Test that posts outside the radius are not returned.
        """
        url = reverse('lost-pet-post-find-near')
        center_latitude = '40.7128'   # New York City
        center_longitude = '-74.0060'
        radius = '100'  # 100 km radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Only the NYC post should be returned
        expected_posts = [self.posts[0]]
        expected_data = LostPetPostSerializer(expected_posts, many=True).data

        self.assertEqual(len(response.data), len(expected_data))
        self.assertEqual(response.data, expected_data)

    def test_find_near_posts_no_results(self):
        """
        Test that no posts are returned if none are within the radius.
        """
        url = reverse('lost-pet-post-find-near')
        center_latitude = '0.0'   # Equator, middle of the ocean
        center_longitude = '0.0'
        radius = '10'  # 10 km radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # No posts should be returned
        self.assertEqual(len(response.data), 0)

    def test_find_near_posts_invalid_params(self):
        """
        Test that invalid parameters return a 400 Bad Request.
        """
        url = reverse('lost-pet-post-find-near')
        params = {
            'center_latitude': 'invalid',
            'center_longitude': 'invalid',
            'radius': 'invalid',
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('center_latitude', response.data)
        self.assertIn('center_longitude', response.data)
        self.assertIn('radius', response.data)

    def test_find_near_posts_missing_params(self):
        """
        Test that missing parameters return a 400 Bad Request.
        """
        url = reverse('lost-pet-post-find-near')
        params = {
            'center_latitude': '40.7128',
            # 'center_longitude' is missing
            'radius': '100',
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('center_longitude', response.data)

    def test_find_near_posts_zero_radius(self):
        """
        Test that a zero radius returns posts at the exact point.
        """
        url = reverse('lost-pet-post-find-near')
        center_latitude = '40.7128'   # New York City
        center_longitude = '-74.0060'
        radius = '0'  # Zero radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Only the NYC post should be returned
        expected_posts = [self.posts[0]]
        expected_data = LostPetPostSerializer(expected_posts, many=True).data

        self.assertEqual(len(response.data), len(expected_data))
        self.assertEqual(response.data, expected_data)

    def test_find_near_posts_negative_radius(self):
        """
        Test that a negative radius returns a 400 Bad Request.
        """
        url = reverse('lost-pet-post-find-near')
        center_latitude = '40.7128'
        center_longitude = '-74.0060'
        radius = '-100'  # Negative radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('radius', response.data)

class PetSightingPostTests(APITestCase):
    def setUp(self):
        # Create users
        self.user_data = {
            'email': 'user@example.com',
            'name': 'User',
            'password': 'password123',
        }
        self.user = get_user_model().objects.create_user(**self.user_data)
        
        # Create breeds and species
        self.breed = Breed.objects.create(value='Breed1')
        self.species = Species.objects.create(value='Species1')
        
        # Create posts at various locations
        self.posts = [
            PetSightingPost.objects.create(
                user=self.user,
                species=self.species,
                breed=self.breed,
                color="FFFFFF",
                date_sighted=date(2021, 1, 1),
                latitude=Decimal('40.7128'),  # New York City
                longitude=Decimal('-74.0060'),
            ),
            PetSightingPost.objects.create(
                user=self.user,
                species=self.species,
                breed=self.breed,
                color="000000",
                date_sighted=date(2021, 2, 1),
                latitude=Decimal('34.0522'),  # Los Angeles
                longitude=Decimal('-118.2437'),
            ),
            PetSightingPost.objects.create(
                user=self.user,
                species=self.species,
                breed=self.breed,
                color="FF0000",
                date_sighted=date(2021, 3, 1),
                latitude=Decimal('41.8781'),  # Chicago
                longitude=Decimal('-87.6298'),
            ),
        ]

    def test_find_near_posts_within_radius(self):
        """
        Test retrieving pet sighting posts within a certain radius from a point.
        """
        url = reverse('pet-sighting-post-find-near')
        center_latitude = '40.7128'   # New York City
        center_longitude = '-74.0060'
        radius = '1500'  # in kilometers

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Posts in NYC and Chicago should be within 1500 km of NYC
        expected_posts = [self.posts[0], self.posts[2]]
        expected_data = PetSightingPostSerializer(expected_posts, many=True).data

        self.assertEqual(len(response.data), len(expected_data))
        for post_data in expected_data:
            self.assertIn(post_data, response.data)

    def test_find_near_posts_outside_radius(self):
        """
        Test that pet sighting posts outside the radius are not returned.
        """
        url = reverse('pet-sighting-post-find-near')
        center_latitude = '40.7128'   # New York City
        center_longitude = '-74.0060'
        radius = '100'  # 100 km radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Only the NYC post should be returned
        expected_posts = [self.posts[0]]
        expected_data = PetSightingPostSerializer(expected_posts, many=True).data

        self.assertEqual(len(response.data), len(expected_data))
        self.assertEqual(response.data, expected_data)

    def test_find_near_posts_no_results(self):
        """
        Test that no pet sighting posts are returned if none are within the radius.
        """
        url = reverse('pet-sighting-post-find-near')
        center_latitude = '0.0'   # Equator, middle of the ocean
        center_longitude = '0.0'
        radius = '10'  # 10 km radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # No posts should be returned
        self.assertEqual(len(response.data), 0)

    def test_find_near_posts_invalid_params(self):
        """
        Test that invalid parameters return a 400 Bad Request.
        """
        url = reverse('pet-sighting-post-find-near')
        params = {
            'center_latitude': 'invalid',
            'center_longitude': 'invalid',
            'radius': 'invalid',
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('center_latitude', response.data)
        self.assertIn('center_longitude', response.data)
        self.assertIn('radius', response.data)

    def test_find_near_posts_missing_params(self):
        """
        Test that missing parameters return a 400 Bad Request.
        """
        url = reverse('pet-sighting-post-find-near')
        params = {
            'center_latitude': '40.7128',
            # 'center_longitude' is missing
            'radius': '100',
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('center_longitude', response.data)

    def test_find_near_posts_zero_radius(self):
        """
        Test that a zero radius returns posts at the exact point.
        """
        url = reverse('pet-sighting-post-find-near')
        center_latitude = '40.7128'   # New York City
        center_longitude = '-74.0060'
        radius = '0'  # Zero radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Only the NYC post should be returned
        expected_posts = [self.posts[0]]
        expected_data = PetSightingPostSerializer(expected_posts, many=True).data

        self.assertEqual(len(response.data), len(expected_data))
        self.assertEqual(response.data, expected_data)

    def test_find_near_posts_negative_radius(self):
        """
        Test that a negative radius returns a 400 Bad Request.
        """
        url = reverse('pet-sighting-post-find-near')
        center_latitude = '40.7128'
        center_longitude = '-74.0060'
        radius = '-100'  # Negative radius

        params = {
            'center_latitude': center_latitude,
            'center_longitude': center_longitude,
            'radius': radius,
        }

        response = self.client.get(url, params)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('radius', response.data)