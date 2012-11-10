#!/bin/bash
##denisrosenkranz.com
##Script d'installation automatique de Nagios 3.4.1 et de Nagios Plugins 1.4.16
##Script testé sous Debian 6.
##Voir le README pour le changelog

echo "Installation des dépendances"
sleep 2
apt-get update && apt-get upgrade -y

apt-get install -y php5-gd postfix fping snmp ntp smbclient nmap saidar traceroute php5-snmp curl gettext build-essential libperl-dev libgd2-xpm-dev libltdl3-dev linux-headers-`uname -r` libglib2.0-dev libgnutls-dev libmysqlclient15-dev libssl-dev libsnmp-perl libkrb5-dev libldap2-dev libsnmp-dev libnet-snmp-perl gawk libwrap0-dev libmcrypt-dev fping snmp gettext smbclient dnsutils

#Creation de l'utilisateur Nagios
groupadd -g 9000 nagios
groupadd -g 9001 nagcmd
useradd -u 9000 -g nagios -G nagcmd -d /usr/local/nagios -c "Nagios Admin" nagios

echo "Téléchargement de nagios et de Nagios plugins"
sleep 2
mkdir /usr/src/nagios
cd /usr/src/nagios
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-3.4.1.tar.gz
wget http://prdownloads.sourceforge.net/sourceforge/nagiosplug/nagios-plugins-1.4.16.tar.gz

echo "Installation de nagios"
sleep 2
tar xvzf nagios-3.4.1.tar.gz
cd nagios

./configure --prefix=/usr/local/nagios --with-nagios-user=nagios --with-nagios-group=nagios --with-command-user=nagios --with-command-group=nagcmd --enable-event-broker --enable-nanosleep --enable-embedded-perl --with-perlcache

make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf

##Configuration de l'interface Web de nagios
adduser www-data nagcmd
echo "Veuillez entrer un mot de passe pour l'accès Web de Nagios"
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
chown nagios:nagcmd /usr/local/nagios/etc/htpasswd.users
/etc/init.d/apache2 restart

echo "Installation de Nagios plugins"
Sleep 2
cd /usr/src/nagios
tar xvzf nagios-plugins-1.4.16.tar.gz
cd nagios-plugins-1.4.16

./configure --with-nagios-user=nagios --with-nagios-group=nagios --enable-libtap --enable-extra-opts --enable-perl-modules
make
make install

#Script de démarrage de Nagios
chmod +x /etc/init.d/nagios
update-rc.d nagios defaults
/etc/init.d/nagios restart

echo "Installation terminée vous pouvez accéder à Nagios via : http://ipdevotreserveur/nagios/"
sleep 2