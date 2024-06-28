FROM dunglas/frankenphp

# Met moi un émoji comme quoi c'est le docker local
LABEL maintainer="🐘🐳🐧🚀"

# Disable https
ENV SERVER_NAME=:80

# add additional extensions here:
RUN install-php-extensions \
    @composer \
	pdo_mysql \
    pdo_pgsql \
	gd \
	intl \
	zip \
    bcmath \
    xdebug
    # opcache # disable for local development

# WORKDIR /app

# Install git
RUN apt-get update && apt-get install -y git

RUN apt-get install -y libnss3-tools

# Install symfony cli
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN apt-get update && apt-get install -y symfony-cli

# Copy the new Caddyfile to the container
COPY ./docker/Caddyfile /etc/caddy/Caddyfile

# Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# Copy the current directory contents into the container at /app
COPY . /app
# COPY .env.example.local .env

RUN composer install

RUN echo "END 🐘🐳🐧🚀"
