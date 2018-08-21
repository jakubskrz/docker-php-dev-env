FROM php:7.2-fpm

# Install apt-get and system utilities
RUN apt-get update && apt-get install -yqq \
    curl apt-utils apt-transport-https gnupg debconf-utils gcc build-essential

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -yqq \
    locales zlib1g-dev libpq-dev libicu-dev libicu57 \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    git libldap2-dev libmemcached-dev ssmtp libgss3

# Add Microsoft repo for Microsoft ODBC Driver for Linux
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install SQL Server drivers
RUN apt-get update && ACCEPT_EULA=Y apt-get install -yqq unixodbc-dev msodbcsql17

# Generate necessary locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
RUN docker-php-ext-install opcache

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
    git libicu-dev unixodbc-dev \
    devscripts debhelper dh-exec dh-autoreconf

RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /temp/*
