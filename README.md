postInstall
===========

Script postInstall

sécuriser ssh
=============
modifier le fichier /etc/ssh/sshd_config
changer le port (par défaut sur 22)
véfifier qu'on êtes bien en protocole 2, 
désactiver le login Root avec PermitRootLogin placé à « No » 
faire une liste des utilisateurs autorisés à se connecter en ssh avec AllowUsers

ban ip
=======
bannir les adresses ip qui tente de se connecter 3 fois de suites 
avec un mot de passe erroné grâce à fail2ban.

install apache
===============
Dans /etc/apache2/apache2.conf
# Enlever les informations sur le serveur en cas de 404--
ServerSignature Off
ServerTokens Prod
# nom serveur
ServerName ksXXXXXX.kimsufi.com


install nginx
===============


install php
==============
apt-get install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-idn php-pear php5-imagick php5-imap php5-json php5-mcrypt php5-memcache php5-mhash php5-ming php5-mysql php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

/etc/php5/apache2/php.ini
# Temps max en seconde qu'un script à pour s’exécuter
max_execution_time = 30
# Temps max qu'a un script pour parser des données (POST, GET etc..)
max_input_time = 60
# Mémoire max qu'un script a le droit d'allouer
memory_limit = 64M
# Taille max des uploads
upload_max_filesize = 25M
# Variable (super) globale (problème de sécurité)
register_globals = Off
# Cache php
expose_php = Off
# Affiche les erreurs dans les scripts
display_errors = On
# Permet d'utiliser <? à la place de <?php
short_open_tag = Off
# Filtre les données Post et Get et ajoute des / devant les '
magic_quotes_gpc = Off
# Quelques fonctions qui peuvent être dangereuses à limiter
#disable_functions = symlink,shell_exec,exec,proc_close,proc_open,popen,system,dl,passthru,escapeshellarg,escapeshellcmd
# Pour activer l'utf-8 par defaut
mbstring.language=UTF-8
mbstring.internal_encoding=UTF-8
mbstring.http_input=UTF-8
mbstring.http_output=UTF-8
mbstring.detect_order=auto

install mysql
==============
 apt-get install mysql-server mysql-client mysql-common
 /etc/mysql/my.cnf
 
 # Mettre la langue en Français
language = /usr/share/mysql/french
# Taille du cache des index
key_buffer = 32M
# Limite du cache par requête
query_cache_limit = 2M
# Limite du cache pour toutes les requêtes
query_cache_size = 32M
# Loguer les requêtes lentes
log_slow_queries = /var/log/mysql/mysql-slow.log
# Indique le temps à partir du moment ou une requête est considéré comme lente
long_query_time = 2
# Activer l'utf-8 par default sur le serveur (dans [mysqld])
default-character-set = utf8
default-collation = utf8_general_ci
# dans [client]
default-character-set = utf8

 /etc/init.d/mysql reload
 
 lancer « mysql_secure_installation
 apt-get install phpmyadmin
 
 
 
