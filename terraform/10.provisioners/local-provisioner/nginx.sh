#!/bin/bash
ls > ls.txt
apt-get update -y
apt-get install nginx -y
echo "Hello Nginx" > /var/www/html/index.nginx-debian.html