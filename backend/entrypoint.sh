#!/bin/sh
# entrypoint.sh

# 1) Espera a que la DB esté lista
python manage.py wait_for_db

# 2) Aplica migraciones
python manage.py migrate --noinput

# 3) (Opcional) recolecta estáticos si es modo prod
if [ "$DEV" = "false" ]; then
  python manage.py collectstatic --noinput
fi

# 4) Arranca el servidor en el puerto de la APP
exec "$@"
