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
sudo apt-get install -y xvfb
sudo apt-get install -y htop
sudo apt-get install -y git

sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
sudo apt-get install oracle-java8-installer

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

sudo npm install -g codeceptjs
sudo npm install -g selenium-standalone@latest
sudo npm install -g webdriverio
sudo npm install -g gulp

echo "127.0.0.1     ${NAME}.ga"

#firefox 45 install
wget http://files.iustumliberum.org.ua/firefox45.tar.bz2
sudo tar xfv firefox45.tar.bz2 -C /opt/
rm -drvf firefox45.tar.bz2
sudo chmod +x /opt/firefox/firefox
sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox

#install packages
cd /var/www/html/ && npm install
