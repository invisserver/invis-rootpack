#!/bin/sh
# Quelle des Scripts: wiki.dovecot.org
# Ergaenzt von Stefan Schaefer -- stefan@invis-server.org
PERCENT=$1
qwf="/tmp/quota.warning.$$"

conffile="/etc/rootpack/rootpack.cfg"

#TODO: Logrotate des logfile

# Funktionen
# Werte aus Konfigurationsdatendatei extrahieren
# $1 = Konfigurationsdatei, $2 = Parameter, $3 Wert (Feld)
getconfdata() {
    [ -e $1 ] || { echo "Achtung, Konfig-Datei $1 fehlt! Breche ab!"; exit 2; }
    grep -i "$2" $1 | cut -d ":" -f $3
}

FROM=$(getconfdata $conffile "ServerAdminMail" "2")

echo "From: $FROM
To: $USER
To: postmaster@domain.org
Subject: Ihr Postfach ist zu $PERCENT% voll.
Content-Type: text/plain; charset="UTF-8"

Ihr Postfach ist jetzt zu $PERCENT% voll." >> $qwf

cat $qwf | /usr/sbin/sendmail -f $FROM "$USER"
rm -f $qwf

exit 0 
