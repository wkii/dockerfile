# 使用说明：
# 1、From php+nginx 的基础镜像
# 2、复制站点内容进入容器
# COPY index.php /var/www/html/
# 3、使用自己的 nginx 配置，注意：如果不是覆盖 nginx.conf, 则复制 server 的配置文件到 /etc/nginx/http.d 这个目录中，为安全考虑可以覆盖掉 default.conf
#  因为使用 apk-add 安装的 nginx, conf.d目录默认不存在，并且默认的nginx.conf将其incloud在http段之前
# COPY nginx/app.conf /etc/nginx/http.d/default.conf
# 4、设置目录权限
# RUN chown -R  www-data:www-data /var/www/html/

# 基础镜像 php8-fpm 的 alpine 镜象
FROM php:8-fpm-alpine

ENV TZ Asia/Shanghai
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    # 设定时区，不能删除 tzdata
    && apk update && apk add tzdata && cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    # install extensions dependencies for php
    && apk upgrade --available && sync \
    && apk add --no-cache --virtual .build autoconf g++ gcc make \
    && apk add --no-cache --virtual .bash busybox-extras bash curl \
    && apk add --no-cache --virtual .nginx nginx \
    && apk add --no-cache --virtual .gd freetype libpng libjpeg-turbo \
    && apk add --no-cache --virtual .mcrypt libmcrypt-dev \
    && apk add --no-cache --virtual .gettext gettext \
    && apk add --no-cache --virtual .zip libzip-dev \
    && apk add --no-cache --upgrade --virtual .decimal mpdecimal-dev \
    && apk add --no-cache --virtual .build-deps \
    # bash
    curl-dev libc-dev libtool \
    # gd
    libjpeg-turbo-dev libpng-dev freetype-dev \
    # mbstring
    oniguruma-dev \
    # zip
    zlib-dev \
    # xml
    libxml2-dev \
    # gettext
    gettext-dev \
    && pecl install decimal && docker-php-ext-enable decimal \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install mcrypt && docker-php-ext-enable mcrypt \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    gettext \
    pdo_mysql \
    pcntl \
    soap \
    zip \
    # 清理空间
    && rm -rf /tmp/pear \
    && apk del .build .build-deps \
    #  更新配置, # php 相关
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && sed -i "s/expose_php = On/expose_php = Off/" /usr/local/etc/php/php.ini \
    && sed -i "s/memory_limit = 128M/memory_limit = 256M/" /usr/local/etc/php/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 10M/" /usr/local/etc/php/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 10M/" /usr/local/etc/php/php.ini \
    && sed -i "s/pm.max_children = 5/pm.max_children = 40/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.start_servers = 2/pm.start_servers = 5/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = 3/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = 5/" /usr/local/etc/php-fpm.d/www.conf \
    # nginx 相关
    && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak \
    && mkdir /etc/nginx/conf.d \
    # 写启动文件
    && echo "#!/bin/sh" > /opt/run.sh \
    && echo "php-fpm -D" >> /opt/run.sh \
    && echo "nginx -g 'daemon off;'" >> /opt/run.sh \
    && chmod +x /opt/run.sh

# 复制文件，注意是复制到 /etc/nginx/http.d 这个目录中 使用 apk-add 安装的 nginx, conf.d目录默认不存在，并且默认的nginx.conf将其incloud在http段之前
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["/opt/run.sh"]