#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM centos

#COPY nginx.repo /etc/yum.repos.d/

# Define mountable directories.
VOLUME ["/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Install Nginx.
RUN \
cat > /etc/yum.repos.d/nginx.repo << EOF 
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
EOF && \
yum -y install pcre-devel zlib-devel openssl-devel nginx && \
cat > /etc/nginx/nginx.conf << EOF
user nginx;
worker_processes  10;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  65535;
    use epoll;
}

daemon off;

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    
    sendfile        on;
    tcp_nopush      on;
    tcp_nodelay     on;
    server_tokens   off;

    gzip            on;
    gzip_comp_level 5;
    gzip_disable "msie6;... SV1";
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_vary      on;
    gzip_types text/plain text/css text/xml application/xml application/json application/javascript application/rss+xml application/atom+xml

    keepalive_timeout  65;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 8 128k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    fastcgi_intercept_errors on;
    client_body_buffer_size    2m;
    client_max_body_size 20m;
    client_header_buffer_size 8k;
    keepalive_requests 1000;
    include /etc/nginx/conf.d/*.conf;
}
EOF && \
cat > /etc/nginx/www.conf << EOF
server {
        listen       80;
        server_name www.abc.com;

       	root  /var/www/html;
        index  index.php index.html index.htm;

        charset utf-8;

        access_log  /var/log/nginx/${server_name}_access.log  main;
        error_log   /var/log/nginx/${server_name}_error.log  error;

        location / {
           try_files $uri $uri/ /index.php?$query_string;
        }

        location = /favicon.ico {
             access_log off;
             log_not_found off;
        }

        location = /robots.txt  {
             access_log off;
             log_not_found off;
        }

        location ~.*\.(js|css|png|jpg|jpeg|gif|ico|bmp|swf)$ {
              expires 30d;
        }

        #error_page  404              /404.html;

        #error_page   500 502 503 504  /50x.html;
        #location = /50x.html {
        #    root   html;
        #}


        #location ~ .+\.php?$
        location ~ \.php {
            root           /var/www/html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            include        fastcgi_params;
	    fastcgi_split_path_info ^(.+\.php)(.*)$;
            fastcgi_param  PATH_INFO        $fastcgi_path_info;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        }


        location ~ /\.ht {
            deny  all;
        }

}
EOF

#COPY nginx.conf /etc/nginx/
#COPY www.conf /etc/nginx/conf.d

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
