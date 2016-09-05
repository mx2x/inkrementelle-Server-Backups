#!/bin/bash
#################################################
# Einfaches inkrmentelles Backup Programm Max Kalus
#################################################
BACKUPDIR=/home/Backup
LASTMONTHDIR=lastmonth
TSNAME=timestamp.snar
BACKUPNAME=Backup
DIRS="/var/vmail /var/www"
ERRORCODE="0";
EMAILBODY="0"
EMAIL_FROM="backup@server.net"
EMAIL_TO="admin@server.net"
EMAIL_SUBJ_WARN="WARNING: Check Backup of mail01.beonline.business "
EMAIL_SUBJ_SUCC="SUCCESS: Backup of mail01.beonline.business succeeded" 
if [ $1 == "complete" ]; then
    #Komplettes Backup
    MYDATE=complete
#    #Alte Timestamps löschen
#    rm -fv "$BACKUPDIR"/*"$TSNAME"
    #Alte Backups löschen
    rm -rvf "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
    #Neue alte Backups in Ordner verschieben
    mkdir "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
    mv -fv "$BACKUPDIR/$BACKUPNAME"* "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
    #Alte Timestamps verschieben
    mv -fv "$BACKUPDIR"/*"$TSNAME" "$BACKUPDIR/$LASTMONTHDIR.$BACKUPNAME.d"
else
    #Inkrementelles Backup
    MYDATE=$(date +%y%m%d)
fi
 
#Abzug erstellen
for vhost in /var/www/*; do
#echo "${vhost##*www/}"
tar czf "$BACKUPDIR"/"$BACKUPNAME".Website.${vhost##*www/}.$MYDATE.tgz -g "$BACKUPDIR/Web.${vhost##*www/}.$TSNAME" -C /var/ "${vhost##*var/}" 

if [ $? -ne 0 ]; then
ERRORCODE="1"
fi

done

for vmail in /var/vmail/*; do
#echo "${vmail##*vmail/}" 2> /dev/null
tar czf "$BACKUPDIR"/"$BACKUPNAME".Mail.${vmail##*vmail/}.$MYDATE.tgz -g "$BACKUPDIR/Mail.${vmail##*vmail/}.$TSNAME" -C /var/ "${vmail##*var/}" 

if [ $? -ne 0 ]; then
ERRORCODE="1"
fi

done


if [ "$ERRORCODE" = "1" ]; then
mail -aFrom:"${EMAIL_FROM}" -s "${EMAIL_SUBJ_WARN}" ${EMAIL_TO} <<EOM
Ein Fehler ist aufgetreten ( ${MYDATE} ), bitte Backup kontrollieren.
EOM

else

mail -aFrom:"${EMAIL_FROM}" -s "${EMAIL_SUBJ_SUCC}" ${EMAIL_TO} <<EOM
Backup erfolgreich ( ${MYDATE} ).
EOM
 
fi
