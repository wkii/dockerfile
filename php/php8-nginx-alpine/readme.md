# 使用说明

1、From `php-fpm+nginx` 的基础镜像

```bash
FROM wkii/php-docker:8-fpm-alpine
```

2、复制站点内容进入容器

```bash
COPY index.php /var/www/html/
```

3、使用自己的 nginx 配置，注意：如果不是覆盖 `/etc/nginx/nginx.conf`, 则复制 server 的配置文件到 `/etc/nginx/conf.d` 这个目录中，可以覆盖掉 `default.conf`

> 因为使用 apk-add 安装的 nginx 和 nginx 独立镜像的配置不尽相同，尽量统一使用 nginx 镜像的配置结构。

```bash
COPY nginx/your_app.conf /etc/nginx/conf.d/default.conf
```

4、设置目录权限

```bash
RUN chown -R  www-data:www-data /var/www/html/
```

## 权限和目录说明

`PHP` 和 `Nginx` 的执行用户均是 `www-data`。

`Nginx` 默认目录 `/var/www/html`。
