# docker-php

[![PULLS](https://img.shields.io/docker/pulls/mvisonneau/php.svg)](https://hub.docker.com/r/mvisonneau/php)
[![BUILD](https://img.shields.io/travis/mvisonneau/docker-php/master.svg)](https://travis-ci.org/mvisonneau/docker-php)

## Features

This image is based onto `php:7.0.7-fpm-alpine` is contains several libraries :
- AWS Elasticache/Memcached Library for PHP
- gd
- iconv
- mcrypt
- pgsql
- pdo_pgsql
- zip
- curl

It also automatically configures the session.save_handler/path.
Finally it provides the installation of composer and do the dump of the autoload.

## Usage

```
docker run -it --rm mvisonneau/php:latest
```

## Build

- Clone this repository and `cd` into it.

```
docker build -t php .
```
