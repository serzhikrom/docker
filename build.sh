#!/bin/bash
cat << _EOF_ > Dockerfile
FROM debian:latest
MAINTAINER Evgeny Savitsky <evgeny.savitsky@devprom.ru>

# Base layer
ENV CROSS_COMPILE=/usr/bin/

#
RUN apt-get -y update && apt-get -y install apache2 mysql-server mysql-client \
  php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-gd php7.0-common php7.0-mysql \
  php7.0-mysqli php7.0-curl php7.0-imap php7.0-ldap php7.0-xml php7.0-mbstring php7.0-zip php7.0-imagick \
  zip unzip wget

RUN a2enmod rewrite deflate filter setenvif headers ldap
RUN wget -O pandoc.deb https://github.com/jgm/pandoc/releases/download/2.4/pandoc-2.4-1-amd64.deb && dpkg -i pandoc.deb

#
RUN service mysql start && mysqladmin -u root password $MYSQL_ROOT_PASSWORD && \
  mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER devprom@localhost IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'" && \
  mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO devprom@localhost WITH GRANT OPTION"

#
RUN echo "* * * * * root /usr/bin/php /var/www/devprom/htdocs/core/processjobs.php >/dev/null 2>&1" >>  /etc/crontab
RUN echo "" >>  /etc/crontab

#
RUN mkdir -p /var/www/devprom && mkdir /var/www/devprom/backup && mkdir /var/www/devprom/update && \
  mkdir /var/www/devprom/files && mkdir /var/www/devprom/logs && mkdir /var/www/devprom/mysql

#
RUN wget -O /var/www/devprom/devprom.zip https://myalm.ru/download/devprom-zip && \
  unzip /var/www/devprom/devprom.zip -d /var/www/devprom && mv /var/www/devprom/devprom /var/www/devprom/htdocs && \
  chown -R www-data:www-data /var/www/devprom && chmod -R 755 /var/www/devprom && rm -f /var/www/devprom/*.sh

#
VOLUME /var/www/devprom
VOLUME /etc/php/7.0/apache2/conf.d/devprom.ini
VOLUME /etc/mysql/conf.d/devprom.cnf
VOLUME /etc/apache2/sites-available/000-default.conf

CMD (set -e && rm -f /usr/local/apache2/logs/httpd.pid && exec httpd -DFOREGROUND)
_EOF_

docker pull debian:latest
docker build -t devprom/alm:latest .
docker push devprom/alm:latest
