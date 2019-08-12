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
RUN apk add --no-cache gcc
RUN apk add --no-cache libtool

RUN apk update

RUN docker-php-source extract
RUN docker-php-ext-install sockets
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install json
RUN docker-php-ext-install opcache

# Change the timezone into Asia/Jakarta
ENV TZ=Asia/Jakarta
RUN rm -rf /var/cache/apk/*

# Install Phalcon Framework
ENV PHALCON_VERSION=3.0.2

WORKDIR /usr/src/php/ext/

RUN set -xe
RUN curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz
RUN tar xzf v${PHALCON_VERSION}.tar.gz
RUN cd cphalcon-${PHALCON_VERSION}/build
RUN sh install
RUN echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini
RUN cd ../.. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} 

# Install nginx
RUN mkdir -p /run/nginx
RUN apk add --no-cache nginx
RUN rc-update add nginx default

# Add application directory
WORKDIR /cms
# COPY . /cms
# RUN mv /cms/app/config/env.ini.example /cms/app/config/env.ini
# RUN chmod -R o+w cache

# Stage runtime application
# COPY nginx.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT ["sh", "-c", "nginx && php-fpm"]

EXPOSE 80
