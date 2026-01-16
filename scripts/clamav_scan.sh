#!/bin/bash
#
# Scan ClamAV automatique
#

LOG_FILE="/var/log/clamav/clamav-scan.log"
SCAN_DIRS="/"

mkdir -p /var/log/clamav
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"

DATE=$(date '+%Y-%m-%d %H:%M')
HOSTNAME=$(hostname)

# Vérifier que clamscan est présent
if ! command -v clamscan >/dev/null 2>&1; then
    echo "$DATE - $HOSTNAME - clamscan introuvable" >> "$LOG_FILE"
    exit 2
fi

# Lancer le scan
clamscan -r --infected --log="$LOG_FILE" $SCAN_DIRS
EXIT_CODE=$?

# Interpréter le résultat
case "$EXIT_CODE" in
    0) STATUS="OK" ;;
    1) STATUS="VIRUS DETECTÉ" ;;
    *) STATUS="ERREUR SCAN" ;;
esac

echo "$DATE | $HOSTNAME | $STATUS" >> "$LOG_FILE"

exit "$EXIT_CODE"
