# Automatisation ClamAV avec Cron

Ce projet permet d'automatiser les scans antivirus ClamAV via des tâches cron sur des serveurs Linux (Ubuntu/Debian).

## 📋 Fonctionnalités

- ✅ Mise à jour automatique des signatures ClamAV
- ✅ Scans antivirus programmés
- ✅ Logs détaillés avec horodatage
- ✅ Rapport centralisé sur un serveur de collecte
- ✅ Codes de sortie pour intégration avec monitoring
- ✅ Compatible Ansible pour déploiement à grande échelle

## 🚀 Prérequis

- Système: Ubuntu 20.04+ ou Debian 11+
- ClamAV installé (`sudo apt install clamav clamav-daemon -y`)
- Accès root/sudo
- Connexion réseau vers le serveur de rapports (optionnel)

## 📁 Structure
