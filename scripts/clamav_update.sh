#!/bin/bash

# Fichiers de logs
EVENT_LOG="/var/log/clamav/clamav-events.log"
UPDATE_LOG="/var/log/clamav/freshclam.log"

# Infos système
DATE=$(date '+%Y-%m-%d %H:%M')
HOSTNAME=$(hostname -f)
IP=$(hostname -I | awk '{print $1}')

# Création du répertoire et des fichiers si nécessaire
mkdir -p /var/log/clamav
touch "$EVENT_LOG" "$UPDATE_LOG"

# Forcer les bons propriétaires et permissions
chown clamav:clamav "$UPDATE_LOG" "$EVENT_LOG"
chmod 640 "$UPDATE_LOG"
chmod 600 "$EVENT_LOG"

# Vérifier freshclam
if ! command -v freshclam >/dev/null 2>&1; then
  echo "$DATE | $HOSTNAME | $IP | UPDATE | ERREUR ❌ | freshclam introuvable" >> "$EVENT_LOG"
  exit 2
fi

# Lancer l'update en tant qu'utilisateur clamav
if sudo -u clamav freshclam >> "$UPDATE_LOG" 2>&1; then
  echo "$DATE | $HOSTNAME | $IP | UPDATE | OK ✅ | signatures à jour" >> "$EVENT_LOG"
else
  echo "$DATE | $HOSTNAME | $IP | UPDATE | ERREUR ❌ | échec update" >> "$EVENT_LOG"
fi
