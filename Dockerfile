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

# Copiar arquivos do projeto
COPY . .

# Instalar dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Criar diretórios necessários
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache

# Definir permissões
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

CMD ["php-fpm"]

# Adicionar composer.json
COPY composer.json /var/www/composer.json
