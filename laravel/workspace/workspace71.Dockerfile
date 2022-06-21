
FROM phusion/baseimage:0.11

LABEL MAINTAINER="https://github.com/IDN/Media"

RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm
ENV PHP_VERSION=7.1
ENV TZ=Asia/Jakarta

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add the "PHP 7" ppa

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y software-properties-common ca-certificates && \
    add-apt-repository -y ppa:ondrej/php
#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#

# Install "PHP Extentions", "libraries", "Software's"
RUN apt-get update && \
    apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        php$PHP_VERSION-cli \
        php$PHP_VERSION-common \
        php$PHP_VERSION-curl \
        php$PHP_VERSION-json \
        php$PHP_VERSION-xml \
        php$PHP_VERSION-mbstring \
        php$PHP_VERSION-mysql \
        php$PHP_VERSION-sqlite \
        php$PHP_VERSION-sqlite3 \
        php$PHP_VERSION-dev \
        php$PHP_VERSION-bz2 \
        php$PHP_VERSION-bcmath \
        php$PHP_VERSION-calendar \
        php$PHP_VERSION-gd \
        php$PHP_VERSION-intl \
        php$PHP_VERSION-memcached \
        php$PHP_VERSION-mongodb \
        php$PHP_VERSION-mysqli \
        php$PHP_VERSION-opcache \
        php$PHP_VERSION-pgsql \
        php$PHP_VERSION-redis \
        php$PHP_VERSION-soap \
        php$PHP_VERSION-xdebug \
        php$PHP_VERSION-xsl \
        php$PHP_VERSION-zip \
        php$PHP_VERSION-mcrypt \
        php-pear \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3 \
        git \
        curl \
        vim \
        nano \
        postgresql-client \
        redis-tools \
        protobuf-compiler \
        libz-dev \
        zip wget \
        unzip \
        xdg-utils \
        libxpm4 \
        libxrender1 \
        libgtk2.0-0 \
        libnss3 \
        libgconf-2-4 \
        xvfb \
        gtk2-engines-pixbuf \
        xfonts-cyrillic \
        xfonts-100dpi xfonts-75dpi \
        xfonts-base \
        xfonts-scalable \
        x11-apps

RUN pecl install grpc && \
    echo "extension=grpc.so" > /etc/php/$PHP_VERSION/cli/conf.d/grpc.ini

RUN pecl install protobuf && \
    echo "extension=protobuf.so" > /etc/php/$PHP_VERSION/cli/conf.d/protobuf.ini
    

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
    && apt-get -y -f install \
    && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && wget https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/ \
    && rm chromedriver_linux64.zip

#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer
RUN . ~/.bashrc

ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

RUN groupadd -g ${PGID} developer && \
    useradd -u ${PUID} -g developer -m developer && \
    apt-get update -yqq

RUN ln -snf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && echo Asia/Jakarta > /etc/timezone

COPY ./composer.json /home/developer/.composer/composer.json

RUN chown -R developer:developer /home/developer/.composer
USER developer

RUN composer global install

ARG INSTALL_WORKSPACE_SSH=false
ENV INSTALL_WORKSPACE_SSH ${INSTALL_WORKSPACE_SSH}

ADD insecure_id_rsa /tmp/id_rsa
ADD insecure_id_rsa.pub /tmp/id_rsa.pub

USER root

RUN rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    && chmod 400 /root/.ssh/id_rsa

RUN mkdir /home/developer/.ssh

ADD insecure_id_rsa /tmp/id_rsa
ADD insecure_id_rsa.pub /tmp/id_rsa.pub

RUN rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /home/developer/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /home/developer/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /home/developer/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /home/developer/.ssh/authorized_keys /home/developer/.ssh/id_rsa.pub \
    && chmod 400 /home/developer/.ssh/id_rsa

COPY ./crontab /etc/cron.d
RUN chmod -R 644 /etc/cron.d

USER developer
COPY ./aliases.sh /home/developer/aliases.sh
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/developer/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc && \
    sed -i 's/\r//' /home/developer/aliases.sh && \
    sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /home/developer/aliases.sh

USER root
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/developer/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc && \
    sed -i 's/\r//' /home/developer/aliases.sh && \
    sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /home/developer/aliases.sh

RUN apt-get update && \
    apt-get install -y --force-yes php$PHP_VERSION-xdebug && \
    sed -i 's/^;//g' /etc/php/$PHP_VERSION/cli/conf.d/20-xdebug.ini && \
    echo "alias phpunit='php -dzend_extension=xdebug.so /var/www/vendor/bin/phpunit'" >> ~/.bashrc

COPY ./xdebug.ini /etc/php/$PHP_VERSION/cli/conf.d/xdebug.ini

ARG NODE_VERSION=12
ENV NVM_DIR /home/developer/.nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh  | bash \
        && . $NVM_DIR/nvm.sh \
        && nvm install ${NODE_VERSION} \
        && nvm use ${NODE_VERSION} \
        && nvm alias ${NODE_VERSION} \
        npm install -g gulp bower @vue/cli

RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

USER root

RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="/home/developer/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

ENV PATH $PATH:$NVM_DIR/versions/node/v${NODE_VERSION}/bin

USER developer

ARG INSTALL_YARN=false
ARG YARN_VERSION=latest

RUN [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    curl -o- -L https://yarnpkg.com/install.sh | bash; \
    echo "" >> ~/.bashrc && \
    echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bashrc

USER root

RUN echo "" >> ~/.bashrc && \
    echo 'export YARN_DIR="/home/developer/.yarn"' >> ~/.bashrc && \
    echo 'export PATH="$YARN_DIR/bin:$PATH"' >> ~/.bashrc

USER developer

RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="/var/www/vendor/bin:$PATH"' >> ~/.bashrc

USER developer

RUN composer global require "laravel/envoy"

USER root

RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc \
    && composer global require "laravel/installer"

USER root
RUN apt-get clean && apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/pear

WORKDIR /var/www
