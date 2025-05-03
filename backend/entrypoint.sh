#!/bin/sh

# Espera a la base de datos
python manage.py wait_for_db

# Ejecuta migraciones
python manage.py migrate --noinput

# En producción, recolecta estáticos
if [ "$DEV" = "false" ]; then
  python manage.py collectstatic --noinput
fi

# Finalmente, ejecuta el CMD del contenedor (runserver u otro)
exec "$@"
