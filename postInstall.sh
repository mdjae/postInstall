#!/bin/bash
#
# mdjae - now
# GPL
#
# 

VERSION="0.1"

#===================================


# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "Le script doit être lancé en root: # sudo $0" 1>&2
  exit 1
fi

# Je suppose que SSH est déjà installé

sed -e 's/Port 22/Port 222/g' /etc/ssh/sshd_config
sed -e 's/Protocol 1/Protocol 2/g' /etc/ssh/sshd_config
sed -e 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo "AllowUsers user1 user2 user3"

# Ajout des depots

# Custom du systeme

# Custom .bashrc









echo "========================================================================"
echo "Fin du script"
echo "========================================================================"

# Fin du script
#---------------
