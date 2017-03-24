#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
NAME='es6prooject'
PASSWORD='rootpass'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install -y nginx
sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

