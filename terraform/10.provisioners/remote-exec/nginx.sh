#!/bin/bash
ls > ls.txt
sudo apt-get update -y
sudo apt-get install nginx -y
echo "Hello Nginx" | sudo tee /var/www/html/index.nginx-debian.html