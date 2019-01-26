FROM php:7.3-apache
ENV DEBIAN_FRONTEND noninteractive
RUN a2enmod rewrite
RUN apt-get update && apt-get install -y libpq-dev unzip libaio1 libfreetype6-dev \
    libjpeg62-turbo-dev libmcrypt-dev zlib1g-dev zip libbz2-dev libicu-dev g++
RUN pecl install mcrypt-1.0.2
RUN docker-php-ext-enable mcrypt
RUN docker-php-ext-install gd mysqli pgsql mbstring opcache bz2 intl

# RUN apt-get install -y zlib-dev
# RUN docker-php-ext-configure zip --with-libzip
# RUN docker-php-ext-install zip

RUN echo 'PassEnv ENV' > /etc/apache2/conf-enabled/expose-env.conf

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN mkdir -p /var/lib/php/sesion
RUN echo 'session.save_path = "5;/var/lib/php/sesion"' >> /usr/local/etc/php/php.ini

# # OCI8
ADD oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/
ADD oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/

RUN ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so

ENV LD_LIBRARY_PATH /usr/local/instantclient
ENV TNS_ADMIN /usr/local/instantclient
ENV ORACLE_BASE /usr/local/instantclient
ENV ORACLE_HOME /usr/local/instantclient

RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8

RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
&& docker-php-ext-install oci8

EXPOSE 80