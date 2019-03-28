#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM centos

COPY ./nginx.repo /etc/yum.repos.d/

# Define mountable directories.
VOLUME ["/etc/nginx/conf.d/","/var/log/nginx", "/var/www/html"]

# Install Nginx.
RUN \
yum -y install nginx && \
echo "daemon off;" >> /etc/nginx/nginx.conf

# Define working directory.
WORKDIR /etc/nginx


# Define default command.
CMD ["/usr/sbin/nginx","-c","/etc/nginx/nginx.conf"]

# Expose ports.
EXPOSE 80
EXPOSE 443
