import os
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = 'django-insecure-s$c^ea-ryrf$krzr*&xah&&&t80x&+upr@46&snh3gg(y@bagq'

DEBUG = True

WSGI_APPLICATION = 'app.wsgi.application'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

AUTH_USER_MODEL = 'core.User'


ALLOWED_HOSTS = [
    '*',
    '10.0.2.2',
    '127.0.0.1',
    'localhost',
]


INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django_password_validators',
    'django_password_validators.password_history',
    'corsheaders',
    'rest_framework',
    'rest_framework.authtoken',
    'drf_spectacular',
    'core',
    'user',
    'post',
    'django_filters',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    #'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'app.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'HOST' : os.environ.get('DB_HOST'),
        'NAME' : os.environ.get('DB_NAME'),
        'USER' : os.environ.get('DB_USER'),
        'PASSWORD' : os.environ.get('DB_PASS'),
        # 'PORT' : "5432",
        # 'HOST': "0.0.0.0"
    }
}


# Password validation
# https://docs.djangoproject.com/en/3.2/ref/settings/#auth-password-validators

'''AUTH_PASSWORD_VALIDATORS = [

    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },

     {
        'NAME': 'django_password_validators.password_character_requirements.password_validation.PasswordCharacterValidator',
        'OPTIONS': {
                'min_length_digit': 1,
                'min_length_alpha': 12,
                'min_length_special': 1,
                'min_length_lower': 1,
                'min_length_upper': 1,
                'special_characters': "~!@#$%^&*()_+{}\":;'[]"
            }
    },

]
'''

# Internationalization
# https://docs.djangoproject.com/en/3.2/topics/i18n/

#LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True
USE_L10N = True
USE_TZ = True

LANGUAGE_CODE = 'es'

LANGUAGES = [
    ('es', 'Spanish'),
    ('en', 'English'),
]

LOCALE_PATHS = [
    os.path.join(BASE_DIR, 'locale'),
]


REST_FRAMEWORK = {
    'DEFAULT_FILTER_BACKENDS': ['django_filters.rest_framework.DjangoFilterBackend'],


    'DEFAULT_SCHEMA_CLASS' : 'drf_spectacular.openapi.AutoSchema',

    'DEFAULT_THROTTLE_CLASSES': [

        'rest_framework.throttling.AnonRateThrottle',

        'rest_framework.throttling.UserRateThrottle',

    ],

    #'DEFAULT_THROTTLE_RATES': {

        #'anon': '20/min',

        #'user': '50/min',

        #'login' : '3/min',
    #},
}

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'laboratoriofisicaucb@gmail.com'
EMAIL_HOST_PASSWORD = '#password#labo'

SESSION_ENGINE = 'django.contrib.sessions.backends.db'
AUTHENTICATION_BACKENDS = ["django.contrib.auth.backends.ModelBackend"]

SESSION_COOKIE_AGE = 900

STATIC_URL = '/static/static/'
MEDIA_URL = '/static/media/'

MEDIA_ROOT = '/vol/web/media'
STATIC_ROOT = '/vol/web/static'



CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True

CORS_ALLOW_HEADERS = [
    'authorization',
    'content-type',
    'x-csrftoken',
    'set-cookie',
]

CORS_EXPOSE_HEADERS = ['Set-Cookie']

CSRF_TRUSTED_ORIGINS = ['http://localhost:8000',
                        'http://127.0.0.1:8000',
                        'http://localhost:65420',
                        'http://localhost:58315']  # Add your domain


CSRF_COOKIE_NAME = 'csrftoken'
CSRF_COOKIE_HTTPONLY = False
CSRF_COOKIE_SECURE = True  # Asegúrate de que sea False solo si no estás usando HTTPS
CSRF_COOKIE_SAMESITE = 'None'  # 'None' si 'Lax' no funciona para tus necesidades

# Configuración para la cookie de sesión
SESSION_COOKIE_HTTPONLY = False
SESSION_COOKIE_SECURE = True  # Asegúrate de que sea False solo si no estás usando HTTPS
SESSION_COOKIE_SAMESITE = 'None'

SPECTACULAR_SETTINGS = {
    'COMPONENT_SPLIT_REQUEST' : True,
}