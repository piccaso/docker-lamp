FROM ubuntu:trusty

# Install packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt nano && \
  apt-get clean && rm -rf /var/lib/mysql/* && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
  mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html && \
  echo "<?php phpinfo();" > /app/index.html

# Add image configuration and scripts
ADD start-*.sh start-mysqld.sh run.sh create_mysql_admin_user.sh /
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-*.conf /etc/supervisor/conf.d/
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN chmod 755 /*.sh && a2enmod rewrite

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 100M
ENV PHP_POST_MAX_SIZE 100M

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/app" ]

EXPOSE 80 3306
CMD ["/run.sh"]
