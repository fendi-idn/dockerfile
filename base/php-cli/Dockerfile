#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM php:7.1-cli-alpine

MAINTAINER Donny Arieffian <donny.arieffian@gmail.com>

#
#--------------------------------------------------------------------------
# PHP Extension Installation
#--------------------------------------------------------------------------
#

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk add --no-cache bash openssl openssl-dev m4 perl autoconf dpkg-dev libbz2 dpkg libmagic file libstdc++ binutils-libs binutils gmp isl libgomp libatomic mpfr3 mpc1 gcc musl-dev libc-dev g++ make libpcre16 libpcre32 libpcrecpp pcre-dev re2c freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev shadow

# Install the PHP pdo_mysql
RUN docker-php-ext-install pdo_mysql

# Install the PHP gd library
RUN docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd

# Install the PHP redis
RUN pecl install redis && \
    docker-php-ext-enable redis

# Install the PHP mongodb
RUN /bin/bash -lc "pecl install mongodb" && \
  docker-php-ext-enable mongodb

# Install the PHP opcache
RUN docker-php-ext-install opcache

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

ADD ./laravel.ini /usr/local/etc/php/conf.d
ADD ./xlaravel.pool.conf /usr/local/etc/php-fpm.d/

RUN usermod -u 1000 www-data

RUN apk del --no-cache bash openssl openssl-dev m4 perl autoconf dpkg-dev libbz2 dpkg libmagic file libstdc++ binutils-libs binutils gmp isl libgomp libatomic mpfr3 mpc1 gcc musl-dev libc-dev g++ make libpcre16 libpcre32 libpcrecpp pcre-dev re2c freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev shadow

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
