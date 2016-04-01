#!/bin/bash
#
# mdjae - 2014 - GPL
# Le script de post install vient après l'install d'une distro :
# EN MODE SERVER : Debian 7.5 Wheezy 64 bits
# EN MODE WORKSTATION : CrunchBang Linux 11 "Waldorf"

VERSION="0.1"

#===================================

# TODO : Configuration ....
# Source config variable
source ./postInstall.config

# Color bash prompt
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /root/.bashrc

# Test if script user is root
if [ $EUID -ne 0 ]; then
  echo "========================================================================"
  echo "Le script doit être lancé en root: # sudo $0" 1>&2
  echo "========================================================================"
  exit 1
fi


echo "========================================================================"
echo "Mise à jour système"
echo "========================================================================"
apt-get update && apt-get -V upgrade
echo "Install serveur horaire"
apt-get install ntp


echo "========================================================================"
echo "Securisation"
echo "========================================================================"
echo "SSH"
sed -i 's/Port 22/Port 222/g' /etc/ssh/sshd_config
sed -i 's/Protocol 1/Protocol 2/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config 


#for filename in $(ls)
#	do
	# Take extension available in a filename
#        ext=${filename##*\.}

#        case "$ext" in
#        	c) echo "$filename : C source file"
#       	   ;;
#        	o) echo "$filename : Object file"
#       	   ;;
#        	sh) echo "$filename : Shell script"
#       	    ;;
#        	txt) echo "$filename : Text file"
#       	    ;;
#       	 *) echo "C"
#       	    ;;
#	esac
#done

echo "AllowUsers ${SSH_USERS[0]} ${SSH_USERS[1]} ${SSH_USERS[2]} ${SSH_USERS[3]} ${SSH_USERS[4]}" >> /etc/ssh/sshd_config
/etc/init.d/ssh restart


echo "RKHunter"
echo "================== ======================================================"
apt-get install rkhunter
# TODO : Cron weekly scan and email
echo "Clamav"
echo "================== ======================================================"
apt-get install clamav
#TODO : Cron weekly scan and email

echo "Regles iptables basic"
echo "================== ======================================================"

apt-get install iptables
# xxx.xxx.xxx.xxx est l'ip de votre serveur server ip
iptables -I INPUT -d xxx.xxx.xxx.xxx -p tcp --dport 80 -m string --to 70 --algo bm --string 'GET /w00tw00t.at.ISC.SANS.' -j DROP
iptables -I INPUT -d xxx.xxx.xxx.xxx -p tcp --dport 80 -m string --to 70 --algo bm --string 'GET /phpTest/zologize/axa.php' -j DROP
# block any IP address who has made more than 7 ssh connections within the past 7 minutes.
iptables -I INPUT -i eth1 -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name DEFAULT --rsource
iptables -I INPUT -i eth1 -p tcp -m tcp --dport 22 -m state --state NEW -m recent --update --seconds 420 --hitcount 8 --name DEFAULT --rsource -j DROP


# FAIL2BAN ============================================================
apt-get install fail2ban


echo "========================================================================"
echo "Installation logiciel"
echo "========================================================================"

#MYSQL
echo "MySql"
echo "================== ======================================================"
apt-get install mysql-server 
service mysql restart 
update-rc.d -f mysql enable


# PHP #PHP-FPM #PHP APC
echo "Installation PHP + PHP-FPM"
echo "========================================================================"
apt-get install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-intl \
php-pear php5-imagick php5-imap php5-json php5-mcrypt php5-memcache \
php5-mysql php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc \
php5-xsl php5-fpm php5-mysql 

# PHP- APC
apt-get install php5-apc

# Configuraiton 
# vim /etc/php5/apache2/php.ini
# write before Module Settings section : extension=apc.so
# write after Module Settings section : 
# [APC] apc.enabled=1


#PHP-FPM CONFIG
sed -i 's/listen = 127.0.0.1:9000/;listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
/etc/init.d/php5-fpm restart


#PHPMYADMIN
apt-get install dbconfig-common phpmyadmin


#PROFTPD
apt-get install proftpd

/etc/init.d/proftpd stop
mkdir /etc/proftpd
cd /etc/proftpd
openssl req -new -x509 -days 365 -nodes -out ftpd-rsa.pem -keyout ftpd-rsa-key.pem

# Edit the /etc/shells file, vi /etc/shells and add a non-existent shell name like null, 
# for example. This fake shell will limit access on the system for FTP users.
# /dev/null, This is our added no-existent shell. With Red Hat Linux, a special device name /dev/null 
# exists for purposes such as these.
cat >> /etc/shells <<EOF
/dev/null
EOF


# Now, edit your /etc/passwd file and add manually 
# the /./ line to divide the /home/ftp directory with the /ftpadmin directory 
# where the user ftpadmin should be automatically chdir'd to. 
# This step must be done for each FTP user you add to your passwd file.
#         ftpadmin:x:502:502::/home/ftp/ftpadmin/:/dev/null
#To read:
#          ftpadmin:x:502:502::/home/ftp/./ftpadmin/:/dev/null


# NGINX
apt-get install nginx


cat >> /etc/nginx/conf.d/php5-fpm.conf <<EOF
 
 upstream php5-fpm-sock {
         server unix:/var/run/php5-fpm.sock;
 }
EOF

cat >> /etc/nginx/sites-available/default <<EOF

 server {
         listen   80;
     
         root /usr/share/nginx/www;
         index index.php index.html index.htm;

         server_name XXX.com;

         location / {
                 try_files $uri $uri/ /index.html;
         }

         error_page 404 /404.html;

         error_page 500 502 503 504 /50x.html;
         location = /50x.html {
               root /usr/share/nginx/www;
         }

         # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
         location ~ \.php$ {
                 try_files $uri =404;
                 fastcgi_pass unix:/var/run/php5-fpm.sock;
                 fastcgi_index index.php;
                 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                 include fastcgi_params;
                 
         }
 
 }
EOF

# Thanks to
# http://www.if-not-true-then-false.com/2011/nginx-and-php-fpm-configuration-and-optimizing-tips-and-tricks/


# Apache2

# NodeJs
apt-get install curl
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs

# OrientDB

# Java
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk

# Tomcat
export TOMCAT_HOME=/opt/tomcat
export SERVLET_JAR=$TOMCAT_HOME/lib/servlet-api.jar
alias tstop='sudo $TOMCAT_HOME/bin/shutdown.sh'
alias tstart='sudo $TOMCAT_HOME/bin/catalina.sh run'

# Utilitaire SysAdmin
apt-get install ncdu htop


# Ajout des depots

# Custom du systeme

# Custom .bashrc

cat >> $HOME/.bashrc << EOF 
alias ll='ls -hsla' 
alias l='ls -ltr'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
EOF
source $HOME/.bashrc






echo "========================================================================"
echo "Fin du script"
echo "========================================================================"

# Fin du script
#---------------
