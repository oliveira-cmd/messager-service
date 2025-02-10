# Dockerfile
FROM php:8.2-fpm

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir diretório de trabalho
WORKDIR /var/www

# Baixar Laravel apenas se a pasta estiver vazia
RUN if [ ! -f "artisan" ]; then rm -rf /var/www/* && composer create-project --prefer-dist laravel/laravel .; fi

# Copiar arquivos do projeto (somente depois de baixar o Laravel)
COPY . .

ENV COMPOSER_ALLOW_SUPERUSER=1

# Instalar dependências do Laravel
RUN composer install

# Definir permissões
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

CMD ["php-fpm"]
