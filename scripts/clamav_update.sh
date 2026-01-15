#!/bin/bash
#
# Mise à jour ClamAV via freshclam
#

LOG_FILE="/var/log/clamav/freshclam.log"

mkdir -p /var/log/clamav
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"

### CHECK ###
if ! command -v freshclam >/dev/null 2>&1; then
    echo "$(date) - freshclam introuvable" >> "$LOG_FILE"
    exit 2
fi

if pgrep freshclam >/dev/null; then
    echo "$(date) - freshclam déjà en cours" >> "$LOG_FILE"
    exit 0
fi

### UPDATE ###
freshclam >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ "$EXIT_CODE" -ne 0 ]; then
    echo "$(date) - ERREUR mise à jour signatures" >> "$LOG_FILE"
fi

exit "$EXIT_CODE"
