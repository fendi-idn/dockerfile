ARG PHP_VERSION=8.0

FROM php:$PHP_VERSION-fpm

LABEL MAINTAINER="https://github.com/IDN/Media"

#
#--------------------------------------------------------------------------
# PHP Extension Installation
#--------------------------------------------------------------------------
#

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y  tzdata \
                        openssl \
                        libssl-dev \
                        build-essential \
                        libfreetype6 \
                        libjpeg62-turbo \
                        libfreetype6-dev \
                        libpng-dev \
                        libjpeg62-turbo-dev \
                        xml-core \
                        redis-tools \
                        libzip-dev \
                        zip \
                        && rm -rf /var/lib/apt/lists/*

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install php extensions
RUN install-php-extensions \
            bz2 \
            bcmath \
            calendar \
            gd \
            grpc \
            mongodb \
            mysqli \
            opcache \
            pcntl \
            pdo_mysql \
            protobuf \
            redis \
            soap \
            xdebug \
            xsl \
            zip && \
# Cleaning up
            rm -rf /tmp/pear

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

# COPY xdebug config
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Set Timezone
RUN ln -snf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && echo Asia/Jakarta > /etc/timezone

COPY config/php-fpm.conf /usr/local/etc/
COPY config/php.ini /usr/local/etc/php/
COPY config/www.conf /usr/local/etc/php-fpm.d/

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
