#!/bin/bash
# for docker build
# docker build -t wkii/php-docker:nginx-fpm8-alpine -f Dockerfile .

# for docker buildx
# before use: docker buildx create --name mybuilder --driver docker-container && docker buildx use mybuilder
docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t wkii/php-docker:nginx-fpm8-alpine -f Dockerfile . --push
