#!/bin/bash

EVENT_LOG="/var/log/clamav/clamav-events.log"
UPDATE_LOG="/var/log/clamav/freshclam.log"

DATE=$(date '+%Y-%m-%d %H:%M')
HOSTNAME=$(hostname -f)
IP=$(hostname -I | awk '{print $1}')

mkdir -p /var/log/clamav
touch "$EVENT_LOG" "$UPDATE_LOG"
chmod 600 "$EVENT_LOG" "$UPDATE_LOG"

# Vérifier freshclam
if ! command -v freshclam >/dev/null 2>&1; then
  echo "$DATE | $HOSTNAME | $IP | UPDATE | ERREUR ❌ | freshclam introuvable" >> "$EVENT_LOG"
  exit 2
fi

# Update
if freshclam >> "$UPDATE_LOG" 2>&1; then
  echo "$DATE | $HOSTNAME | $IP | UPDATE | OK | signatures à jour" >> "$EVENT_LOG"
else
  echo "$DATE | $HOSTNAME | $IP | UPDATE | ERREUR ❌ | échec update" >> "$EVENT_LOG"
fi

