# Использование базового образа для PHP с Apache
FROM oberd/php-8.1-apache

# Установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y openssl wget libz-dev vim mc curl apache2 libpng-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Установка расширений PHP
RUN docker-php-ext-install gd exif pdo_mysql zip

# Установка Composer
RUN curl -sS https://getcomposer.org/installer | php -- --version=2.5.8 --install-dir=/usr/local/bin --filename=composer

# Копирование конфигурационных файлов Apache и PHP
COPY ./configs/apache2.conf /etc/apache2/apache2.conf
COPY ./configs/default.conf /etc/apache2/sites-enabled/default.conf
COPY ./configs/php.ini /usr/local/etc/php/php.ini
COPY ./configs/php.ini /usr/local/etc/php/php.ini-development
COPY ./configs/php.ini /usr/local/etc/php/php.ini-production

# Установка Node.js и npm
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Установка pm2 глобально
RUN npm install -g pm2

# Установка MySQL клиента
RUN apt-get update && \
    apt-get install -y default-mysql-client

# Включение необходимых модулей Apache
RUN a2enmod rewrite proxy proxy_http proxy_html substitute deflate xml2enc ssl

# Копирование entrypoint.sh
COPY entrypoint.sh /sbin/entrypoint.sh

# Установка рабочей директории
WORKDIR /var/www/

# Экспозиция портов
EXPOSE 80 443 22

# Запуск Apache при старте контейнера
CMD ["/sbin/entrypoint.sh"]
