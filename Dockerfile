# Use uma imagem oficial do PHP 7.1 com Debian Stretch
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

# Clona o repositório do projeto QG Frontend
RUN git clone https://github.com/Quality-Gamer/qg-frontend.git .

# Checkout para a branch específica, se necessário
# RUN git checkout <nome-da-branch>

# Instala as dependências do Composer
RUN composer install --no-dev --optimize-autoloader

# Gera uma chave de criptografia
RUN php artisan key:generate

# Define as permissões de diretório necessárias
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Define a porta que o contêiner irá expor
EXPOSE 80

# Comando padrão para executar a aplicação Laravel
CMD php artisan serve --host=0.0.0.0 --port=80