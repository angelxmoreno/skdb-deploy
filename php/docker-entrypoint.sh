#!/bin/sh

echo "🔄 Waiting for database to be ready..."
until nc -z -v -w30 db 3306
do
  echo "⏳ Waiting for database connection..."
  sleep 5
done

echo "✅ Database is ready! Running migrations..."
bin/cake migrations migrate

echo "🌱 Running database seeds..."
bin/cake migrations seed

echo "🚀 Starting PHP-FPM..."
exec php-fpm
