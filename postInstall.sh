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

# Ajout des depots

# Custom du systeme

# Custom .bashrc









echo "========================================================================"
echo "Fin du script"
echo "========================================================================"

# Fin du script
#---------------
