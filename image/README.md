# Raspberry Pi Image für raspi-rocrail-config

Dieses Image basiert auf Raspberry Pi OS (32-Bit, Bookworm Lite) und enthält alle notwendigen Skripte zur Einrichtung und Aktualisierung von Rocrail über ein einfaches Textmenü.

📥 [Download Rocrail Pi OS 32bit Image](https://drive.google.com/file/d/1c9eG69IcQtM3PgGZgWhhHm7IVhwWRMo6/view?usp=sharing)

Dieses Image basiert auf Raspberry Pi OS (64-Bit, Bookworm Lite) und enthält alle notwendigen Skripte zur Einrichtung und Aktualisierung von Rocrail über ein einfaches Textmenü.

📥 [Download Rocrail Pi OS 64bit Image](https://drive.google.com/file/d/1tY7Tpzcb9P4GfnJDB64ciBa5LzR6ttps/view?usp=drive_link)

## Inhalt des Images

Nach dem ersten Start befinden sich folgende Dateien im Verzeichnis `/home/pi`:

- `raspi-rocrail-config`  
  → Das Textmenü zur Steuerung und Konfiguration  
- `update1.sh`  
  → Automatisiertes Update-Skript für Rocrail  
- `startrocrail.sh`  
  → Startet Rocrail nach erfolgreicher Installation  
- `.bashrc`  
  → Angepasst, um das Menü automatisch nach dem Login anzuzeigen

> **Hinweis**: Rocrail selbst ist **nicht** vorinstalliert. Die Installation erfolgt über das Menü.

## Zugangsdaten

- Benutzername: `pi`  
- Passwort: `rocrail`

## WLAN & Sprache

- WLAN wird über das Textmenü eingerichtet.
- Sprache und Tastatur sind auf **Deutsch (de_DE.UTF-8, de)** eingestellt.
- Zeitzone: **Europe/Berlin**

## Verwendung

1. Image auf SD-Karte schreiben (z. B. mit [Raspberry Pi Imager](https://www.raspberrypi.com/software/))
2. Raspberry Pi einlegen und starten
3. Nach dem Login erscheint automatisch das Konfigurationsmenü

## Zielgruppe

Dieses Image richtet sich an Nutzer, die Rocrail auf einem Raspberry Pi betreiben möchten – ohne manuelle Konfigurationen.

---

Erstellt am: 28.05.2025  
Kontakt: [Oliver]
