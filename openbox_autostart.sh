## Openbox autostart.sh
## ====================
## When you login Openbox session, this autostart script 
## More information about this can be found at:
## http://openbox.org/wiki/Help:Autostart
##
## Have fun & happy CrunchBangin'! :)

## GNOME PolicyKit and Keyring
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &

## Set root window colour
hsetroot -solid "#2E3436" &

## Group start:
## 1. nitrogen - restores wallpaper
## 2. compositor - start
## 3. sleep - give compositor time to start
## 4. tint2 panel
(\
nitrogen --restore && \
cb-compositor --start && \
sleep 2s && \
tint2 \
) &

## Volume control for systray
(sleep 2s && pnmixer) &

## Volume keys daemon
xfce4-volumed &

## Enable power management
xfce4-power-manager &

## Start Thunar Daemon
thunar --daemon &

## Detect and configure touchpad. See 'man synclient' for more info.
if egrep -iq 'touchpad' /proc/bus/input/devices; then
    synclient VertEdgeScroll=1 &
    synclient TapButton1=1 &
fi

## Start xscreensaver
xscreensaver -no-splash &

## Start Clipboard manager
(sleep 3s && clipit) &

## Set keyboard settings - 250 ms delay and 25 cps (characters per second) repeat rate.
## Adjust the values according to your preferances.
xset r rate 250 25 &

## Turn on/off system beep
xset b off &

## The following command runs hacks and fixes for #! LiveCD sessions.
## Safe to delete after installation.
cb-cowpowers &

## cb-welcome - post-installation script, will not run in a live session and
## only runs once. Safe to remove.
(sleep 10s && cb-welcome --firstrun) &

## cb-fortune - have Waldorf say a little adage
(sleep 120s && cb-fortune) &

## Run the conky
conky -q &

## Custom
#######################################"
xrandr --output VGA-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-0 --off &
geany &
terminator -m --layout=start &
chromium-browser --new-tab-page-1 http://mail.google.com/ &
sshfs root@192.168.1.200:/var/www /home/mdjae/dd &
sshfs root@192.168.1.202:/home/samba-share/projets /home/mdjae/dd_projets &
sshfs root@192.168.1.202:/home/samba-share/communication /home/mdjae/dd_communication &

