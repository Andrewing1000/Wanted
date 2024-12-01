"""
Serializers for the post app.
"""
from rest_framework import serializers
from post.models import LostPetPost, PetSightingPost, Comment, Message, Species, Breed, Post, PetPhoto
from django.contrib.contenttypes.models import ContentType
from django.contrib.auth import get_user_model
from datetime import date
from django.core.exceptions import ValidationError

class SpeciesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Species
        fields = ['id', 'value']

class BreedSerializer(serializers.ModelSerializer):
    class Meta:
        model = Breed
        fields = ['id', 'value',]


class PetPhotoSerializer(serializers.ModelSerializer):

    post = serializers.PrimaryKeyRelatedField(queryset=Post.objects.all(), required=True)

    class Meta:
        model = PetPhoto
        fields = ['id', 'photo', 'post']
        read_only_fields = ['id']
        extra_kwargs = {'photo': {'required': True}}

class LostPetPostSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=get_user_model().objects.all(), required=False)
    species = serializers.PrimaryKeyRelatedField(queryset=Species.objects.all())
    breed = serializers.PrimaryKeyRelatedField(queryset=Breed.objects.all())

    class Meta:
        model = LostPetPost
        fields = [
            'id', 'user', 'pet_name', 'species', 'breed', 'color',
            'description', 'date_lost', 'latitude', 'longitude',
            'reward_amount', 'creation_date',
        ]
        read_only_fields = ['id', 'user', 'creation_date']

    def create(self, validated_data):
        return LostPetPost.objects.create(**validated_data)

    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        instance.save()
        return instance



class PetSightingPostSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=get_user_model().objects.all(), required=False)
    species = serializers.PrimaryKeyRelatedField(queryset=Species.objects.all())
    breed = serializers.PrimaryKeyRelatedField(queryset=Breed.objects.all())

    class Meta:
        model = PetSightingPost
        fields = [
            'id', 'user', 'species', 'breed', 'color',
            'description', 'date_sighted', 'latitude', 'longitude', 'creation_date',
        ]
        read_only_fields = ['id', 'user', 'creation_date']

    def validate(self, attrs):
        raw_date = attrs.get('date_sighted', None)
        if raw_date and raw_date > date.today():
            raise serializers.ValidationError(
                "Fecha de avistamiento: No puede estar en el futuro."
            )

        return attrs


    def create(self, validated_data):
        return PetSightingPost.objects.create(**validated_data)

    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        instance.save()
        return instance


class CommentSerializer(serializers.ModelSerializer):
    """Serializer for comments."""

    replies = serializers.SerializerMethodField()
    parent = serializers.PrimaryKeyRelatedField(queryset=Comment.objects.all(), required=False)
    post = serializers.PrimaryKeyRelatedField(queryset=Post.objects.all(), required=False)

    class Meta:
        model = Comment
        fields = [
            'id', 'user', 'content', 'creation_date',  'parent', 'replies', 'post',
        ]
        read_only_fields = ['id', 'user', 'creation_date', 'replies']

    def get_replies(self, obj):
        if obj.replies.exists():
            return CommentSerializer(obj.replies.all(), many=True).data
        return []

    def validate(self, attrs):
        parent = attrs.get('parent', None)
        post = attrs.get('post', None)

        if parent and post:
            raise serializers.ValidationError("Comment is either a root or a reply")
        
        if parent:
            if not Comment.objects.filter(id=parent.id).first:
                raise serializers.ValidationError("Parent commment could not be found")
            
        if post:
            if not Post.objects.filter(id=post.id).first():
                raise serializers.ValidationError("Post could not be found")

        return attrs
    
    def create(self, validated_data):
        user = validated_data.pop('user', None)
        parent = validated_data.pop('parent', None)
        post = validated_data.pop('post', None)

        if not parent and not post:
            raise ValidationError("Either a parent or a post is nedded")

        if parent:
            comment = Comment.objects.create(
                user=user,
                parent=parent,
                **validated_data
            )
        else:
            comment = Comment.objects.create(
                user=user,
                post=post,
                **validated_data
            )
        return comment
    
    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        instance.save()
        return instance


class MessageSerializer(serializers.ModelSerializer):
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

        return Message.objects.create(
            sender=self.context['request'].user,
            receiver=receiver,
            **validated_data
        )

    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        instance.save()
        return instance
