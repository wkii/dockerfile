# 使用最新的 php8-fpm 的镜像，基础镜像是 debian11(bullseye)
FROM php:8-fpm

# # 设定时区
ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone  \
&& echo "deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib" > /etc/apt/sources.list \
&& echo "deb-src https://mirrors.aliyun.com/debian/ bullseye main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb https://mirrors.aliyun.com/debian-security/ bullseye-security main" >> /etc/apt/sources.list \
&& echo "deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main" >> /etc/apt/sources.list \
&& echo "deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb-src https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib" >> /etc/apt/sources.list \
&& apt update \
&& apt install -y --no-install-recommends autoconf g++ gcc make \
&& apt install -y nginx curl telnet procps inetutils-ping \
&& apt install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libbz2-dev libmcrypt-dev libmpdec-dev \
# 安装 PHP 扩展
&& pecl install decimal && docker-php-ext-enable decimal \
&& pecl install redis && docker-php-ext-enable redis \
&& pecl install mcrypt && docker-php-ext-enable mcrypt \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) pdo_mysql opcache bcmath gd bz2 calendar gettext \
# 释放空间
&& apt remove -y m4 autoconf make gcc g++ && apt-get purge -y --auto-remove \
&& rm -rf /var/lib/apt/lists/*; pecl update-channels; rm -rf /tmp/pear \
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
&& rm -fr /usr/local/etc/php-fpm.d/zz-docker.conf \
# nginx 相关
&& cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak \
&& sed -i "s/user nginx;/user www-data;/" /etc/nginx/nginx.conf \
# 删除多余的加载
&& sed -i "s/include \/etc\/nginx\/sites-enabled\/*;//" /etc/nginx/nginx.conf \
&& rm -fr /var/www/html/* && rm -rf /etc/nginx/sites-enabled/* \
# 写启动文件
&& echo "#!/bin/bash" > /opt/run.sh \
&& echo "php-fpm -D" >> /opt/run.sh \
&& echo "nginx -g 'daemon off;'" >> /opt/run.sh \
&& chmod +x /opt/run.sh

# 复制文件
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
# EXPOSE 9000

CMD ["/opt/run.sh"]

#使用：
# 1、From php+nginx 的基础镜像
# 2、复制站点内容进入容器
# COPY index.php /var/www/html/
# 3、设置目录权限
# RUN chown -R  www-data:www-data /var/www/html/