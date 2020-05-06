FROM php:7.4-fpm-alpine

# use mirror
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# install extensions dependencies for php
RUN apk add --no-cache --virtual .build autoconf g++ gcc make \
    && apk add --no-cache --virtual .bash bash curl openssh-client \
    && apk add --no-cache --virtual .memcached libmemcached cyrus-sasl \
    && apk add --no-cache --virtual .gd freetype libpng libjpeg-turbo \
    && apk add --no-cache --virtual .intl icu-libs \
    && apk add --no-cache --virtual .mcrypt libmcrypt \
    && apk add --no-cache --virtual .gettext gettext \
    && apk add --no-cache --virtual .zip libzip-dev \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    # bash
        curl-dev libc-dev libtool \
    # gd
        libjpeg-turbo-dev libpng-dev freetype-dev \
    # mcrypt
        libmcrypt-dev \
    # memcached
        libmemcached-dev cyrus-sasl-dev \
    # mongodb
    #    openssl-dev pcre-dev \
    # oniguruma
        oniguruma-dev \
    # zip
        zlib-dev \
    # xml
        libxml2-dev \
    # gettext
        gettext-dev \
    # icu
        icu-dev \
    && echo -e "\nInstall php extension..........................\n" \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j "${nproc}" \
        bcmath \
        exif \
        gd \
        gettext \
        iconv \
        intl \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql \
        pcntl \
        tokenizer \
        soap \
        xml \
        zip \
        opcache \
    && echo ==Mcrypt== \
    && pecl install mcrypt-1.0.3 && docker-php-ext-enable mcrypt \
    && echo "==Redis==" \
    && pecl install -o -f redis && docker-php-ext-enable redis \
    && rm -rf /tmp/pear \
    && echo "==Memcached=="  \
    && pecl install memcached && docker-php-ext-enable memcached \
    #### && echo "==MongoDb==" \
    #### && /bin/bash -lc "pecl install mongodb" \
    #### && docker-php-ext-enable mongodb \    
    && apk del .build .build-deps \
    #&& curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
&& { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/docker-php-ext-opcache-recommended.ini \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini