from rest_framework.test import APITestCase
from  rest_framework import status
from django.contrib.auth import get_user_model
from django.urls import reverse_lazy
from django.forms.models import model_to_dict

from post.models import LostPetPost, Breed, Species
from post.serializers import LostPetPostSerializer
from datetime import date

class LostPetPostModelTests(APITestCase):
    def setUp(self):
        self.admin_data = {
            'email' : 'admin1@example.com',
            'name': 'admin1',
            'password': 'password1234',
            'is_staff': True, 
        }

        self.user_data = {
            'email' : 'user@example.com',
            'name': 'user',
            'password': 'password1234',
            'is_staff': False, 
        }
        
        self.user1_data = {
            'email' : 'user1@example.com',
            'name': 'user1',
            'password': 'password1234',
            'is_staff': False, 
        }

        self.breeds = [
            Breed(value='Dalmata'),
            Breed(value='-'),
        ]

        self.species = [
            Species(value='Perro'),
            Species(value='Gato'),
        ]

        Breed.objects.bulk_create(self.breeds)
        Species.objects.bulk_create(self.species)

        self.user = get_user_model().objects.create_user(**self.user_data)
        self.user1 = get_user_model().objects.create_user(**self.user1_data)
        self.admin = get_user_model().objects.create_user(**self.admin_data)        

    def test_get_lost_pet_post(self):
        post1 = LostPetPost(
                user=self.user,
                description="Ayuda",
                pet_name="Cuco",
                breed=self.breeds[1], species=self.species[0],
                color="1A5F6G",
                latitude = 23.312,
                longitude = 13.21312, 
                date_lost = date(year=2020, month=11, day=10),
                reward_amount = 100,
            )
        

        post2 = LostPetPost(
                user=self.admin,
                description="Ayuda por favor",
                pet_name="PAblo",
                breed=self.breeds[0], species=self.species[1],
                color="1A5F6D",
                latitude = 33.312,
                longitude = 43.21312, 
                date_lost = date(year=2020, month=11, day=10),
                reward_amount = 100,
            )

        post1.save()
        post2.save()

        expected_data = LostPetPostSerializer(LostPetPost.objects.all().order_by('-id'), many=True).data
        url = reverse_lazy('lost-pet-post-list')
        response = self.client.get(url)
        
        response_data = sorted(response.data, key=lambda x: x['id'], reverse=True)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response_data, expected_data)
    
    def test_get_lost_pet_post_by_id(self):
        data = {
            'user': self.user, 
            'description':"Ayuda",
            'pet_name':"Cuco",
            'breed':self.breeds[0], 'species':self.species[0],
            'color':"1A5F6G",
            'latitude':23.312, 'longitude':13.21312, 
            'date_lost': date(year=2020, month=11, day=10),
            'reward_amount': 100,
        }
        instance = LostPetPost.objects.create(**data)

        url = reverse_lazy('lost-pet-post-detail', args=[instance.id])
        response = self.client.get(url)
        response_data = response.data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertDictEqual(response_data, LostPetPostSerializer(instance).data)
    
    def test_create_lost_pet_post(self):
        self.client.force_authenticate(self.user)
        data = {
            'description':"Ayuda",
            'pet_name':"Cuco",
            'breed': self.breeds[0].id, 'species':self.species[0].id,
            'color':"1A5F6G",
            'latitude':20.312, 'longitude':34.21312, 
            'date_lost': date(year=2020, month=11, day=10),
            'reward_amount': 100,
        }

        url = reverse_lazy('lost-pet-post-list')
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
    
        id = response.data.get('id', None)
        assert id is not None

        instance = LostPetPost.objects.get(id=id)
        expected_data = LostPetPostSerializer(instance).data

        self.assertDictEqual(response.data, expected_data)
        
        

    def test_creation_denied_for_not_authenticated(self):
        data = {
            'description':"Ayuda",
            'pet_name':"Cuco",
            'breed': 0, 'species':1,
            'color':"1A5F6G",
            'latitude':123.312, 'longitude':213.21312, 
            'date_lost': date(year=2020, month=11, day=10),
            'reward_amount': 100,
        }
        url = reverse_lazy('lost-pet-post-list')
        response = self.client.post(url, data, format='json')
        return self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    def test_delete_own_post(self):
        self.client.force_authenticate(self.user)
        data = LostPetPost(
                user=self.user,
                description="Ayuda",
                pet_name="Cuco",
                breed=self.breeds[0], species=self.species[1],
                color="1A5F6G",
                latitude = 123.312,
                longitude = 213.21312, 
                date_lost = date(year=2020, month=11, day=10),
                reward_amount = 100,
            )
        data.save()
        
        url = reverse_lazy('lost-pet-post-detail', kwargs={'pk': data.id})
        response = self.client.delete(url)
        return self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
    
    def test_delete_other_post_denied(self):
        self.client.force_authenticate(self.user)
        data = LostPetPost(
                user=self.user1,
                description="Ayuda",
                pet_name="Cuco",
                breed=self.breeds[0], species=self.species[1],
                color="1A5F6G",
                latitude = 123.312,
                longitude = 213.21312, 
                date_lost = date(year=2020, month=11, day=10),
                reward_amount = 100,
            )
        data.save()
        
        url = reverse_lazy('lost-pet-post-detail', kwargs={'pk': data.id})
        response = self.client.delete(url)
        return self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_delete_user_post_as_admin(self):
        self.client.force_authenticate(self.admin)

        data = LostPetPost(
                user=self.user1,
                description="Ayuda",
                pet_name="Cuco",
                breed=self.breeds[0], species=self.species[1],
                color="1A5F6G",
                latitude = 123.312,
                longitude = 213.21312, 
                date_lost = date(year=2020, month=11, day=10),
                reward_amount = 100,
            )
        data.save()
        
        url = reverse_lazy('lost-pet-post-detail', kwargs={'pk': data.id})
        response = self.client.delete(url)
        return self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
    

