#!/bin/bash
#Installing libriaries for httpd-devel and gcc-c++
yum install httpd-devel apr-util-devel 
yum install gcc 
yum install gcc-c++

#installing autoconf
yum install autoconf libtool httpd-devel

#creating directory which downloaded tomcat 
mkdir /home/vagrant/tomcatconnector
chown vagrant -R .
cd /home/vagrant/tomcatconnector/
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.41-src.tar.gz
tar -xvf tomcat-connectors-1.2.41-src.tar.gz 

#Installing tomcat connector
cd tomcat-connectors-1.2.41-src/native/
./buildconf.sh
./configure --with-apxs=/usr/sbin/apxs
make
make install

#Installing java
cd /home/vagrant/tomcatconnector/tomcat-connectors-1.2.41-src/native/apache-2.0/
yum install -y java
cd /home/vagrant/tomcatconnector/
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz
tar -xvf apache-tomcat-8.0.36.tar.gz 
cd /home/vagrant/tomcatconnector/apache-tomcat-8.0.36/bin/
chown vagrant -R .
service iptables stop
./startup.sh start



