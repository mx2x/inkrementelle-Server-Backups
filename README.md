# inkrementelle-Server-Backups
Backup für /var/www VHosts und /var/vmail  Maildir
based on https://www.auxnet.de/taegliches-inkrementelles-backup-mit-cron-und-tar-unter-linux/


Usage:


    BACKUPDIR: Verzeichnis, in das die Backups gespeichert werden. Könnte also auch eine USB-Festplatte sein (z.B. über /media/USB).
    LASTMONTHDIR: Name des Verzeichnisses für letzten Monat
    TSNAME: Name der Timestamp-Datei
    BACKUPNAME: Präfix der Backups



crontab:
Dump jeden Tag, am ersten des Monats vollständig

    10 1 2-31 * * /usr/local/sbin/backup.sh
    10 1 1 * * /usr/local/sbin/backup.sh complete.



