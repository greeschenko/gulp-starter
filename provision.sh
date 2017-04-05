#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
NAME='gulp'
PASSWORD='rootpass'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install -y nginx
sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "    server {" >> /etc/nginx/sites-available/default
echo "        listen 80;" >> /etc/nginx/sites-available/default
echo "        listen [::]:80;" >> /etc/nginx/sites-available/default
echo "        server_name ${NAME}.ga;" >> /etc/nginx/sites-available/default
echo "        root /var/www/html/web;" >> /etc/nginx/sites-available/default
echo "        index index.html;" >> /etc/nginx/sites-available/default
echo "        sendfile  off;" >> /etc/nginx/sites-available/default
echo "        location / {" >> /etc/nginx/sites-available/default
echo "            try_files \$uri \$uri/ =404;" >> /etc/nginx/sites-available/default
echo "            access_log        off;" >> /etc/nginx/sites-available/default
echo "            expires           0;" >> /etc/nginx/sites-available/default
echo "            add_header        Cache-Control private;" >> /etc/nginx/sites-available/default
echo "        }" >> /etc/nginx/sites-available/default
echo "    }" >> /etc/nginx/sites-available/default

sudo /etc/init.d/nginx restart
