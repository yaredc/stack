FROM nginx:1.17.7-alpine

RUN apk add --no-cache --virtual .deps tzdata &&\
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime &&\
    echo "Europe/Berlin" > /etc/timezone &&\
    echo "nameserver 1.1.1.1" >> /etc/resolv.conf &&\
    echo "nameserver 1.0.0.1" >> /etc/resolv.conf &&\
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf &&\
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf &&\
    apk del .deps &&\
    apk add --no-cache ca-certificates

COPY .docker/dev/conf.nginx /etc/nginx/conf.d/default.conf

EXPOSE 80 443
