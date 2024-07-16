#!/bin/sh
set -e
while ! nc -z "$POSTGRES_HOST" "$POSTGRES_PORT"; do
  echo "Waiting for PostgresSQL to start..."
  sleep 0.1
done
echo "PostgresSQL started"

export PYTHONPATH=/djangoProject:$PYTHONPATH  # Ensure djangoProject is in PYTHONPATH
cd /djangoProject  # Ensure we're in the correct directory

python manage.py collectstatic --noinput  # Collect static files
python manage.py migrate  # Apply database migrations
python manage.py runserver 0.0.0.0:8000  # Start Django's development server