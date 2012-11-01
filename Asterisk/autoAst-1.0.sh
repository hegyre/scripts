#!/bin/bash
#Script d'installation automatique d'Asterisk 11 et de DAHDI
#Denis ROSENKRANZ
#denisrosenkranz.com
##Version 1.0
#premère version fonctionelle du script

echo "Installation des dépendances"
sleep 2
aptitude update && aptitude -fy upgrade
aptitude -fy install build-essential libxml2-dev libncurses5-dev linux-headers-`uname -r` libsqlite3-dev

echo "Téléchargement de la denière version d'Asterisk et de DAHDI"
sleep 2
mkdir /usr/src/asterisk
cd /usr/src/asterisk
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-11-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz

echo "Installation de DAHDI"
sleep 2
tar xvzf dahdi-linux-complete-current.tar.gz
cd dahdi-linux-complete*
make all
make install
make config
/etc/init.d/dahdi start

echo "Installation d'asterisk"
sleep 2
cd /usr/src/asterisk
tar xvzf asterisk-11-current.tar.gz
cd asterisk-11*
./configure
make menuselect.makeopts
menuselect/menuselect --enable app_meetme --enable CORE-SOUNDS-FR-ULAW --enable MOH-OPSOUND-ULAW --enable EXTRA-SOUNDS-FR-ULAW menuselect.makeopts
make
make install
make samples
make config
/etc/init.d/asterisk start

echo "On lance la console d'asterisk"
sleep 2

asterisk -cvvvvvvvvvvr

exit