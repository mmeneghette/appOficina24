# Usa a imagem oficial do PHP com Apache
#FROM php:8.1-apache
FROM 339603715759.dkr.ecr.us-east-1.amazonaws.com/php8.1-apache:latest

# Instala dependências necessárias (OpenSSL, SSL para Apache)
RUN apt-get update && apt-get install -y openssl

# Habilita extensões PHP necessárias
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Habilita módulos do Apache necessários
RUN a2enmod rewrite ssl

# Define variáveis para o certificado SSL
ENV CERT_DIR=/etc/apache2/ssl
ENV CERT_FILE=$CERT_DIR/apache-selfsigned.crt
ENV KEY_FILE=$CERT_DIR/apache-selfsigned.key

# Cria diretório para os certificados SSL
RUN mkdir -p $CERT_DIR && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $KEY_FILE -out $CERT_FILE \
    -subj "/C=BR/ST=SaoPaulo/L=SaoPaulo/O=MinhaEmpresa/CN=localhost"

# Copia a configuração do Apache para habilitar o SSL
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Ativa o site SSL no Apache
RUN a2ensite default-ssl

WORKDIR /var/www/html

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80 443

CMD ["apache2-foreground"]
