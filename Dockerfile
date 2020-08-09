FROM m4rr/blogengine-docker:latest as AEGEA
LABEL maintainer "Marat Saytakov <remarr+docker@gmail.com>"

# -

FROM php:7.4-apache
LABEL maintainer "Marat Saytakov <remarr+docker@gmail.com>"

RUN mkdir -p /var/www/html
COPY --from=AEGEA /blogengine /var/www/html

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN apt-get update -y && apt-get install -y \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    libfreetype6-dev 
# RUN apt-get update && \
#     apt-get install -y \
#         zlib1g-dev 

RUN docker-php-ext-install mbstring

RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip 

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-freetype-dir 

RUN docker-php-ext-install gd

RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_balancer
RUN a2enmod proxy_http

EXPOSE 80
