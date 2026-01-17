#!/bin/bash
#
# ClamAV - Scan automatique avec résumé exploitable
#

### CONFIGURATION ###
SCAN_DIR="/"
LOG_DIR="/var/log/clamav"
RAW_LOG="${LOG_DIR}/clamav-scan.log"
EVENT_LOG="${LOG_DIR}/clamav-events.log"

HOSTNAME_FQDN=$(hostname -f)
HOST_IP=$(hostname -I | awk '{print $1}')
DATE_NOW=$(date '+%Y-%m-%d %H:%M')

### PRÉPARATION ###
mkdir -p "$LOG_DIR"
touch "$RAW_LOG" "$EVENT_LOG"
chmod 600 "$RAW_LOG" "$EVENT_LOG"

### VÉRIFICATION CLAMS CAN ###
if ! command -v clamscan >/dev/null 2>&1; then
  echo "$DATE_NOW | $HOSTNAME_FQDN | $HOST_IP | SCAN | ERREUR ❌ | clamscan introuvable" >> "$EVENT_LOG"
  exit 2
fi

### LANCEMENT DU SCAN ###
clamscan -r "$SCAN_DIR" \
  --exclude-dir=^/proc \
  --exclude-dir=^/sys \
  --exclude-dir=^/dev \
  --exclude-dir=^/run \
  --log="$RAW_LOG"

SCAN_EXIT_CODE=$?

### EXTRACTION SCAN SUMMARY ###
SCAN_SUMMARY=$(awk '
/^----------- SCAN SUMMARY -----------/ {flag=1}
flag {print}
' "$RAW_LOG")

### STATUT GLOBAL ###
case "$SCAN_EXIT_CODE" in
  0) STATUS="OK ✅" ;;
  1) STATUS="VIRUS DÉTECTÉ ❌" ;;
  *) STATUS="ERREUR SCAN ❌" ;;
esac

### ÉCRITURE ÉVÉNEMENT STRUCTURÉ ###
{
  echo "========== CLAMAV SCAN SUMMARY =========="
  echo "Host: $HOSTNAME_FQDN"
  echo "IP: $HOST_IP"
  echo "Scan path: $SCAN_DIR"
  echo "Date: $DATE_NOW"
  echo "Status: $STATUS"
  echo
  echo "$SCAN_SUMMARY"
  echo "========================================"
  echo
} >> "$EVENT_LOG"

exit "$SCAN_EXIT_CODE"
