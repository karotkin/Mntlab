
| №  |  Issue | How to find  |  Time to find |  How to fix |  Time to fix |
|---|---|---|---|---|---|
|  1 | Web site dosen't open at external, HTTP/1.1 302 Found (external) | curl -IL 192.168.56.10  | 2 minutes  |  Checking the operability of httpd service at host machine |  2 minutes |
| 2  |  Web site dosen't open at internal, HTTP/1.1 302 Found (internal) | curl -IL 192.168.56.10  | 2 minutes  |  Checking the operability of httpd service at virtual machine  | 2 minutes  |
| 3  |  HTTP/1.1 503 Service Temporarily Unavailable |  curl -IL 192.168.56.10 |  2 mintues | Checking the operability of tomcat service at virtual machine  |  2 minutes |
| 4  |  httpd dosen't work |  ps -ef (pipeline) grep httpd less /etc/httpd/conf/httpd.conf less /etc/httpd/conf.d/vhosts.conf less /etc/httpd/conf.d/workers.properties | 20 minutes  |  httpd process is started. We see that the process Main config includes config files from /etc/httpd/conf.d/ and vhosts.conf is one of these files. That means, we have to comment Virtual Host in the main config file httpd.conf and Virtual host will be listen via vhosts.conf file, also we have to comment the line #NameVirtualHost 0.0.0.0:80 | 40 minutes |
| 5  |  httpd dosen't work |  ps -ef (pipeline) grep httpd less /etc/httpd/conf/httpd.conf less /etc/httpd/conf.d/vhosts.conf less /etc/httpd/conf.d/workers.properties | 20 minutes  | We see that the log  repository is different at main config file and in vhosts.conf and httpd.conf files. We've done a few changes into the vhosts.conf file on VirtualHost *:80 | 40 minutes |
| 6  |  httpd dosen't work | less /var/log/httpd/modjk.log  | 20 minutes  | We see at our log file that our workers don't match to real names that listed in workers.properties files. We see that our workers do not match here and fix it with the right names replacing and change 192.168.56.100 to 192.168.56.10 After all we've restarted our httpd service and see that it is work correctly. By culr -IL 192.168.56.10 from external and internal and we see 503 Service Temporarily Unavailable (that means that our tomcat dosen't work) | 20 minutes |
| 7  |   tomcat dosen't work | ps -ef (pipeline) grep tomcat curl -IL 192.168.56.10 less /opt/apache/tomcat/7.0.62/bin/startup.sh less /opt/apache/tomcat/7.0.62/bin/catalina.sh less /home/.bashrc | 60 minutes  | We are going to see that tomcat isn't work as process and finding the directory from startup.sh file trying to startup link and we can not find it. In that file we can see that something refers to catalina.sh. After we are checking catalina.sh file and see that CATALINA_HOME is variable also we're going to home/.bashrc file and see different variables but no CATALINA_HOME. We;ve commented these lines in .bashrc file and restart tomcat | 60 minutes |
| 8  |   tomcat dosen't work | ps -ef (pipeline) grep tomcat, chown tomcat -R . /opt/apache/tomcat/7.6.0/logs/  less /etc/init.d/tomcat | 40 minutes  | After we're trying to restart tomcat but see the error in permission for /logs files. We're going to less /etc/init.d/tomcat and see the next: extra in lines < dev/null. We've deleted it. We see that user tomcat starts tomcat service, and give him permission for directory which wasn't on his permission. Trying to restart service and it dosen't work. | 60 minutes |
| 9  |  java inconsistencies | java -version, uptime, alternatives --config java, netstat –natupl (pipeline) grep java | 20 minutes  | After we're trying to restart tomcat but see the error with java. We are checking which java installed on virtual machine, we've checked which version is using right now and after we are chaning to right version of java X64 | 60 minutes |
| 10  |  iptables troubles | iptables -L -n netsat -tulnp chattr -i iptables | 20 minutes  | We see that iptables dosen't work correctly and trying to restart it, stopping is failed and it haven't started. We are watchin that permission for file /etc/sysconfig/iptables is +i so we are changing the permission for it by command  cd /etc/sysconfig and chattr -i iptables after we see that we haven't listening for 80 port and change this line with ESTABLISHED "-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" after we've restarted iptables and it works | 60 minutes |

Exit questions:

1. What java version is installed?
 We can check it which version of java is installed. java -version
![alt tag](https://github.com/karotkin/Mntlab/blob/Mntlab/Troubleshootinglab/source/JavaVersion1.png)
Java Version build 1.7.0_79-b15
Java Version X64 build 24.79-b02, mixed mode
Also we can check it via alternative --config java

2. How was it installed and configured?
It was installed by downloading java.gz.tar and extrated to directory /opt/java and after we are update-alternatives
update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_45/bin/java 100  
update-alternatives --config java
It can be installed by yum install java (and adding to yumm.repo script about java) after install update-alternatives --config java

3. Where are log files of tomcat and httpd?
Logs of tomcat are in:

![alt tag](https://github.com/karotkin/Mntlab/blob/Mntlab/Troubleshootinglab/source/tomcat-logs.png?raw=true)


Logs of httpd are in:

![alt tag](https://github.com/karotkin/Mntlab/blob/Mntlab/Troubleshootinglab/source/httpd-.png?raw=true)


4. Where is JAVA_HOME and what is it?

JAVA_HOME is Java Environment Variables. JAVA_HOME points on directory which Java runtime environment (JRE) was installed at our PC.

5. Where is tomcat installed?

cd /opt/apache/tomcat/7.0.62/

![alt tag](https://github.com/karotkin/Mntlab/blob/Mntlab/Troubleshootinglab/source/tomcat-installed.png?raw=true)

6. What is CATALINA_HOME?

It is a variable that specified the home location of tomcat service.

7. What users run httpd and tomcat processes? How is it configured?

ps -ef | grep httpd

![alt tag](https://github.com/karotkin/Mntlab/blob/Mntlab/Troubleshootinglab/source/process%20httpd%20via.png?raw=true)

ps -ef | grep tomcat

![alt tag](https://github.com/karotkin/Mntlab/blob/Mntlab/Troubleshootinglab/source/tomcat%20users%20started.png?raw=true)

8. What configuration files are used to make components work with each other?

Tomcat can not heard by httpd. httpd will not work with crushed iptables. So we are chaning: httpd.conf, vhosts.conf, workers.properties for correct running of httpd and add jk_module to start new directives. And change server.xml, into tomcat file and also change file /etc/init.d/tomcat for running of tomcat after restart.

9. What does it mean: “load average: 1.18, 0.95, 0.83”?
