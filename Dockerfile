FROM php:7.0.7-fpm-alpine
MAINTAINER "Maxime VISONNEAU <maxime.visonneau@gmail.com>"

# CONFD
ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
ADD confd /etc/confd

# INSTALL PHP EXTENSIONS
RUN \
chmod +x /usr/local/bin/confd \
&& apk add --update bash curl git autoconf file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libgcc binutils-libs mpc1 mpfr3 gmp libgomp libevent-dev \
libstdc++ \
coreutils \
freetype-dev \
libjpeg-turbo-dev \
libltdl \
libmcrypt-dev \
libpng-dev \
postgresql-dev \
# AWS libmemcached compilation / Waiting PR #4
&& cd /tmp && git clone https://github.com/mvisonneau/aws-elasticache-cluster-client-libmemcached.git aws-libmemcached && mkdir -p /usr/local/lib/aws-libmemcached /tmp/aws-libmemcached/BUILD && cd /tmp/aws-libmemcached/BUILD && git checkout alpine_3.4.0_fix \
&& ../configure --prefix=/usr/local/lib/aws-libmemcached --with-pic && make && make install && cd && rm -rf /tmp/aws-libmemcached \
# AWS memcached-php7 compilation
&& cd /tmp && git clone https://github.com/awslabs/aws-elasticache-cluster-client-memcached-for-php.git php-aws-memcached && cd php-aws-memcached && git checkout php7 \
&& phpize && ./configure --with-libmemcached-dir=/usr/local/lib/aws-libmemcached --disable-memcached-sasl && make && make install && cd && rm -rf /tmp/php-aws-memcached \
&& docker-php-ext-enable memcached \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd iconv mcrypt pgsql pdo_pgsql zip curl \
&& apk del autoconf file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libgcc binutils-libs mpc1 mpfr3 gmp libgomp libevent-dev \
&& rm -rf /var/cache/apk/*

# RUNTIME
ADD ./docker-entrypoint /docker-entrypoint
ADD ./docker-entrypoint.d /docker-entrypoint.d
ENTRYPOINT ["/docker-entrypoint"]
CMD ["/bin/sh"]
