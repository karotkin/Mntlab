#!/bin/bash
yum install httpd
yum install httpd-devel apr-util-devel 
yum install gcc 
yum install gcc-c++
mkdir /home/vagrant/tomcatconnector
sudo chown vagrant -R .
cd /home/vagrant/tomcatconnector/
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.41-src.tar.gz
tar -xvf tomcat-connectors-1.2.41-src.tar.gz 
cd tomcat-connectors-1.2.41-src/native/
install autoconf libtool httpd-devel
./buildconf.sh
./configure --with-apxs=/usr/sbin/apxs
make
make install
cd /home/vagrant/tomcatconnector/tomcat-connectors-1.2.41-src/native/apache-2.0/
cp mod_jk.so /etc/httpd/modules/
cd /etc/httpd/conf
cp -r /home/mnt2/httpd.conf /etc/httpd/conf/
cp -r /home/mnt2/workers.properties /etc/httpd/conf/
service httpd start



