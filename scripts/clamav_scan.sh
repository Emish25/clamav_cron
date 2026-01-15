#!/bin/bash
#
# Scan ClamAV automatisé via cron
#

### CONFIG ###
SCAN_DIRS="/"
LOG_FILE="/var/log/clamav/clamav-scan.log"

CENTRAL_SERVER="10.10.0.127"
CENTRAL_USER="clamav"
CENTRAL_FILE="/var/log/clamav/scan-status.log"

HOST_IP=$(hostname -I | awk '{print $1}')
DATE=$(date '+%Y-%m-%d %H:%M')

### PRE-CHECK ###
if ! command -v clamscan >/dev/null 2>&1; then
    echo "$(date) - clamscan introuvable" >> "$LOG_FILE"
    exit 2
fi

mkdir -p /var/log/clamav
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"

### SCAN ###
clamscan -r --infected --log="$LOG_FILE" $SCAN_DIRS
EXIT_CODE=$?

### INTERPRETATION ###
case "$EXIT_CODE" in
    0)
        STATUS="Scan OK"
        MARK="[X]"
        ;;
    1)
        STATUS="VIRUS DETECTÉ"
        MARK="[!]"
        ;;
    *)
        STATUS="ERREUR SCAN"
        MARK="[?]"
        ;;
esac

### CENTRALISATION ###
echo "$MARK $HOST_IP - $STATUS - $DATE" | \
ssh -o BatchMode=yes -o ConnectTimeout=5 \
"$CENTRAL_USER@$CENTRAL_SERVER" \
"cat >> $CENTRAL_FILE" 2>/dev/null

exit "$EXIT_CODE"
