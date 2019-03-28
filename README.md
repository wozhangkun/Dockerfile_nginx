docker build -t wozhangkun/nginx nginx/                                                                              

docker run -tid --name nginx -v /etc/nginx/conf.d:/etc/nginx/conf.d -v /var/www/html:/var/www/html -v /var/log/nginx:/var/log/nginx -p 80:80 -p 443:443 wozhangkun/nginx                                                                       
