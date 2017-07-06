FROM php:7.1-fpm

RUN apt-get update && apt-get install -yqq \
    libmcrypt-dev zlib1g-dev libpq-dev libicu-dev \
    libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
    git unzip wget libldap2-dev

RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install intl

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install ldap

# Clean up
RUN apt-get remove -y \
    git unzip libicu-dev unixodbc-dev \
    devscripts debhelper dh-exec dh-autoreconf

RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /temp/*
