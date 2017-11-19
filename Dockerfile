# Usaremos o container do Alpine que é considerávelmente
# menor do Debian ou Ubuntu
FROM alpine:3.5

# Instalando os pacotes necessários
RUN apk --update add --no-cache \
        nginx \
        curl \
        supervisor \
        php7 \
        php7-dom \
        php7-fpm \
        php7-mbstring \
        php7-mcrypt \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-xml \
        php7-phar \
        php7-openssl \
        php7-json \
        php7-curl \
        php7-ctype \
        php7-session

# Limpa o cache das instalações
RUN rm -Rf /var/cache/apk/*

# Aqui criamos um symlink para o PHP7 como php apenas
# pois caso contrário, será necessário chamar o php
# como php7, e isso pode causar problemas no composer
RUN ln -s /usr/bin/php7 /usr/bin/php

# Instalando composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Configurando o Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Arquivo de configuração do supervisor
COPY supervisord.conf /etc/supervisord.conf

# Criando o diretório onde ficará nossa aplicação
RUN mkdir -p /app

# Definindo o diretório app como nosso diretório de trabalho
WORKDIR /app

# Dando permissões para a pasta do projeto
RUN chmod -R 755 /app

# Expondo as portas
EXPOSE 80 443

CMD ["supervisord", "-c", "/etc/supervisord.conf"]