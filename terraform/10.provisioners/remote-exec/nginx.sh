#!/bin/bash
ls > ls.txt
sudo apt-get update -y
sudo apt-get install nginx -y
sudo rm /var/www/html/index.nginx-debian.html
sudo echo "Hello Nginx" > /var/www/html/index.nginx-debian.html