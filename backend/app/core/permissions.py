from rest_framework.permissions import BasePermission
from django.utils.translation import gettext_lazy as _
from django.contrib.auth import get_user_model
from core.models import Session

class IsLogged(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        res = Session.is_logged(user) or user.is_superuser
        return bool(res)


