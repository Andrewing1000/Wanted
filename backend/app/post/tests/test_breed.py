from rest_framework.test import APITestCase
from  rest_framework import status
from django.contrib.auth import get_user_model
from django.urls import reverse_lazy
from django.forms.models import model_to_dict

from post.models import Breed


class BreedModelTests(APITestCase):
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
        
        self.user = get_user_model().objects.create_user(**self.user_data)
        self.admin = get_user_model().objects.create_user(**self.admin_data)        

    def test_get_breeds(self):
        breeds = [  
            Breed(value='Doberman'),
            Breed(value= 'Golden Retriever'),
            Breed(value= 'Uaymaran'),
        ]
        Breed.objects.bulk_create(breeds)

        expected_data = list(Breed.objects.values())
        url = reverse_lazy('breeds-list')
        response = self.client.get(url)
        return self.assertListEqual(response.data, expected_data)
    
    def test_get_breeds_by_id(self):
        data = {'value': 'Doberman'}
        instance = Breed.objects.create(**data)

        url = reverse_lazy('breeds-detail', args=[instance.id])
        response = self.client.get(url)
        response_data = response.data
        response_data['id'] = instance.id
        return self.assertDictEqual(response_data, model_to_dict(instance))
    
    def test_create_breeds_if_admin(self):
        self.client.force_authenticate(self.admin)

        data = {'value': 'Doberman'}
        url = reverse_lazy('breeds-list')
        response = self.client.post(url, data, format='json')
        id = response.data['id']
        
        try:
            expected_data = Breed.objects.values().get(id=id)
        except:
            return False
        
        data['id'] = id
        return self.assertEqual(data, expected_data)
    
    def test_delete_breeds_if_admin(self):
        self.client.force_authenticate(self.admin)

        data = {'value': 'Doberman'}
        breed = Breed.objects.create(**data)

        url = reverse_lazy('breeds-detail', kwargs={'pk': breed.id})
        reponse = self.client.delete(url)

        return self.assertFalse(Breed.objects.filter(id=breed.id))
    
    def test_get_breeds_by_id(self):
        data = {'value': 'Doberman'}
        instance = Breed.objects.create(**data)

        url = reverse_lazy('breeds-detail', args=[instance.id])
        response = self.client.get(url)
        response_data = response.data
        response_data['id'] = instance.id
        return self.assertDictEqual(response_data, model_to_dict(instance))
    
    def test_create_breed_only_if_admin(self):

        data = {'value': 'Doberman'}
        url = reverse_lazy('breeds-list')
        response = self.client.post(url, data, format='json')
        
        return self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    def test_delete_breed_only_if_admin(self):

        data = {'value': 'Doberman'}
        breed = Breed.objects.create(**data)

        url = reverse_lazy('breeds-detail', kwargs={'pk': breed.id})
        response = self.client.delete(url)

        return self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    

