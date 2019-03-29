#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM centos

COPY nginx.repo /etc/yum.repos.d/
COPY nginx.conf /etc/nginx/
COPY www.conf /etc/nginx/conf.d/
# Define mountable directories.
VOLUME ["/etc/nginx/conf.d/","/var/log/nginx", "/var/www/html"]

# Install Nginx.
RUN \
yum -y install pcre-devel zlib-devel openssl-devel nginx && \
COPY nginx.conf /etc/nginx/
COPY www.conf /etc/nginx/conf.d

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
