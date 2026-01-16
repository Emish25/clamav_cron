#!/bin/bash

EVENT_LOG="/var/log/clamav/clamav-events.log"
SCAN_LOG="/var/log/clamav/clamav-scan.log"
SCAN_DIR="/"

DATE=$(date '+%Y-%m-%d %H:%M')
HOSTNAME=$(hostname -f)
IP=$(hostname -I | awk '{print $1}')

mkdir -p /var/log/clamav
touch "$EVENT_LOG" "$SCAN_LOG"
chmod 600 "$EVENT_LOG" "$SCAN_LOG"

# Vérifier clamscan
if ! command -v clamscan >/dev/null 2>&1; then
  echo "$DATE | $HOSTNAME | $IP | SCAN | ERREUR ❌ | clamscan introuvable" >> "$EVENT_LOG"
  exit 2
fi

# Lancer scan
clamscan -r --infected --log="$SCAN_LOG" "$SCAN_DIR"
EXIT_CODE=$?

case "$EXIT_CODE" in
  0)
    echo "$DATE | $HOSTNAME | $IP | SCAN | OK ✅ | $SCAN_DIR" >> "$EVENT_LOG"
    ;;
  1)
    VIRUS=$(grep "FOUND" "$SCAN_LOG" | tail -1 | cut -d: -f1)
    echo "$DATE | $HOSTNAME | $IP | SCAN | VIRUS ❌ | $VIRUS" >> "$EVENT_LOG"
    ;;
  *)
    echo "$DATE | $HOSTNAME | $IP | SCAN | ERREUR ❌ | scan interrompu" >> "$EVENT_LOG"
    ;;
esac

exit "$EXIT_CODE"
