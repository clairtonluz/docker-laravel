FROM alpine:3.8

RUN apk --update add --no-cache \
        nginx \
        curl \
        supervisor \
        php7 \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fpm \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-opcache \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-phar \
        php7-session \
        php7-tokenizer \
        php7-xml

RUN rm -Rf /var/cache/apk/*

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

COPY nginx.conf /etc/nginx/nginx.conf

COPY supervisord.conf /etc/supervisord.conf

RUN mkdir -p /app

WORKDIR /app

RUN chmod -R 755 /app

EXPOSE 80 443

CMD ["supervisord", "-c", "/etc/supervisord.conf"]