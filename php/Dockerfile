FROM php:7.1-fpm

# Add Microsoft repo for Microsoft ODBC Driver 13 for Linux
RUN apt-get update && apt-get install -yqq \
    apt-transport-https \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install Dependencies
RUN apt-get update && ACCEPT_EULA=Y apt-get install --no-install-recommends -yqq \
    libmcrypt-dev zlib1g-dev libpq-dev libicu-dev \
    libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
    git unzip wget libldap2-dev libmemcached-dev ssmtp libgss3 \
    libicu52 odbcinst unixodbc unixodbc-dev msodbcsql locales

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install intl

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install ldap

RUN pecl install pdo_sqlsrv \
    && docker-php-ext-enable pdo_sqlsrv

# Install memcached extension
RUN git clone https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && cd /usr/src/php/ext/memcached && git checkout -b php7 origin/php7 \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Setup ssmtp for relaying mails to mailcatcher container
RUN echo "mailhub=mailcatcher:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# Clean up
RUN apt-get remove -y \
    git unzip libicu-dev unixodbc-dev \
    devscripts debhelper dh-exec dh-autoreconf

RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /temp/*
