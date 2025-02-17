from rest_framework.test import APITestCase
from  rest_framework import status
from django.contrib.auth import get_user_model
from django.urls import reverse_lazy
from django.forms.models import model_to_dict

from post.models import Species


class SpeciesModelTests(APITestCase):
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

    def test_get_speciess(self):
        speciess = [  
            Species(value='Cat'),
            Species(value= 'Dog'),
            Species(value= 'Masista'),
        ]
        Species.objects.bulk_create(speciess)

        expected_data = list(Species.objects.values())
        url = reverse_lazy('species-list')
        response = self.client.get(url)
        return self.assertListEqual(response.data, expected_data)
    
    def test_get_speciess_by_id(self):
        data = {'value': 'Gato'}
        instance = Species.objects.create(**data)

        url = reverse_lazy('species-detail', args=[instance.id])
        response = self.client.get(url)
        response_data = response.data
        response_data['id'] = instance.id
        return self.assertDictEqual(response_data, model_to_dict(instance))
    
    def test_create_speciess_if_admin(self):
        self.client.force_authenticate(self.admin)

        data = {'value': 'Gato'}
        url = reverse_lazy('species-list')
        response = self.client.post(url, data, format='json')
        id = response.data['id']
        
        try:
            expected_data = Species.objects.values().get(id=id)
        except:
            return False
        
        data['id'] = id
        return self.assertEqual(data, expected_data)
    
    def test_delete_speciess_if_admin(self):
        self.client.force_authenticate(self.admin)

        data = {'value': 'Gato'}
        species = Species.objects.create(**data)

        url = reverse_lazy('species-detail', kwargs={'pk': species.id})
        response = self.client.delete(url)
        return self.assertFalse(Species.objects.filter(id=species.id))
    
    def test_get_speciess_by_id(self):
        data = {'value': 'Gato'}
        instance = Species.objects.create(**data)

        url = reverse_lazy('species-detail', args=[instance.id])
        response = self.client.get(url)
        response_data = response.data
        response_data['id'] = instance.id
        return self.assertDictEqual(response_data, model_to_dict(instance))
    
    def test_create_species_only_if_admin(self):

        data = {'value': 'Perro'}
        url = reverse_lazy('species-list')
        response = self.client.post(url, data, format='json')
        
        return self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    def test_delete_species_only_if_admin(self):

        data = {'value': 'Perro'}
        species = Species.objects.create(**data)

        url = reverse_lazy('species-detail', kwargs={'pk': species.id})
        response = self.client.delete(url)

        return self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    

