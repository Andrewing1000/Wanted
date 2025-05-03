from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth import get_user_model
from django.urls import reverse_lazy
from datetime import date, timedelta
from decimal import Decimal


from post.models import PetSightingPost, Breed, Species
from post.serializers import PetSightingPostSerializer

class PetSightingPostTests(APITestCase):
    def setUp(self):
        # Create users
        self.admin_data = {
            'email': 'admin1@example.com',
            'name': 'Admin User',
            'password': 'adminpass',
            'is_staff': True,
        }

        self.user_data = {
            'email': 'user@example.com',
            'name': 'Regular User',
            'password': 'userpass',
            'is_staff': False,
        }

        self.other_user_data = {
            'email': 'otheruser@example.com',
            'name': 'Other User',
            'password': 'otherpass',
            'is_staff': False,
        }

        self.admin = get_user_model().objects.create_user(**self.admin_data)
        self.user = get_user_model().objects.create_user(**self.user_data)
        self.other_user = get_user_model().objects.create_user(**self.other_user_data)

        # Create species and breeds
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

    def test_list_pet_sighting_posts(self):
        """
        Test retrieving a list of pet sighting posts.
        """
        post1 = PetSightingPost.objects.create(
            user=self.user,
            species=self.species_list[0],
            breed=self.breed_list[0],
            color='FF5733',
            date_sighted=date(2021, 7, 20),
            latitude=Decimal('34.052235'),
            longitude=Decimal('-118.243683'),
        )

        post2 = PetSightingPost.objects.create(
            user=self.other_user,
            species=self.species_list[1],
            breed=self.breed_list[1],
            color='C70039',
            date_sighted=date(2021, 7, 21),
            latitude=Decimal('40.712776'),
            longitude=Decimal('-74.005974'),
        )

        url = reverse_lazy('pet-sighting-post-list')
        response = self.client.get(url)

        expected_data = PetSightingPostSerializer(
            PetSightingPost.objects.all().order_by('-id'), many=True
        ).data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, expected_data)

    def test_retrieve_pet_sighting_post(self):
        """
        Test retrieving a single pet sighting post by ID.
        """
        post = PetSightingPost.objects.create(
            user=self.user,
            species=self.species_list[0],
            breed=self.breed_list[0],
            color='DAF7A6',
            date_sighted=date(2021, 7, 22),
            latitude=Decimal('51.507351'),
            longitude=Decimal('-0.127758'),
        )

        url = reverse_lazy('pet-sighting-post-detail', args=[post.id])
        response = self.client.get(url)

        expected_data = PetSightingPostSerializer(post).data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, expected_data)

    def test_create_pet_sighting_post_authenticated(self):
        """
        Test creating a pet sighting post as an authenticated user.
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'species': self.species_list[0].id,
            'breed': self.breed_list[0].id,
            'color': '581845',
            'date_sighted': '2021-07-23',
            'latitude': '37.774929',
            'longitude': '-122.419418',
        }

        url = reverse_lazy('pet-sighting-post-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        post = PetSightingPost.objects.get(id=response.data['id'])
        expected_data = PetSightingPostSerializer(post).data

        self.assertEqual(response.data, expected_data)

    def test_create_pet_sighting_post_unauthenticated(self):
        """
        Test that unauthenticated users cannot create pet sighting posts.
        """
        data = {
            'species': self.species_list[1].id,
            'breed': self.breed_list[1].id,
            'color': 'FFC300',
            'date_sighted': '2021-07-24',
            'latitude': '48.856613',
            'longitude': '2.352222',
        }

        url = reverse_lazy('pet-sighting-post-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_update_pet_sighting_post_owner(self):
        """
        Test that a user can update their own pet sighting post.
        """
        self.client.force_authenticate(user=self.user)
        post = PetSightingPost.objects.create(
            user=self.user,
            species=self.species_list[0],
            breed=self.breed_list[0],
            color='900C3F',
            date_sighted=date(2021, 7, 25),
            latitude=Decimal('34.052235'),
            longitude=Decimal('-118.243683'),
        )

        data = {
            'color': 'FF5733',  # Changing color
        }

        url = reverse_lazy('pet-sighting-post-detail', args=[post.id])
        response = self.client.patch(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        post.refresh_from_db()
        self.assertEqual(post.color, 'FF5733')

    def test_update_pet_sighting_post_not_owner(self):
        """
        Test that a user cannot update someone else's pet sighting post.
        """
        self.client.force_authenticate(user=self.user)
        post = PetSightingPost.objects.create(
            user=self.other_user,
            species=self.species_list[1],
            breed=self.breed_list[1],
            color='C70039',
            date_sighted=date(2021, 7, 26),
            latitude=Decimal('40.712776'),
            longitude=Decimal('-74.005974'),
        )

        data = {
            'color': 'FFC300',
        }

        url = reverse_lazy('pet-sighting-post-detail', args=[post.id])
        response = self.client.patch(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_delete_pet_sighting_post_owner(self):
        """
        Test that a user can delete their own pet sighting post.
        """
        self.client.force_authenticate(user=self.user)
        post = PetSightingPost.objects.create(
            user=self.user,
            species=self.species_list[0],
            breed=self.breed_list[0],
            color='581845',
            date_sighted=date(2021, 7, 27),
            latitude=Decimal('51.507351'),
            longitude=Decimal('-0.127758'),
        )

        url = reverse_lazy('pet-sighting-post-detail', args=[post.id])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(PetSightingPost.objects.filter(id=post.id).exists())

    def test_delete_pet_sighting_post_not_owner(self):
        """
        Test that a user cannot delete someone else's pet sighting post.
        """
        self.client.force_authenticate(user=self.user)
        post = PetSightingPost.objects.create(
            user=self.other_user,
            species=self.species_list[1],
            breed=self.breed_list[1],
            color='DAF7A6',
            date_sighted=date(2021, 7, 28),
            latitude=Decimal('48.856613'),
            longitude=Decimal('2.352222'),
        )

        url = reverse_lazy('pet-sighting-post-detail', args=[post.id])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertTrue(PetSightingPost.objects.filter(id=post.id).exists())

    def test_delete_pet_sighting_post_admin(self):
        """
        Test that an admin user can delete any pet sighting post.
        """
        self.client.force_authenticate(user=self.admin)
        post = PetSightingPost.objects.create(
            user=self.other_user,
            species=self.species_list[0],
            breed=self.breed_list[0],
            color='FFC300',
            date_sighted=date(2021, 7, 29),
            latitude=Decimal('37.774929'),
            longitude=Decimal('-122.419418'),
        )

        url = reverse_lazy('pet-sighting-post-detail', args=[post.id])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(PetSightingPost.objects.filter(id=post.id).exists())

    def test_create_pet_sighting_post_missing_fields(self):
        """
        Test that creating a pet sighting post fails if required fields are missing.
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'breed': self.breed_list[0].id,
            'color': 'FF5733',
            'date_sighted': '2021-07-30',
            'latitude': '34.052235',
            'longitude': '-118.243683',
        }
        # Missing 'species' field

        url = reverse_lazy('pet-sighting-post-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('species', response.data)

    def test_filter_pet_sighting_posts_by_species(self):
        """
        Test filtering pet sighting posts by species.
        """
        PetSightingPost.objects.create(
            user=self.user,
            species=self.species_list[0],  # Dog
            breed=self.breed_list[0],
            color='581845',
            date_sighted=date(2021, 8, 2),
            latitude=Decimal('34.052235'),
            longitude=Decimal('-118.243683'),
        )
        PetSightingPost.objects.create(
            user=self.other_user,
            species=self.species_list[1],  # Cat
            breed=self.breed_list[1],
            color='DAF7A6',
            date_sighted=date(2021, 8, 3),
            latitude=Decimal('40.712776'),
            longitude=Decimal('-74.005974'),
        )

        url = f"{reverse_lazy('pet-sighting-post-list')}?species={self.species_list[0].id}"
        response = self.client.get(url)

        expected_posts = PetSightingPost.objects.filter(species=self.species_list[0])
        expected_data = PetSightingPostSerializer(expected_posts, many=True).data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, expected_data)

    def test_create_pet_sighting_post_invalid_coordinates(self):
        """
        Test that creating a pet sighting post with invalid coordinates fails.
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'species': self.species_list[0].id,
            'breed': self.breed_list[0].id,
            'color': 'FF5733',
            'date_sighted': '2021-08-04',
            'latitude': '999.999999',  # Invalid latitude
            'longitude': '-999.999999',  # Invalid longitude
        }

        url = reverse_lazy('pet-sighting-post-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('latitude', response.data)
        self.assertIn('longitude', response.data)

    def test_create_pet_sighting_post_future_date(self):
        """
        Test that creating a pet sighting post with a future date fails.
        """
        self.client.force_authenticate(user=self.user)
        future_date = date.today() + timedelta(5)
        date_formated = future_date.isoformat()

        data = {
            'species': self.species_list[0].id,
            'breed': self.breed_list[0].id,
            'color': 'C70039',
            'date_sighted': date_formated,  # Today's date or future
            'latitude': '34.052235',
            'longitude': '-118.243683',
        }

        url = reverse_lazy('pet-sighting-post-list')
        response = self.client.post(url, data, format='json')

        # Assuming that date_sighted cannot be in the future
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
