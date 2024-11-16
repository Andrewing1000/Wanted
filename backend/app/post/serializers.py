"""
Serializers for the post app.
"""
from rest_framework import serializers
from post.models import LostPetPost, PetSightingPost, Comment, Message
from django.contrib.contenttypes.models import ContentType
from django.contrib.auth import get_user_model


class LostPetPostSerializer(serializers.ModelSerializer):
    """Serializer for lost pet posts."""

    owner = serializers.ReadOnlyField(source='owner.email')

    class Meta:
        model = LostPetPost
        fields = [
            'id', 'owner', 'pet_name', 'species', 'breed', 'color',
            'description', 'photo', 'date_lost', 'last_seen_location',
            'reward_amount', 'date_created',
        ]
        read_only_fields = ['id', 'owner', 'date_created']


class PetSightingPostSerializer(serializers.ModelSerializer):
    """Serializer for pet sighting posts."""

    reporter = serializers.ReadOnlyField(source='reporter.email')
    lost_pet_post = serializers.PrimaryKeyRelatedField(
        queryset=LostPetPost.objects.all(),
        required=False,
        allow_null=True,
    )

    class Meta:
        model = PetSightingPost
        fields = [
            'id', 'reporter', 'lost_pet_post', 'species', 'color',
            'description', 'photo', 'date_sighted', 'location', 'date_created',
        ]
        read_only_fields = ['id', 'reporter', 'date_created']


class CommentSerializer(serializers.ModelSerializer):
    """Serializer for comments."""

    user = serializers.ReadOnlyField(source='user.email')
    replies = serializers.SerializerMethodField()
    content_type = serializers.CharField(write_only=True, required=False)
    object_id = serializers.IntegerField(write_only=True, required=False)
    parent_id = serializers.IntegerField(write_only=True, required=False)

    class Meta:
        model = Comment
        fields = [
            'id', 'user', 'content', 'date_created', 'content_type', 'object_id',
            'parent_id', 'replies',
        ]
        read_only_fields = ['id', 'user', 'date_created', 'replies']

    def get_replies(self, obj):
        if obj.replies.exists():
            return CommentSerializer(obj.replies.all(), many=True).data
        return []

    def validate(self, attrs):
        """Ensure that the comment is associated with a valid post or parent comment."""
        content_type = attrs.get('content_type')
        object_id = attrs.get('object_id')
        parent_id = attrs.get('parent_id')

        if parent_id:
            if content_type or object_id:
                raise serializers.ValidationError("Provide either 'parent_id' or 'content_type' and 'object_id', not both.")
            try:
                parent_comment = Comment.objects.get(id=parent_id)
                attrs['parent'] = parent_comment
            except Comment.DoesNotExist:
                raise serializers.ValidationError("Parent comment does not exist.")
        else:
            if not content_type or not object_id:
                raise serializers.ValidationError("Provide 'content_type' and 'object_id' for commenting on a post.")
            try:
                model = ContentType.objects.get(model=content_type).model_class()
                if not model.objects.filter(id=object_id).exists():
                    raise serializers.ValidationError("Object does not exist.")
            except ContentType.DoesNotExist:
                raise serializers.ValidationError("Invalid content type.")
        return attrs

    def create(self, validated_data):
        parent = validated_data.pop('parent', None)
        content_type = validated_data.pop('content_type', None)
        object_id = validated_data.pop('object_id', None)

        if parent:
            comment = Comment.objects.create(
                user=self.context['request'].user,
                parent=parent,
                **validated_data
            )
        else:
            content_type_instance = ContentType.objects.get(model=content_type)
            comment = Comment.objects.create(
                user=self.context['request'].user,
                content_type=content_type_instance,
                object_id=object_id,
                **validated_data
            )
        return comment


class MessageSerializer(serializers.ModelSerializer):
    """Serializer for messages between users."""

    sender = serializers.ReadOnlyField(source='sender.email')
    receiver = serializers.EmailField()

    class Meta:
        model = Message
        fields = [
            'id', 'sender', 'receiver', 'subject', 'body', 'date_sent', 'is_read',
        ]
        read_only_fields = ['id', 'sender', 'date_sent', 'is_read']

    def create(self, validated_data):
        receiver_email = validated_data.pop('receiver')
        User = get_user_model()
        try:
            receiver = User.objects.get(email=receiver_email)
        except User.DoesNotExist:
            raise serializers.ValidationError("Receiver does not exist.")

        message = Message.objects.create(
            sender=self.context['request'].user,
            receiver=receiver,
            **validated_data
        )
        return message
