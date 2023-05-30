FROM php:7.4-cli

USER root

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    libpng-dev \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    zip \
    curl \
    unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-source delete

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --version=1.9.1 --filename=composer && php -r "unlink('composer-setup.php');" || php -r "unlink('composer-setup.php');"

# RUN mv .env.sample .env

RUN COMPOSER_ALLOW_SUPERUSER=1

COPY . .

RUN composer install 


EXPOSE 8000

ENTRYPOINT [ "bash", "app.sh" ]