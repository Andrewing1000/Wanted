"""
Database models
"""
from django.conf import settings
from django.db import models
from django.contrib.auth import get_user_model
import django.contrib.auth as DjangoAuth
from django.contrib.auth.models import (
    AbstractBaseUser,
    BaseUserManager,
)

from django.contrib.auth.password_validation import validate_password
from django.utils import timezone


class UserManager(BaseUserManager):
    """Manager for users."""

    def generate_email(self, names, last_names, extension, **extra_fields):
        names = names.split(' ')
        last_names = last_names.split(' ')
        if len(names) < 1 or len(last_names) < 1:
            raise ValueError('Nombre inválido')

        for namex in names:
            if not namex.isalpha():
                raise ValueError(f'El nombre {namex} inválido')
        for namex in last_names:
            if not namex.isalpha():
                raise ValueError(f'El apellido {namex} es inválido')

        names_str = names[0]
        last_names_str = last_names[0]

        names = '.' + '.'.join(names[1:]) if len(names) > 1 else ''
        last_names = '.' + '.'.join(last_names[1:]) if len(last_names) > 1 else ''

        new_email = f'{names_str}.{last_names_str}@{extension}.com'
        query = self.filter(email=new_email)
        i = 0
        j = 0
        c = 1
        while query.exists():
            if len(last_names_str) > j:
                last_names_str += last_names[j]
                if last_names[j] == '.':
                    j += 1
                    last_names_str += last_names[j]
            else:
                if len(names_str) > i:
                    names_str += names[i]
                    if names[i] == '.':
                        i += 1
                        names_str += names[i]
                else:
                    last_names_str += str(c)
                    c += 1
            new_email = f'{names_str}.{last_names_str}@{extension}.com'
            query = self.filter(email=new_email)

    def create_superuser(self, email, password):
        """Create and return a new superuser."""
        user = self.create_user(email, password)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, role=None, **extra_fields):
        """Create, save, and return a new user."""
        if not email:
            raise ValueError('User must have an email address')
        user = self.model(email=self.normalize_email(email), **extra_fields)
        validate_password(password)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_admin(self, email, password=None, **extra_fields):
        role = Role.getAdminRole()
        return self.create_user(email, password, role, **extra_fields)

    @classmethod
    def createSuperInstance(cls):
        data = {
            'email': 'admin@example.com',
            'password': 'admin',
        }
        admin = get_user_model().objects.filter(email=data['email']).first()
        if admin:
            print("Admin instance already created")
            return

        get_user_model().objects.create_superuser(**data)
        print("Admin instance created")


class User(AbstractBaseUser):
    """User in the system."""

    email = models.EmailField(max_length=255, unique=True)
    name = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=20, blank=True, null=True)  
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = 'email'

    def __str__(self):
        return self.email


class Session(models.Model):
    user = models.ForeignKey(get_user_model(), null=False, blank=False, on_delete=models.CASCADE)
    login_time = models.DateTimeField(auto_now_add=True)
    logout_time = models.DateTimeField(null=True, blank=True)

    @classmethod
    def get_last_session(cls, user):
        if not user.is_authenticated:
            return None
        last_session = cls.objects.filter(user=user).order_by('-login_time').first()
        return last_session

    @classmethod
    def get_open_session(cls, user):
        last_session = cls.get_last_session(user)
        if not last_session:
            return None
        if last_session.logout_time:
            return None
        return last_session

    @classmethod
    def is_logged(cls, user):
        if cls.get_open_session(user) and user.is_authenticated:
            return True
        return False

    @classmethod
    def logout(cls, user, request=None):
        if not user:
            user = request.user
        last_session = cls.get_open_session(user)
        if not last_session:
            return
        last_session.logout_time = timezone.now()
        last_session.save()
        DjangoAuth.logout(user)

    @classmethod
    def login(cls, user, request=None):
        if not user:
            user = request.user
        if not user.is_authenticated:
            return
        if cls.get_open_session(user):
            cls.logout(user)
        cls.objects.create(user=user)
        DjangoAuth.login(request, user)
