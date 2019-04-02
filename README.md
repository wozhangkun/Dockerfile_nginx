docker build -t wozhangkun/nginx .                                                 

docker run -d --name nginx --link php-fpm7.0.33_yulian:php-fpm7.0.33 --link php-fpm7.1.27_yulian:php-fpm7.1.27 --restart=unless-stopped -v /etc/nginx/conf.d:/etc/nginx/conf.d -v /etc/nginx/certs:/etc/nginx/certs -v /var/www/html:/var/www/html -v /var/log/nginx:/var/log/nginx -p 80:80 -p 443:443 wozhangkun/nginx                                                                 

docker cp nginx:/etc/nginx/www.conf /etc/nginx/conf.d/                                    
nginx config:  （注意root，fastcgi_pass（php-fpm7.0.33是主机名）配置）                                    

server {                                                                            
......                                                                         
location ~ .php$ {                                                 
root /var/www/html/public;                             
fastcgi_pass php-fpm7.0.33:9000;                           
fastcgi_index index.php;                                     
fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;                              
include fastcgi_params;                                   
   }                                                       
}                                           

重启多个php-fpm容器后，php-fpm容器的地址如果改变一定要让nginx重新读取配置文件（解析记录）。不然连接的IP地址还是原来的PHP版本。                       
docker exec -ti nginx nginx -s reload                                             
