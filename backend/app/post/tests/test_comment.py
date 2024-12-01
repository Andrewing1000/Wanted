from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth import get_user_model
from django.urls import reverse_lazy
from datetime import datetime

from post.models import Comment, Post, LostPetPost, Breed, Species
from post.serializers import CommentSerializer, LostPetPostSerializer

class CommentTests(APITestCase):
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

        # Create species and breeds for LostPetPost
        self.species = Species.objects.create(value='Dog')
        self.breed = Breed.objects.create(value='Labrador')

        # Create a LostPetPost to comment on
        self.lost_pet_post = LostPetPost.objects.create(
            user=self.user,
            description="Lost my dog",
            pet_name="Buddy",
            breed=self.breed,
            species=self.species,
            color="FFFFFF",
            latitude=123.456,
            longitude=-123.456,
            date_lost='2021-01-01',
            reward_amount=100.00,
        )

    def test_create_comment_on_post(self):
        """
        Test creating a comment on a post.
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'content': 'I saw your dog nearby.',
            'post': self.lost_pet_post.id,
        }

        url = reverse_lazy('comment-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        comment = Comment.objects.get(id=response.data['id'])
        expected_data = CommentSerializer(comment).data

        self.assertEqual(response.data, expected_data)
        self.assertEqual(comment.user, self.user)
        self.assertEqual(comment.post.lostpetpost, self.lost_pet_post)
        self.assertIsNone(comment.parent)

    def test_create_reply_to_comment(self):
        """
        Test creating a reply to an existing comment.
        """
        # Create an initial comment
        parent_comment = Comment.objects.create(
            user=self.other_user,
            content='Any updates on your lost dog?',
            post=self.lost_pet_post,
        )

        self.client.force_authenticate(user=self.user)
        data = {
            'content': 'Not yet, still looking.',
            'parent': parent_comment.id,
        }

        url = reverse_lazy('comment-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        reply = Comment.objects.get(id=response.data['id'])
        expected_data = CommentSerializer(reply).data

        self.assertEqual(response.data, expected_data)
        self.assertEqual(reply.user, self.user)
        self.assertEqual(reply.parent, parent_comment)

    def test_list_comments_on_post(self):
        """
        Test listing comments on a post.
        """
        # Create comments
        Comment.objects.create(
            user=self.user,
            content='I think I saw your dog.',
            post=self.lost_pet_post,
        )
        Comment.objects.create(
            user=self.other_user,
            content='Hope you find your dog soon.',
            post=self.lost_pet_post,
        )

        url = f"{reverse_lazy('comment-list')}?post={self.lost_pet_post.id}"
        response = self.client.get(url)

        expected_comments = Comment.objects.filter(post=self.lost_pet_post).order_by('-creation_date')
        expected_data = CommentSerializer(expected_comments, many=True).data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, expected_data)

    def test_edit_own_comment(self):
        """
        Test that a user can edit their own comment.
        """
        comment = Comment.objects.create(
            user=self.user,
            content='Original comment.',
            post=self.lost_pet_post,
        )

        self.client.force_authenticate(user=self.user)
        data = {
            'content': 'Edited comment.',
        }

        url = reverse_lazy('comment-detail', args=[comment.id])
        response = self.client.patch(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        comment.refresh_from_db()
        self.assertEqual(comment.content, 'Edited comment.')

    def test_edit_other_user_comment(self):
        """
        Test that a user cannot edit someone else's comment.
        """
        comment = Comment.objects.create(
            user=self.other_user,
            content='Other user comment.',
            post=self.lost_pet_post,
        )

        self.client.force_authenticate(user=self.user)
        data = {
            'content': 'Attempted edit.',
        }

        url = reverse_lazy('comment-detail', args=[comment.id])
        response = self.client.patch(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

        comment.refresh_from_db()
        self.assertEqual(comment.content, 'Other user comment.')

    def test_delete_own_comment(self):
        """
        Test that a user can delete their own comment.
        """
        comment = Comment.objects.create(
            user=self.user,
            content='Comment to delete.',
            post=self.lost_pet_post,
        )

        self.client.force_authenticate(user=self.user)
        url = reverse_lazy('comment-detail', args=[comment.id])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Comment.objects.filter(id=comment.id).exists())

    def test_delete_other_user_comment(self):
        """
        Test that a user cannot delete someone else's comment.
        """
        comment = Comment.objects.create(
            user=self.other_user,
            content='Other user comment.',
            post=self.lost_pet_post,
        )

        self.client.force_authenticate(user=self.user)
        url = reverse_lazy('comment-detail', args=[comment.id])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertTrue(Comment.objects.filter(id=comment.id).exists())

    def test_admin_can_delete_any_comment(self):
        """
        Test that an admin can delete any comment.
        """
        comment = Comment.objects.create(
            user=self.other_user,
            content='Comment to be deleted by admin.',
            post=self.lost_pet_post,
        )

        self.client.force_authenticate(user=self.admin)
        url = reverse_lazy('comment-detail', args=[comment.id])
        response = self.client.delete(url)

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Comment.objects.filter(id=comment.id).exists())

    def test_create_comment_unauthenticated(self):
        """
        Test that unauthenticated users cannot create comments.
        """
        data = {
            'content': 'I saw your dog.',
            'post': self.lost_pet_post.id,
        }

        url = reverse_lazy('comment-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_reply_to_nonexistent_comment(self):
        """
        Test that replying to a nonexistent comment returns an error.
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'content': 'Replying to nonexistent comment.',
            'post': self.lost_pet_post.id,
            'parent': 9999,  # Assuming this ID does not exist
        }

        url = reverse_lazy('comment-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('parent', response.data)

    def test_retrieve_comment(self):
        """
        Test retrieving a single comment.
        """
        comment = Comment.objects.create(
            user=self.user,
            content='A comment.',
            post=self.lost_pet_post,
        )

        url = reverse_lazy('comment-detail', args=[comment.id])
        response = self.client.get(url)

        expected_data = CommentSerializer(comment).data

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, expected_data)

    def test_list_replies_to_comment(self):
        """
        Test listing replies to a comment.
        """
        parent_comment = Comment.objects.create(
            user=self.other_user,
            content='Parent comment.',
            post=self.lost_pet_post,
        )
        reply1 = Comment.objects.create(
            user=self.user,
            content='First reply.',
            post=self.lost_pet_post,
            parent=parent_comment,
        )
        reply2 = Comment.objects.create(
            user=self.admin,
            content='Second reply.',
            post=self.lost_pet_post,
            parent=parent_comment,
        )

        url = f"{reverse_lazy('comment-list')}?parent={parent_comment.id}"
        response = self.client.get(url)

        expected_replies = Comment.objects.filter(parent=parent_comment).order_by('-id')
        expected_data = CommentSerializer(expected_replies, many=True).data

        response_data = sorted(response.data, key= lambda x: x['id'], reverse=True)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, expected_data)

    def test_create_comment_missing_content(self):
        """
        Test that creating a comment without content fails.
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'post': self.lost_pet_post.id,
        }

        url = reverse_lazy('comment-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('content', response.data)

    def test_create_comment_on_nonexistent_post(self):
        """
        Test that creating a comment on a nonexistent post fails.
        """
        self.client.force_authenticate(user=self.user)
        data = {
            'content': 'Commenting on a nonexistent post.',
            'post': 9999,
        }

        url = reverse_lazy('comment-list')
        response = self.client.post(url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('post', response.data)
