docker build -t wozhangkun/nginx nginx/                                                                              

docker run -d --name nginx -v /etc/nginx/conf.d:/etc/nginx/conf.d -v /etc/nginx/certs:/etc/nginx/certs -v /var/www/html:/var/www/html -v /var/log/nginx:/var/log/nginx -p 80:80 -p 443:443 wozhangkun/nginx                                                                       
