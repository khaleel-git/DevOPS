#!/bin/bash
ls > ls.txt
sudo apt-get update -y
sudo apt-get install nginx -y
sudo echo "Hello Nginx" > /var/www/html/index.nginx-debian.html