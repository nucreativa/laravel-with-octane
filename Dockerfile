FROM ghcr.io/roadrunner-server/roadrunner:latest AS roadrunner
FROM php:8.1-cli

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

RUN apt update && apt install -y \
    g++ \
    libmcrypt-dev \
    libicu-dev \
    libpq-dev \
    libzip-dev \
    zip \
    zlib1g-dev \
    && docker-php-ext-install \
    intl \
    opcache \
    pdo \
    sockets

WORKDIR /app
COPY . /app

RUN composer install

EXPOSE 8000

CMD php artisan octane:start --host=0.0.0.0 --port=8000
