"""
URL mapping for the user API.
"""
from django.urls import path

from user import views

app_name = 'user'

urlpatterns = [
    path('list/', views.ListUsersView.as_view(), name = 'list'),
    path('manage/', views.ManageUserView.as_view(), name='manage'),
    path('token/', views.CreateTokenView.as_view(), name='token'),
    path('me/', views.UserProfileView.as_view(), name = 'me'),
    path('logout/', views.LogoutView.as_view(), name = 'logout'),
    path('create/', views.CreateUserView.as_view(), name = 'create'),
]