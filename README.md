# 🛤️ raspi-rocrail-config

**Rocrail-Konfigurationsmenü für Raspberry Pi OS Lite ARM64 (v1.2)**  
Ein komfortables Terminal-Menü für die Einrichtung, Pflege und Bedienung einer Rocrail-Installation auf dem Raspberry Pi.

---

## 📦 Funktionen (Stand: Version 1.2)

- Vollautomatisiertes Textmenü mit 13 Punkten:
  - Rocrail-Verzeichnisse vorbereiten
  - Architekturabhängige Installation (ARM64 / ARMHF)
  - Start/Stopp/Status von Rocrail
  - Backup mit automatischer USB-Erkennung
  - Update mit Prozessprüfung
  - Wiki-Demo starten & zurückwechseln
  - WLAN konfigurieren
  - Systemupdate
  - Systemneustart
- Unterstützt HDMI & SSH (autostartfähig)
- Crontab-fähiger Autostart von Rocrail (optional)

---

## 🚀 Ersteinrichtung nach neuem Image

> Voraussetzung: Raspberry Pi OS Lite ARM64 (Bookworm)

### 🔧 1. Pakete installieren
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget unzip zip bash-completion -y
```

### 📁 2. Verzeichnisse vorbereiten
```bash
mkdir -p ~/Documents/Rocrail/images
mkdir -p ~/Rocrail/bin
mkdir -p ~/Rocrail/wikidemo
mkdir -p ~/Backups
```

### 🧾 3. Skripte kopieren
- `raspi-rocrail-config` → nach `~/`
- `update1.sh` → nach `~/`
- `startrocrail.sh` → nach `~/Rocrail/`

```bash
chmod +x ~/raspi-rocrail-config ~/update1.sh ~/Rocrail/startrocrail.sh
```

---

### ⚙️ 4. Autostart-Menü aktivieren (`~/.bashrc`)

Ganz unten einfügen:
```bash
if [[ $(tty) == /dev/tty1 || -n "$SSH_TTY" ]]; then
  if [ -f "$HOME/raspi-rocrail-config" ]; then
    exec bash "$HOME/raspi-rocrail-config"
  fi
fi
```

---

## 📜 Menüpunkte (Auszug)

| Nr. | Funktion                           |
|-----|------------------------------------|
| 0   | Verzeichnisse vorbereiten          |
| 1   | Rocrail installieren               |
| 2   | Rocrail starten                    |
| 3   | Rocrail stoppen                    |
| 4   | Rocrail-Status anzeigen            |
| 5   | Backup inkl. USB-Unterstützung     |
| 6   | Rocrail-Update mit Prozess-Check   |
| 10  | Wiki-Demo starten                  |
| 12  | Rocrail im Benutzer-Modus starten  |

---

## 💡 Hinweise

- Nach Punkt 1 wird automatisch neu gestartet
- Punkt 9 verlässt das Menü sauber und zeigt wieder die Shell (auch bei SSH)
- Backup schlägt Alarm, wenn Rocrail noch läuft
- Updates nur möglich bei gestopptem Dienst

---

## 🏁 Versionen & Tags

- `v1.1` = erster stabiler, vollständiger Stand  
- Basierend auf Raspberry Pi OS Lite ARM64 (Bookworm, 64-bit)

---

## 📬 Kontakt

Projektleitung: **Oliver S.**  
Fragen oder Beiträge? Gerne via GitHub Issues oder Pull Requests.
