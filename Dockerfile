FROM php:7.2-apache

ENV TAO_VERSION "3.3-rc02"

RUN apt update

RUN set -eux; \
    apt install -y libmcrypt-dev zlib1g-dev; \
    pecl channel-update pecl.php.net; \
    pecl install mcrypt-1.0.1; \
    docker-php-ext-enable mcrypt; \
    docker-php-ext-install mysqli pdo pdo_mysql zip; \
    a2enmod rewrite

RUN set -eux; \
    apt install -y --no-install-recommends unzip git zip; \
    curl --silent --show-error https://getcomposer.org/installer | php


RUN set -eux; \
    curl -O -L https://github.com/oat-sa/package-tao/archive/v${TAO_VERSION}.zip; \
    unzip v${TAO_VERSION}.zip; \
    mv package-tao-${TAO_VERSION}/* /var/www/html; \
    rm -r package-tao-${TAO_VERSION}*

RUN php composer.phar install

RUN chown -R www-data:www-data /var/www/html
