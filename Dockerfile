# Use uma imagem oficial do PHP 7.1 com Debian Buster
FROM php:7.1-buster

# Atualiza o repositório de pacotes e instala as dependências necessárias
RUN apt-get update && apt-get install -y \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define o diretório de trabalho como /var/www
WORKDIR /var/www

# Clona o repositório da aplicação Laravel 5.8 para um diretório temporário
RUN git clone https://github.com/Quality-Gamer/qg-frontend.git /tmp/laravel

# Move os arquivos do Laravel para o diretório de trabalho
RUN mv /tmp/laravel/* /var/www \
    && rm -rf /tmp/laravel

# Instala as dependências do Composer
RUN composer install

# Define as permissões de diretório necessárias
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Define a porta que o contêiner irá expor
EXPOSE 80

# Comando padrão para executar a aplicação Laravel
CMD php artisan serve --host=0.0.0.0 --port=$PORT
