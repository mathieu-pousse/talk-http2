#!/bin/bash

BASEDIR=$(cd $(dirname $0); pwd)

mkdir -p $BASEDIR/etc/nginx/tls

openssl req -x509 -nodes -days 365 \
            -newkey rsa:2048 \
            -keyout $BASEDIR/etc/nginx/tls/server.key \
            -out $BASEDIR/etc/nginx/tls/server.crt \
            -subj '/CN=127.0.0.1/O=wima/C=FR'

openssl x509 -in $BASEDIR/etc/nginx/tls/server.crt \
             -out $BASEDIR/etc/nginx/tls/server.pem \
             -outform PEM

docker run --rm \
           -p 80:80 -p 443:443 \
           -v $BASEDIR/../html/dist:/data/www:ro \
           -v $BASEDIR/etc/nginx/conf.d:/etc/nginx/conf.d \
           -v $BASEDIR/etc/nginx/tls:/etc/nginx/tls \
           nginx

