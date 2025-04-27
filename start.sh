# Wait for Postgres to be ready
echo "Waiting for postgres at $SQL_HOST:$SQL_PORT..."
while ! nc -z $SQL_HOST $SQL_PORT; do
  sleep 1
done
echo "Postgres is up!"

# Fix permission issue for staticfiles
mkdir -p /app/staticfiles
chmod -R 777 /app/staticfiles

# Apply migrations and collect static files
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# Start Gunicorn
exec gunicorn ammentor_backend.wsgi:application --bind 0.0.0.0:8000