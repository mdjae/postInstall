# postInstall V0.1

Script de post installation  de serveur.
La configuration de l'installation dans un fichier à part.
Ajout les domaines associer à Uptime Robot HTTP check 15min

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
// Enlever les informations sur le serveur en cas de 4XX / 5XX --
ServerSignature Off
ServerTokens Prod
// nom serveur
ServerName ksXXXXXX.hostname.com
```
### Nginx



## Choix de base de données


### MariaDB

```
 apt-get install mariadb-server mariadb-client

 
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
 
 sudo mysql_secure_installation
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

- PHP 7.4
```
apt install php-7.4 libapache2-mod-php7.4 php7.4-cli

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

- wget https://raw.githubusercontent.com/mdjae/postInstall/master/postInstall.sh
- chmod a+x ./postinstall.sh
- sudo ./postinstall.sh
