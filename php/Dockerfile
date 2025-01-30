# Use Alpine Linux
FROM php:8.1-fpm-alpine

LABEL maintainer="Angel S. Moreno <angelxmoreno@gmail.com>"

# Extract PHP source (best practice for extension compilation)
RUN docker-php-source extract

# Install build dependencies (temporary)
RUN apk add --no-cache --virtual .buildPacks \
    autoconf \
    g++ \
    make \
    curl \
    git \
    unzip

# Install required libraries
RUN apk add --no-cache \
    icu-dev \
    oniguruma-dev

# Install PHP extensions
RUN pecl install redis && docker-php-ext-enable redis \
    && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mbstring

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Cleanup build dependencies
RUN docker-php-source delete \
    && apk del .buildPacks \
    && rm -rf /var/cache/apk/*

# Copy php.ini settings from the `php` directory
COPY ./php/php.ini /usr/local/etc/php/php.ini

# Set working directory
WORKDIR /var/www/html

# Clone the latest version of the application using a GitHub PAT
ARG GITHUB_USERNAME
ARG GITHUB_ACCESS_TOKEN
ARG GITHUB_REPO

RUN git clone https://${GITHUB_USERNAME}:${GITHUB_ACCESS_TOKEN}@github.com/${GITHUB_REPO}.git .

# Install PHP dependencies for the app
RUN composer install --no-dev --optimize-autoloader

# Set default command
CMD ["php-fpm"]
