# Usa a imagem oficial do PHP com Apache
#FROM php:8.1-apache
FROM 339603715759.dkr.ecr.us-east-1.amazonaws.com/php:latest

# Habilita extensões PHP necessárias
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Habilita o módulo de reescrita do Apache (caso necessário)
#RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 370882636449.dkr.ecr.us-east-1.amazonaws.com

