#!/bin/bash

LOG_DIR="/var/log/clamav"
LOG_FILE="$LOG_DIR/clamav_scan_update.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")
HOST=$(hostname)

mkdir -p "$LOG_DIR"

echo "[$DATE] Début scan ClamAV sur $HOST" >> "$LOG_FILE"

# Mise à jour signatures
freshclam >> "$LOG_FILE" 2>&1
UPDATE_STATUS=$?

# Scan système (exemple /home)
clamscan -r /home --infected --log="$LOG_FILE"
SCAN_STATUS=$?

if [ $UPDATE_STATUS -eq 0 ] && [ $SCAN_STATUS -eq 0 ]; then
    echo "[$DATE] Scan et mise à jour OK" >> "$LOG_FILE"
else
    echo "[$DATE] ERREUR scan ou mise à jour" >> "$LOG_FILE"
fi

echo "[$DATE] Fin du traitement" >> "$LOG_FILE"
echo "--------------------------------------" >> "$LOG_FILE"
