#!/bin/bash
if [ $USER -ne root ]
	then
	echo "sudo script or run as root."
	exit 1
fi

#fix zoneminder regression
sed -i 's/\/cgi-bin\/nph-zms/\/zm\/cgi-bin\/nph-zms/ /usr/share/zoneminder/db/zm_create.sql

#remove current mysql sybolic links
rm /etc/mysql/my.cnf
cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf
echo "sql_mode = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf
systemctl restart mysql

add-apt-repository ppa:iconnor/zoneminder
apt-get update
apt-get upgrade -y
apt-get install mysqltuner zoneminder php-gd -y

mysql -uroot -p < /usr/share/zoneminder/db/zm_create.sql
mysql -uroot -p -e "grant all on zm.* to 'zmuser'@localhost identified by 'zmpass';"
mysqladmin -uroot -p reload

chmod 740 /etc/zm/zm.conf

chown root:www-data /etc/zm/zm.conf
chown -R www-data:www-data /usr/share/zoneminder/www/api/

adduser www-data video

a2enmod cgi
a2enconf zoneminder
a2enmod rewrite

echo "
ScriptAlias /zm/cgi-bin "/usr/lib/zoneminder/cgi-bin"
<Directory "/usr/lib/zoneminder/cgi-bin">
    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
    AllowOverride All
    Require all granted
</Directory>

Alias /zm /usr/share/zoneminder/www
<Directory /usr/share/zoneminder/www>
  Options -Indexes +FollowSymLinks
  <IfModule mod_dir.c>
    DirectoryIndex index.php
  </IfModule>
</Directory>

<Directory /usr/share/zoneminder/www/api>
    AllowOverride All
</Directory>" >> /etc/apache2/conf-available/zoneminder.conf

sed -i 's/;date.timezone =/date.timezone = America\/New_York/' /etc/php/7.0/apache2/php.ini
