#!/bin/bash
cat << _EOF_ > Dockerfile
FROM debian:latest
MAINTAINER Evgeny Savitsky <evgeny.savitsky@devprom.ru>

#
ENV CROSS_COMPILE=/usr/bin/

#
RUN apt-get -y update && apt-get -y install apache2 mysql-server mysql-client \
  php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-gd php7.0-common php7.0-mysql \
  php7.0-mysqli php7.0-curl php7.0-imap php7.0-ldap php7.0-xml php7.0-mbstring php7.0-zip php7.0-imagick \
  zip unzip wget

RUN a2enmod rewrite deflate filter setenvif headers ldap ssl proxy
RUN wget -O pandoc.deb https://github.com/jgm/pandoc/releases/download/2.4/pandoc-2.4-1-amd64.deb && dpkg -i pandoc.deb

#
RUN service mysql start && mysqladmin -u root password $MYSQL_ROOT_PASSWORD && \
  mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER devprom@localhost IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'" && \
  mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO devprom@localhost WITH GRANT OPTION"

#
RUN apt-get -y update && apt-get -y install tzdata apt-utils rsyslog

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y postfix sasl2-bin && \
  postconf -e "mydestination = localhost" && \
  postconf -e "myhostname = devprom.local" && \
  postconf -e "smtpd_sasl_auth_enable=yes" && \
  postconf -e "broken_sasl_auth_clients=yes" && \
  postconf -e "smtpd_relay_restrictions=permit_sasl_authenticated,reject_unauth_destination" && \
  postconf -e "smtpd_sasl_security_options = noanonymous" && \
  echo noreply | saslpasswd2 -c -p -u devprom.local noreply && \
  ln  /etc/sasldb2 /var/spool/postfix/etc/sasldb2 && \
  adduser postfix sasl && \
  touch /var/log/mail.log

COPY smtp/smtpd.conf /etc/postfix/sasl/smtpd.conf

#
RUN echo "* * * * * root /usr/bin/php /var/www/devprom/htdocs/core/processjobs.php >/dev/null 2>&1" >>  /etc/crontab
RUN echo "" >>  /etc/crontab

#
RUN mkdir -p /var/www/devprom && mkdir /var/www/devprom/backup  && mkdir /var/www/devprom/update && \
  mkdir /var/www/devprom/files && mkdir /var/www/devprom/logs

#
RUN wget -O /var/www/devprom/devprom.zip https://myalm.ru/download/devprom-zip && \
  unzip /var/www/devprom/devprom.zip -d /var/www/devprom && mv /var/www/devprom/devprom /var/www/devprom/htdocs && \
  chown -R www-data:www-data /var/www/devprom && chmod -R 755 /var/www/devprom && rm -f /var/www/devprom/*.sh

#
VOLUME /var/www/devprom/backup

#
RUN rm /etc/apache2/sites-available/* && rm /etc/apache2/sites-enabled/*
COPY php/devprom.ini /etc/php/7.0/apache2/conf.d/
COPY mysql/devprom.cnf /etc/mysql/conf.d/
COPY app/settings.yml /var/www/devprom/htdocs/co/bundles/Devprom/ApplicationBundle/Resources/config/settings.yml 
COPY apache2/devprom.conf /etc/apache2/sites-available/
RUN a2ensite devprom.conf

CMD ( set -e && \
  service cron start && \
  service rsyslog start && \
  service postfix start && \
  service mysql start && \
  export APACHE_RUN_USER=www-data && export APACHE_RUN_GROUP=www-data && export APACHE_PID_FILE=/var/run/apache2/.pid && \
  export APACHE_RUN_DIR=/var/run/apache2 && export APACHE_LOCK_DIR=/var/lock/apache2 && export APACHE_LOG_DIR=/var/log/apache2 && \
  exec apache2 -DFOREGROUND )
_EOF_

docker pull debian:latest
docker build -t devprom/alm:latest .
docker push devprom/alm:latest
