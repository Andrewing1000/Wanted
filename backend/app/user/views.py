"""
Views for the user API.
"""
from rest_framework import generics, views, permissions, exceptions, authentication
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.settings import api_settings
from rest_framework import pagination
from rest_framework import status

from django.contrib.auth.models import AnonymousUser
from core.permissions import IsLogged
from core.utils import LogInThrottle

from django.contrib.auth import get_user_model, logout, login

from user.serializers import (
    AuthTokenSerializer,
    UserSerializer,
    ManageUserSerializer,
    HealthCheckSerializer,
)

from user.filters import UserFilter

from django.utils import timezone

from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema
from drf_spectacular.openapi import OpenApiParameter
from drf_spectacular.types import OpenApiTypes

class UserListPagination(pagination.CursorPagination):
    page_size = 10
    ordering = 'email'
    cursor_query_param = 'cursor'
    page_size_query_param = 'page_size'
    max_page_size = 100

    def get_paginated_response(self, data):
        return super().get_paginated_response(data)


class LogListPagination(pagination.CursorPagination):
    ordering = 'login_time'
    cursor_query_param = 'cursor'
    page_size_query_param = 'page_size'
    max_page_size = 100

    def get_paginated_response(self, data):
        return super().get_paginated_response(data)


class ListUsersView(generics.ListAPIView):
    """List shows users in the api"""
    serializer_class = UserSerializer
    #permission_classes = [HasRole([Role.get_admin()]), IsLogged]
    #pagination_class = UserListPagination
    queryset = get_user_model().objects.all().order_by('email')
    filterset_class = UserFilter

    def get_queryset(self):
        return get_user_model().objects.all()

    @extend_schema(parameters=[
        OpenApiParameter(
            name='rol',
            description="Filtrar usuarios por su rol.",
            required=False,
            type=str
        )
    ])
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)
    

class CreateTokenView(ObtainAuthToken):
    """Create a new auth toker for user."""
    #throttle_classes = [LogInThrottle]
    authentication_classes = []
    serializer_class = AuthTokenSerializer
    renderer_classes = api_settings.DEFAULT_RENDERER_CLASSES

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = serializer.validated_data.get('user')
        if not user:
            return Response({'message' : 'Credenciales inválidos'}, status=status.HTTP_401_UNAUTHORIZED)

        if(isinstance(user, AnonymousUser)):
            return Response({'message'  : 'El usuario no está registrado'}, status= status.HTTP_404_NOT_FOUND)

        login(request=request, user=user)
        response_serializer  = UserSerializer(instance = user)
        data = response_serializer.data
        token, created = Token.objects.get_or_create(user=user)
        data['token'] = token.key
        return Response(data = data, status=status.HTTP_200_OK)



class LogoutView(views.APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    def post(self, request, *args, **kwargs):
        if(isinstance(request.user, AnonymousUser)):
            return Response(status=status.HTTP_412_PRECONDITION_FAILED)
        logout(request=request)
        return Response(status=status.HTTP_202_ACCEPTED)


class UserProfileView(generics.RetrieveUpdateAPIView):
    """Manage the authenticated user."""
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        """Retrieve and return the authenticated user."""
        return self.request.user


class ManageUserView(generics.RetrieveUpdateAPIView):
    """Edit user profiles"""
    serializer_class = ManageUserSerializer
    #permission_classes = [HasRole([Role.get_admin()]), IsLogged]

    def get_object(self):
        """Retrieve and return the user by its email."""
        body_data = UserSerializer(self.request.data).data
        email =  body_data.get('email', None)
        if not email:
            raise MissingQueryParameterException(detail="Ingrese el parámetro de email")
        return get_object_or_404(get_user_model(), email = email)


class CreateUserView(generics.CreateAPIView):
    """Edit user profiles"""
    serializer_class = UserSerializer

    @extend_schema(parameters=[
        OpenApiParameter(
            name='email',
            description="Find users by their email.",
            required=True,
            type=bool
        )
    ])
    def get_object(self):
        """Retrieve and return the user by its email."""
        email_param = self.request.query_params.get('email', None)
        if not email_param:
            raise MissingQueryParameterException(detail="Ingrese el parámetro de email")
        return get_object_or_404(get_user_model(), email = email_param)


class HealthCheck(views.APIView):
    serializer_class = HealthCheckSerializer
    def get(self, request, *args, **kargs):
        return Response({'status':'OK'}, status=status.HTTP_200_OK)


class MissingQueryParameterException(exceptions.APIException):
    status_code = 400
    default_detail = 'Falta un parámetro query.'
    default_code = 'missing_query_parameter'

