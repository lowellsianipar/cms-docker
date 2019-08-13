# Stage build
FROM php:7.0-fpm-alpine

# Install dependency
RUN apk add --no-cache bash
RUN apk add --no-cache re2c
RUN apk add --no-cache openrc
RUN apk add --no-cache openssh
RUN apk add --no-cache curl
RUN apk add --no-cache tzdata
RUN apk add --no-cache autoconf g++ make 
RUN apk add --no-cache tzdata

RUN docker-php-source extract && \
    docker-php-ext-install sockets && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install tokenizer && \
    docker-php-ext-install json && \
    docker-php-ext-install opcache

# Change the timezone into Asia/Jakarta
ENV TZ=Asia/Jakarta
RUN rm -rf /var/cache/apk/*

# Install Phalcon Framework
ENV PHALCON_VERSION=3.0.2

WORKDIR /usr/src/php/ext/

RUN set -xe && \
    curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build && sh install && \
    echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
    cd ../.. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} 

# Install nginx
RUN mkdir -p /run/nginx
RUN apk add --no-cache nginx
RUN rc-update add nginx default

