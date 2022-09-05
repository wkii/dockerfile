# php-fpm docker images

From PHP official images: "php:7.4-fpm-alpine", and add extensions: 
```
bcmath,decimal,exif,gd,gettext,intl,pdo_mysql,pcntl,tokenizer,soap,xml,zip,opcache,redis,memcached
```

tag: `last`,`7.4.30-fpm`  without `composer` and `git`

tag: `7.4.30-fpm-rich` with `composer` and `git`

All soft from official, so absolutely safe.
