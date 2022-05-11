#!/bin/bash

echo Name Wordpress Site : 
read wp_name

if [ -z $wp_name ]; then
	echo Name Wordpress Site is empty.
	exit
fi

echo Name User Wordpress :
read wp_user

if [ -z $wp_user ]; then
	echo Name User Wordpress is empty.
	exit
fi

echo Password User Wordpress : 
read wp_passwd

if [ -z $wp_passwd ]; then
	echo Password User Wordpress is empty.
	exit
fi

echo Email User Wordpress : 
read wp_email

if [ -z $wp_email ]; then
	echo Email User Wordpress is empty.
	exit
fi

if [ -d "/var/www/html/$wp_name" ]; then
	echo This directory already exists.
	exit
fi

cd /tmp/

if [ -d "wordpress" ]; then
	rm -r wordpress/
fi

wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz 2>&1> /dev/null
rm latest.tar.gz

mysql -Bse "CREATE DATABASE IF NOT EXISTS db_$wp_name CHARACTER SET utf8;CREATE USER IF NOT EXISTS admin_$wp_name@localhost IDENTIFIED BY '$wp_passwd';GRANT ALL ON db_$wp_name.* TO admin_$wp_name@localhost;FLUSH PRIVILEGES;"

mv /tmp/wordpress/ /var/www/html/$wp_name
cd /var/www/html/$wp_name/

mv wp-config-sample.php wp-config.php
sed -i -e "s/database_name_here/db_$wp_name/g" wp-config.php
sed -i -e "s/username_here/admin_$wp_name/g" wp-config.php
sed -i -e "s/password_here/$wp_passwd/g" wp-config.php

curl --data-urlencode "weblog_title=$wp_name" \
     --data-urlencode "user_name=$wp_user" \
     --data-urlencode "admin_password=$wp_passwd" \
     --data-urlencode "admin_password2=$wp_passwd" \
     --data-urlencode "admin_email=$wp_email" \
     --data-urlencode "Submit=Install+WordPress" \
     http://192.168.1.91/$wp_name/wp-admin/install.php?step=2 2>&1> /dev/null
