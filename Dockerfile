#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM centos

# Define mountable directories.
VOLUME ["/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Install Nginx.
COPY nginx.repo /etc/yum.repos.d/
RUN yum -y install pcre-devel zlib-devel openssl-devel nginx \
    && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \

COPY nginx.conf /etc/nginx/
COPY default.conf /etc/nginx/

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
