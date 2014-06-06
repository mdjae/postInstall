#!/bin/bash
#
# mdjae - now
# GPL
# Le script de post install vient après l'install :
# EN MODE SERVER : Debian 7.0 Wheezy
# EN MODE WORKSTATION : CrunchBang Linux 11 "Waldorf"

VERSION="0.1"

#===================================


# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "========================================================================"
  echo "Le script doit être lancé en root: # sudo $0" 1>&2
  echo "========================================================================"
  exit 1
fi



# Je suppose que SSH est déjà installé
# SSH ============================================================
echo "========================================================================"
echo "securisation SSH"
echo "========================================================================"
sed -i 's/Port 22/Port 222/g' /etc/ssh/sshd_config
sed -i 's/Protocol 1/Protocol 2/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config


echo "AllowUsers ${SSH_USERS[0]} ${SSH_USERS[1]} ${SSH_USERS[2]} ${SSH_USERS[3]} ${SSH_USERS[4]}" >> /etc/ssh/sshd_config
/etc/init.d/ssh restart
# FAIL2BAN ============================================================
apt-get install fail2ban
# TODO : Configuration ....

# PHP #PHP-FPM #PHP APC
echo "================== ======================================================"
echo "Installation PHP + PHP-FPM"
echo "========================================================================"
apt-get install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-idn 
php-pear php5-imagick php5-imap php5-json php5-mcrypt php5-memcache php5-mhash php5-ming 
php5-mysql php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc 
php5-xsl php5-fpm php5-mysql php5-apc

#PHP-FPM CONFIG

sed -i 's/listen = 127.0.0.1:9000/;listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
#listen = /var/run/php5-fpm.sock

#listen.owner = www-data
#listen.group = www-data
#listen.mode = 0660

/etc/init.d/php5-fpm restart










#MYSQL
apt-get install mysql-server
mysql_install_db
/usr/bin/mysql_secure_installation

# NGINX

apt-get install nginx
service nginx start
/etc/nginx/conf.d/php5-fpm.conf
 

upstream php5-fpm-sock {
        server unix:/var/run/php5-fpm.sock;
}


/etc/nginx/sites-available/default

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


#  http://www.if-not-true-then-false.com/2011/nginx-and-php-fpm-configuration-and-optimizing-tips-and-tricks/

# APC CONFIG

/etc/php5/fpm/conf.d/apc.ini

; configuration for php apc module
extension=apc.so
apc.shm_size=100

/etc/init.d/php-fpm restart

#MANGO REDIS

# Ajout des depots

# Custom du systeme

# Custom .bashrc

# some more ls aliases
alias ll='ls -algs'
alias l='ls -ltr'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'


# Paths Oracle 10g
export PATH=$PATH:/usr/lib/oracle/xe/app/oracle/product/10.2.0/server/bin:
ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
export ORACLE_HOME
export ORACLE_SID=XE
LD_LIBRARY_PATH=/opt/oracle/instantclient_10_2/
export LD_LIBRARY_PATH

# Java
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk

# Tomcat
export TOMCAT_HOME=/opt/tomcat
export SERVLET_JAR=$TOMCAT_HOME/lib/servlet-api.jar
alias tstop='sudo $TOMCAT_HOME/bin/shutdown.sh'
alias tstart='sudo $TOMCAT_HOME/bin/catalina.sh run'

# Mise a jour 
#------------

echo "Mise a jour de la liste des depots"
apt-get -y update

echo "Mise a jour du systeme"
apt-get -y upgrade




echo "========================================================================"
echo "Fin du script"
echo "========================================================================"

# Fin du script
#---------------
