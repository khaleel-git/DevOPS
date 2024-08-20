# NGINX
[![Nginx in 100 seconds](http://img.youtube.com/vi/JKxlsvZXG7c/0.jpg)](http://www.youtube.com/watch?v=JKxlsvZXG7c)


- handle 10,000 simultaneous connections
- a directive is a key-value pair like:
## /etc/ngnix/nginx.conf
```
user nobody;
error_log /var/log/nginx/error.log;
http {
        server {
            listen 80;
            access_log /var/log/nginx/access.log;

            location / {
                root /app/www;
            }

            location ~ \.(git|jpg|png)$ {
                root /app/images
            }

            ## handles SSH Certificates
            ## Rewrites
            ## proxy server

            location / {
                # root /app/www -> other blocks will be deleted
                proxy_pass http://localhost:5000;
            }
        }
}
```

- static content -> images, static html etc.

## Server block
- each server is distinct with the port assigned (keep track to every request to the server)
- server block tells where to find raw files
- when user navigate to our domain, it knows where to find the root of our website
