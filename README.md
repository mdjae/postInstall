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
