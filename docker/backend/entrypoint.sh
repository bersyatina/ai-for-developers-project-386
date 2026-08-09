#!/bin/sh
set -e

# Кэшируем конфиг (необходим APP_KEY из окружения).
php artisan config:cache || true

# Применяем миграции перед стартом.
php artisan migrate --force

# Запускаем php-fpm в фоне и nginx на переднем плане.
php-fpm -D
nginx -g 'daemon off;'
