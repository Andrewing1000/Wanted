"""
Tests para la API de usuario.
"""
from django.contrib.auth import get_user_model
from django.urls import reverse

from rest_framework.test import APITestCase
from rest_framework import status

CREATE_USER_URL = reverse("user:create")
TOKEN_URL = reverse("user:token")
ME_URL = reverse("user:me")


def create_user(**params):
    """Crea y devuelve un usuario estándar."""
    return get_user_model().objects.create_user(**params)


def create_admin(**params):
    """Crea y devuelve un usuario administrador."""
    return get_user_model().objects.create_superuser(**params)

class PublicUserAPITests(APITestCase):
    """Tests de endpoints públicos (sin token)."""

    @classmethod
    def setUpTestData(cls):
        cls.user_data = {
            'email': 'admin@example.com',
            'password': 'StrongPassw0rd!',
            'name': 'Admin User',
        }
        create_admin(**cls.user_data)

    def test_create_user_success(self):
        payload = {
            'email': 'newuser@example.com',
            'password': 'NewStrongPass1!',
            'name': 'New User',
        }
        res = self.client.post(CREATE_USER_URL, payload)
        self.assertEqual(res.status_code, status.HTTP_201_CREATED)
        user = get_user_model().objects.get(email=payload['email'])
        self.assertTrue(user.check_password(payload['password']))
        self.assertNotIn('password', res.data)

    def setUp(self):
        self.client.force_authenticate(user=self.user)

    def test_retrieve_profile_success(self):
        res = self.client.get(ME_URL)
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(res.data, {
            'name': self.user.name,
            'email': self.user.email,
            'is_active': True,
            'is_staff': True,
        })

    def test_create_user_duplicate_email(self):
        payload = {
            'email': self.user_data['email'],
            'password': 'AnotherPass1!',
            'name': 'Another',
        }
        res = self.client.post(CREATE_USER_URL, payload)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    def test_password_too_short(self):
        payload = {
            'email': 'short@example.com',
            'password': '123',
            'name': 'Short Pass',
        }
        res = self.client.post(CREATE_USER_URL, payload)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)
        exists = get_user_model().objects.filter(email=payload['email']).exists()
        self.assertFalse(exists)

    def test_create_token_valid_credentials(self):
        payload = {
            'email': self.user_data['email'],
            'password': self.user_data['password'],
        }
        res = self.client.post(TOKEN_URL, payload)
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertIn('token', res.data)

    def test_create_token_invalid_credentials(self):
        payload = {
            'email': self.user_data['email'],
            'password': 'WrongPass!',
        }
        res = self.client.post(TOKEN_URL, payload)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertNotIn('token', res.data)

    def test_create_token_blank_password(self):
        payload = {'email': self.user_data['email'], 'password': ''}
        res = self.client.post(TOKEN_URL, payload)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertNotIn('token', res.data)

    def test_get_me_unauthenticated(self):
        res = self.client.get(ME_URL)
        self.assertEqual(res.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_reject_unexpected_fields(self):
        payload = {
            'email1': 'user@example.com',
            'password': 'DoesntMatter1!',
            'name': 'User',
            'extra': 'field',
        }
        res = self.client.post(CREATE_USER_URL, payload)
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    def test_token_throttling(self):
        # Intentamos fallos repetidos para activar throttling
        bad_payload = {'email': self.user_data['email'], 'password': 'BadPass1!'}
        for _ in range(5):
            self.client.post(TOKEN_URL, bad_payload)
        # Ahora incluso con credenciales correctas, debe dar 429
        good_payload = {
            'email': self.user_data['email'],
            'password': self.user_data['password'],
        }
        res = self.client.post(TOKEN_URL, good_payload)
        self.assertEqual(res.status_code, status.HTTP_429_TOO_MANY_REQUESTS)


class PrivateUserAPITests(APITestCase):
    """Tests de endpoints que requieren autenticación."""

    @classmethod
    def setUpTestData(cls):
        cls.admin_credentials = {
            'email': 'private@example.com',
            'password': 'PrivatePass1!',
            'name': 'Private User',
        }
        cls.user = create_admin(**cls.admin_credentials)

    def setUp(self):
        self.client.force_authenticate(user=self.user)

    def test_retrieve_profile_success(self):
        res = self.client.get(ME_URL)
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(res.data, {
            'name': self.user.name,
            'email': self.user.email,
            'is_active': True,
            'is_staff': True,
        })

    def test_post_me_not_allowed(self):
        res = self.client.post(ME_URL, {})
        self.assertEqual(res.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_update_profile(self):
        payload = {
            'name': 'Updated Name',
            'password': 'NewPrivatePass2!',
        }
        res = self.client.patch(ME_URL, payload)
        self.user.refresh_from_db()
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(self.user.name, payload['name'])
        self.assertTrue(self.user.check_password(payload['password']))
