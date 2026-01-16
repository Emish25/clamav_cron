#!/bin/bash
#
# Mise à jour ClamAV via freshclam
#

LOG_FILE="/var/log/clamav/freshclam.log"

mkdir -p /var/log/clamav
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"

DATE=$(date '+%Y-%m-%d %H:%M')
HOSTNAME=$(hostname)

# Vérifier que freshclam est présent
if ! command -v freshclam >/dev/null 2>&1; then
    echo "$DATE - $HOSTNAME - freshclam introuvable" >> "$LOG_FILE"
    exit 2
fi

# Empêcher les doublons
if pgrep freshclam >/dev/null; then
    echo "$DATE - $HOSTNAME - freshclam déjà en cours" >> "$LOG_FILE"
    exit 0
fi

# Mise à jour
freshclam >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ "$EXIT_CODE" -ne 0 ]; then
    echo "$DATE - $HOSTNAME - ERREUR mise à jour signatures" >> "$LOG_FILE"
else
    echo "$DATE | $HOSTNAME | Mise à jour OK" >> "$LOG_FILE"
fi

exit "$EXIT_CODE"
