#!/bin/bash
#################################################
# Einfaches inkrmentelles Backup Programm Max Kalus
#################################################
BACKUPDIR=/home/Backup
LASTMONTHDIR=lastmonth
TSNAME=timestamp.snar
BACKUPNAME=Backup
DIRS="/var/vmail /var/www"

if [ $1 == "complete" ]; then
    #Komplettes Backup
    MYDATE=complete
    #Alte Timestamps löschen
    rm -f "$BACKUPDIR/$TSNAME"
    #Alte Backups löschen
    rm -rf "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
    #Neue alte Backups in Ordner verschieben
    mkdir "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
    mv -f "$BACKUPDIR/$BACKUPNAME.*".tgz "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
else
    #Inkrementelles Backup
    MYDATE=$(date +%y%m%d)
fi

#Abzug erstellen
for vhost in /var/www/*; do
#echo "${file##*www/}"
tar czf "$BACKUPDIR"/"$BACKUPNAME".Website.${vhost##*www/}.$MYDATE.tgz -g "$BACKUPDIR/$TSNAME" "${vhost}" 2> /dev/null
done

for vmail in /var/vmail/vhosts/*; do
#echo "${file##*www/}"
tar czf "$BACKUPDIR"/"$BACKUPNAME".Mail.${vmail##*vhosts/}.$MYDATE.tgz -g "$BACKUPDIR/$TSNAME" "${vmail}" 2> /dev/null
done
