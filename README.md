# 📦 Rocrail Raspberry Pi OS Image – Einfach starten, ohne viel Basteln

Dieses Projekt stellt ein **fertig vorbereitetes Raspberry Pi OS Lite Image** für den Betrieb von **Rocrail** bereit.  
Ziel ist es, die Einrichtung so einfach wie möglich zu machen – ohne manuelle Paketinstallation, Konfiguration oder Linux-Kenntnisse.

---

## ✅ Was macht das Image?

- **Raspberry Pi OS Lite (Bookworm)** – kompakt, ohne Desktop
- **Startet beim ersten Boot direkt ins Setup-Menü (Punkt 0)** zur Ersteinrichtung
- Automatische Installation des **Rocrail-Servers** (je nach Pi 32 oder 64 Bit)
- Ein Terminal-Menü führt durch alle wichtigen Einstellungen:
  - 🛠️ **Punkt 0: Ersteinrichtung** – Rocrail, WLAN, Benutzer, Samba usw.
  - 🚂 **Punkt 1: Rocrail installieren**
  - 📡 **Punkt 11: WLAN einrichten**
  - 💾 **Punkt 8: Backup erstellen**, **Punkt 7: Wiederherstellen**
  - 🔧 **Punkt 13: Raspberry Pi OS aktualisieren**
  - ⏻ **Punkt 16: Herunterfahren mit Bestätigung**
- Unterstützt **32-Bit & 64-Bit Architektur** (automatische Erkennung)

---

## 💡 Zielgruppe

- Modellbahner, die **Rocrail auf einem Raspberry Pi als reinen Server** nutzen möchten
- Keine grafische Oberfläche – Rocview läuft wie gewohnt auf einem separaten PC/Mac
- Kein Eingriff in zentrale Rocrail-Konfigurationen (jede Anlage ist anders)
- Ideal für Nutzer, die keine Zeit oder Lust auf manuelle Installation haben

---

## 📥 Installation

1. Lade das passende `.img.xz`-File herunter (32bit oder 64bit)
2. Schreibe das Image auf eine SD-Karte (z. B. mit [Raspberry Pi Imager](https://www.raspberrypi.com/software/))
3. Starte den Pi – das Menü erscheint automatisch
4. Wähle **Punkt 0 „Ersteinrichtung“** – der Rest wird erledigt

---

## 🔄 Menü aktualisieren (Git-Pull)

Nach dem Flashen brauchst du das Image [b]nicht neu schreiben[/b], wenn sich z. B. das Menü geändert hat.

Du kannst jederzeit das aktualisierte Menü nachladen:

```bash
cd ~
git clone https://github.com/OliS2811/raspi-rocrail-config.git
cp raspi-rocrail-config/raspi-rocrail-config ~/
chmod +x ~/raspi-rocrail-config
```

Fertig! Beim nächsten Login erscheint automatisch das neue Menü.

---

## 🖥️ Verbindung zu Rocview (Client-PC)

Der Raspberry Pi läuft als **reiner Rocrail-Server**. Die Bedienung erfolgt mit [Rocview](https://wiki.rocrail.net/doku.php?id=rocview-de) auf deinem PC, Mac oder Tablet.

💬 Mit Hilfe des [Stummiforums](https://www.stummiforum.de/) oder des [offiziellen Rocrail-Forums](https://forum.rocrail.net/) gelingt die Verbindung zum Server problemlos – auch für Einsteiger.

---

## 📸 Vorschau

![Menü](screenshots/menu.png)

---

## 🧩 Kompatibilität

- Raspberry Pi 3B / 3B+ / 4 / 5
- Unterstützt 32-Bit **und** 64-Bit
- WLAN, SSH und Autologin vorkonfiguriert

---

## 📌 Hinweise

- **Das Image richtet sich an fortgeschrittene Nutzer, die mit einem Terminal-Menü arbeiten können.**
- Eine grafische Oberfläche (Desktop) ist **nicht enthalten** – das Menü läuft direkt im Terminal.
- WLAN muss bei älteren Pis oder bestimmten USB-Sticks ggf. manuell aktiviert werden (siehe Menüpunkt 11).

---

## 🙌 Dank an die Community

Ein herzliches Danke an alle aus dem **Stummiforum** und dem **Rocrail-Forum**, für das wertvolle Feedback und die Ideen zur Verbesserung des Images!

---

## 🔗 Projektseite

👉 [https://github.com/OliS2811/raspi-rocrail-config](https://github.com/OliS2811/raspi-rocrail-config)
