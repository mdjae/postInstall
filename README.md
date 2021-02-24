# postInstall V0.1

Script de post installation de station de travail ou de serveur de production.
La configuration de l'installation dans un fichier à part.

## Sécuriser l'accès ssh

Modification sur le fichier /etc/ssh/sshd_config

- changer le port (par défaut sur 22)
- vérifier la présence du protocole 2  
- désactiver le login Root avec PermitRootLogin « No » 
- Ajoute une liste des utilisateurs autorisés à se connecter en ssh via AllowUsers 

## Activation de UFW

```
apt-get install ufw
sudo vi /etc/default/ufw
IPV6=yes
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 2222/tcp
sudo ufw allow www
sudo ufw allow 80/tcp 
sudo ufw allow ftp
sudo ufw allow 21/tcp 
sudo ufw allow from 192.168.255.255
sudo ufw enable


```

## Activation de Fail2Ban

- bannir les adresses ip qui tente de se connecter 
- 5 fois de suites avec un mot de passe erroné grâce à fail2ban.
```
- apt-get install fail2ban
```

## Choix du serveur web 

- Apache
- Nginx

### Apache

Dans /etc/apache2/apache2.conf
```
// Enlever les informations sur le serveur en cas de 404--
ServerSignature Off
ServerTokens Prod
// nom serveur
ServerName ksXXXXXX.kimsufi.com
```
### Nginx



## Choix de base de données


### Mysql

```
 apt-get install mysql-server mysql-client mysql-common
 
 /etc/mysql/my.cnf
 


language = /usr/share/mysql/french

//  Taille du cache des index
key_buffer = 32M
//  Limite du cache par requête
query_cache_limit = 2M
//  Limite du cache pour toutes les requêtes
query_cache_size = 32M
//  Loguer les requêtes lentes
log_slow_queries = /var/log/mysql/mysql-slow.log
//  Indique le temps à partir du moment ou une requête est considéré comme lente
long_query_time = 2
//  Activer l'utf-8 par default sur le serveur (dans [mysqld])
default-character-set = utf8
default-collation = utf8_general_ci
//  dans [client]
default-character-set = utf8

 /etc/init.d/mysql reload
 
lancer « mysql_secure_installation
apt-get install phpmyadmin
``` 
 
### Redis
```
```

 
### MongoDB
```
```

## Choix de base du language

### PHP

- Choix entre PHP5.6 / PHP7.1
```
apt-get install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-idn php-pear php5-imagick php5-imap php5-json php5-mcrypt php5-memcache php5-mhash php5-ming php5-mysql php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-fpm php5-mysql

Modification dans /etc/php5/apache2/php.ini

max_execution_time = 90
max_input_time = 120
memory_limit = 1024M
upload_max_filesize = 15M
register_globals = Off
//  Cache php
expose_php = Off
//  Affiche les erreurs dans les scripts (uniquement en dev)
display_errors = On
short_open_tag = Off
magic_quotes_gpc = Off
// Quelques fonctions qui peuvent être dangereuses à limiter
// disable_functions = symlink,shell_exec,exec,proc_close,proc_open,popen,system,dl,passthru,escapeshellarg,escapeshellcmd
// Pour activer l'utf-8 par defaut
mbstring.language=UTF-8
mbstring.internal_encoding=UTF-8
mbstring.http_input=UTF-8
mbstring.http_output=UTF-8
mbstring.detect_order=auto
```

### PHP-FPM

```
```

### APC


```
```

### Python

 
```
```

## Utilisation du script de post install
============

- wget https://raw.githubusercontent.com/mdjae/postInstall/master/postInstall.sh
- chmod a+x ./postinstall.sh
- sudo ./postinstall.sh
