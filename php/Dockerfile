# Use Alpine Linux
FROM php:8.1-fpm-alpine

LABEL maintainer="Angel S. Moreno <angelxmoreno@gmail.com>"

# Set working directory first (this ensures the repo is cloned to the correct place)
WORKDIR /var/www/html

# Extract PHP source (best practice for extension compilation)
RUN docker-php-source extract

# Install Git separately so it's not removed
RUN apk add --no-cache git

# Install build dependencies (temporary, removed later)
RUN apk add --no-cache --virtual .buildPacks \
    autoconf \
    g++ \
    make \
    curl \
    unzip

# Install required libraries
RUN apk add --no-cache \
    icu-dev \
    oniguruma-dev

# Install PHP extensions
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install intl
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mbstring

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Cleanup build dependencies
RUN docker-php-source delete \
    && apk del .buildPacks \
    && rm -rf /var/cache/apk/*

# Copy php.ini settings from the `php` directory
COPY ./php/php.ini /usr/local/etc/php/php.ini

# Clone the latest version of the application using a GitHub PAT
ARG GITHUB_USERNAME
ARG GITHUB_ACCESS_TOKEN
ARG GITHUB_REPO
RUN git clone https://${GITHUB_USERNAME}:${GITHUB_ACCESS_TOKEN}@github.com/${GITHUB_REPO}.git .

# Install PHP dependencies (including dev dependencies)
RUN composer install --optimize-autoloader

# Ensure the database is ready before running migrations and seeds
COPY ./php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set default command
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
