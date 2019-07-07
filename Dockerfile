FROM  centos:7
RUN yum update  -y
RUN yum install httpd httpd-tools -y
COPY index.html /var/www/html/
EXPOSE  80
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
