FROM php:7.2-apache

MAINTAINER Fabio J L Ferreira <fabiojaniolima@gmail.com>

# Pode assumir "prod" ou "dev"
# Default: prod
ENV TIPO_AMBIENTE=prod

# Instala e configura componentes essenciais
RUN apt-get update && \
    a2enmod rewrite && \
    apt-get install -y --no-install-recommends unzip git && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer; \
    echo "America/Sao_Paulo" > /etc/timezone; \
    # Uma versão mínima será gerada na criação do container
    rm -f /etc/apache2/sites-enabled/000-default.conf; \
    \
    # Instala a extensão PHP "DG" => http://php.net/manual/pt_BR/book.image.php
    apt-get install -y --no-install-recommends libjpeg-dev libpng-dev && \
    docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd; \
    \
    # Instala a extensão PHP "exif" => http://php.net/manual/pt_BR/intro.exif.php
    apt-get install -y --no-install-recommends libexif-dev && \
    docker-php-ext-install exif; \
    \
    # Instala as extensões PHP "mysqli pdo_mysql pgsql pdo_pgsql"
    apt-get install -y --no-install-recommends libpq-dev && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install mysqli pdo_mysql pgsql pdo_pgsql; \
    \
    # Implementa uma interface de baixo nível para funções de comunicação sockets
    docker-php-ext-install sockets; \
    \
    # Instala a extensão soap
    apt-get install -y libxml2-dev && \
    docker-php-ext-install soap

# arquivos de configuração do Apache e PHP
COPY config /usr/src/fabiojanio

COPY start.sh /start.sh

# Limpa repositório local e atribuimos permissão ao /start.sh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*; \
    chmod +x /start.sh

WORKDIR /var/www

EXPOSE 80

CMD ["/start.sh"]