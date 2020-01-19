FROM php:7.3-fpm-alpine

#PRODUCTION LAYER

RUN apk add --no-cache --virtual .deps autoconf tzdata build-base libzip-dev mysql-dev \
            libxml2-dev libxslt-dev libpng-dev zlib-dev freetype-dev jpeg-dev icu-dev &&\
    docker-php-ext-install zip xml xsl mbstring json intl gd pdo pdo_mysql iconv &&\
    echo "date.timezone=Europe/Berlin" >> "$PHP_INI_DIR"/php.ini-production &&\
    echo "memory_limit=2048M"          >> "$PHP_INI_DIR"/php.ini-production &&\
    echo "date.timezone=Europe/Berlin" >> "$PHP_INI_DIR"/php.ini-development &&\
    echo "memory_limit=2048M"          >> "$PHP_INI_DIR"/php.ini-development &&\
    cp "$PHP_INI_DIR"/php.ini-production "$PHP_INI_DIR"/php.ini &&\
    echo "php_flag[display_errors]=off"                >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_flag[log_errors]=on"               >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_value[error_log]=/proc/self/fd/2"  >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_value[error_reporting]=E_ALL"      >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_value[display_startup_errors]=off" >> /usr/local/etc/php-fpm.conf &&\
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime &&\
    echo "Europe/Berlin" > /etc/timezone &&\
    echo "nameserver 1.1.1.1" >> /etc/resolv.conf &&\
    echo "nameserver 1.0.0.1" >> /etc/resolv.conf &&\
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf &&\
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf &&\
    mkdir -p /var/www &&\
    chown -R www-data:www-data /var/www &&\
    chmod -R 0774 /var/www &&\
    apk del .deps &&\
    apk add --no-cache libzip mysql libxml2 libxslt libpng zlib freetype jpeg icu unzip ca-certificates

WORKDIR /var/www

USER www-data

EXPOSE 9000

#DEVELOPMENT LAYER

USER root

RUN apk add --no-cache --virtual .deps autoconf build-base &&\
    pecl install xdebug-2.7.2 &&\
    docker-php-ext-enable xdebug &&\
    cp "$PHP_INI_DIR"/php.ini-development "$PHP_INI_DIR"/php.ini &&\
    echo "xdebug.remote_port=9000"                    >> "$PHP_INI_DIR"/php.ini &&\
    echo "php_flag[display_errors]=on"                >> /usr/local/etc/php-fpm.conf &&\
    echo "php_admin_value[display_startup_errors]=on" >> /usr/local/etc/php-fpm.conf &&\
    curl -fLs https://getcomposer.org/composer.phar > /bin/composer &&\
    chmod a+x /bin/composer &&\
    su www-data -s /bin/sh -c "composer global require fxp/composer-asset-plugin" &&\
    apk del .deps &&\
    apk add --no-cache git subversion

USER www-data
