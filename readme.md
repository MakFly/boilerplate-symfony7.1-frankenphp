# Boilerplate Symfony 7.1 with frankenphp

This project is a Symfony 7 application using FrankenPHP for the server. This README will guide you through local installation, development, and deployment with Docker, as well as CI/CD setup with GitLab and GitHub Actions.

## Prerequisites

- PHP latest or higher
- Composer
- Docker
- Git

## Local Installation
1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/your-project.git
    cd your-project
    ```

2. Install dependencies:

    ```bash
    make install
    ```

3. Create a `.env.local` file from `.env` and configure your environment variables if necessary:

    ```bash
    cp .env .env.local
    ```

4. Set up the database:

    ```bash
    php bin/console doctrine:database:create
    php bin/console doctrine:schema:update --force
    ```

5. Start the development server:

    ```bash
    make dev
    ```

## Usage

1. `compose.yml` file:

    ```yaml
    services:
        ###> webapp ###
        webapp:
            build:
                context: .
                dockerfile: ./docker/Dockerfile
            ports:
                - 80:80
                # - 443:443
                # - 443:443/udp
            volumes:
                - ./:/app
                # - ./Caddyfile:/etc/caddy/Caddyfile
                - caddy_data:/data
                - caddy_config:/config
            # comment this line on production for not display a log json inside terminal
            tty: true
            networks:
                - default
        ###< webapp ###

        ###> postgres ###
        postgres:
            image: postgres:latest
            environment:
                POSTGRES_USER: test
                POSTGRES_PASSWORD: test
                POSTGRES_DB: nextauth-api-sf
            ports:
                - 5432:5432
            volumes:
                - db:/var/lib/postgresql/data
            networks:
                - default
        ###< postgres ###

        ###> adminer ###
        adminer:
            image: adminer
            environment:
                - ADMINER_PLUGINS=${ADM_PLUGINS}
                - ADMINER_DESIGN=${ADM_DESIGN}
                - ADMINER_DEFAULT_SERVER=${ADM_DEFAULT_SERVER}
                - ADMINER_DEFAULT_USERNAME=${ADM_DEFAULT_USERNAME}
                - ADMINER_DEFAULT_PASSWORD=${ADM_DEFAULT_PASSWORD}
            ports:
                - "9080:8080"
            volumes:
                - adminer-data:/var/lib/adminer
            networks:
                - default
        ###< adminer ###

    volumes:
        db:
        adminer-data:
        caddy_data:
        caddy_config:

    networks:
        default:
            driver: bridge
    ```

2. Start the Docker services:

    ```bash
    make dev
    ```

## CI/CD with GitLab

1. Create a `.gitlab-ci.yml` file:

    ```yaml
    image: php:latest

    services:
      - name: postgres:latest
        alias: db

    variables:
      POSTGRES_DB: database
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_HOST_AUTH_METHOD: trust

    stages:
      - build
      - test
      - deploy

    cache:
      paths:
        - vendor/

    before_script:
      - apt-get update && apt-get install -y unzip libzip-dev
      - docker-php-ext-install zip pdo pdo_mysql
      - curl -sS https://getcomposer.org/installer | php
      - php composer.phar install
      - php bin/console doctrine:database:create --env=test
      - php bin/console doctrine:schema:update --force --env=test

    build:
      stage: build
      script:
        - echo "Building the application..."

    test:
      stage: test
      script:
        - vendor/bin/phpunit

    deploy:
      stage: deploy
      script:
        - echo "Deploying the application..."
    ```

## CI/CD with GitHub Actions

1. Create a `.github/workflows/ci.yml` file:

    ```yaml
    name: CI

    on: [push, pull_request]

    jobs:
      build:

        runs-on: ubuntu-latest

        services:
          postgres:
            image: postgres:latest
            env:
              POSTGRES_DB: database
              POSTGRES_USER: user
              POSTGRES_PASSWORD: password
            ports:
              - 5432:5432
            options: >-
              --health-cmd pg_isready
              --health-interval 10s
              --health-timeout 5s
              --health-retries 5

        steps:
        - uses: actions/checkout@v2
        - name: Set up PHP
          uses: shivammathur/setup-php@v2
          with:
            php-version: latest
            extensions: zip, pdo, pdo_mysql
        - name: Install dependencies
          run: composer install
        - name: Create database
          run: php bin/console doctrine:database:create --env=test
        - name: Update schema
          run: php bin/console doctrine:schema:update --force --env=test
        - name: Run tests
          run: vendor/bin/phpunit
    ```

## Contribution

Contributions are welcome. Please submit pull requests for major changes and discuss what you would like to change via an issue.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
