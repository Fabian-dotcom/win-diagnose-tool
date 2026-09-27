# Win-Diagnose-Tool

![Windows](https://img.shields.io/badge/Platform-Windows-blue)  
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-informational)

## Projektbeschreibung

**Win-Diagnose-Tool** ist ein robustes Windows-Systemdiagnose-Tool für **Windows 10 und Windows 11**, das RAM, CPU, Sicherheitsstatus und Autostart überprüft.  
Es erstellt automatisch **Reports mit Status-Suffixen** `_OK`, `_HINWEIS`, `_GEFAHR` und bietet **eine übersichtliche Zusammenfassung** aller Checks.

Das Tool ist für Administratoren, Power-User oder Support-Techniker gedacht, die **schnell einen Überblick über die Systemgesundheit** erhalten möchten.

---

## Projektstruktur

```

diagnose/
├── start.bat                 # Startet Controller + Monitor
├── controller.bat            # Auswahlfenster für Aktionen
├── monitor.ps1               # Monitor-Fenster, Fortschritt, Spinner, Status
├── summarize.ps1             # Zusammenfassung aller Reports
├── checks/                   # Einzelne Check-Scripts
│   ├── ram.ps1               # RAM-Analyse
│   ├── cpu.ps1               # CPU-Analyse
│   ├── defender.ps1          # Sicherheits-Check
│   └── autostart.ps1         # Autostart-Programme prüfen
├── reports/                  # Output-Dateien (_OK/_HINWEIS/_GEFAHR)
└── status/                   # Kommunikationsdateien, command.txt


---

## Features

- **Windows-Version erkennen** (Win10 / Win11)  
- **RAM-Check:** Top 5 Prozesse, Statusberechnung  
- **CPU-Check:** Top 5 CPU-Prozesse, intelligente Statusbestimmung  
- **Sicherheits-Check:** Windows Defender, Real-Time Protection, Tamper Protection  
- **Autostart-Check:** Registry + Startup-Ordner  
- **Zusammenfassung:** Aggregiert Reports, Priorität GEFAHR > HINWEIS > OK  
- **Farbliche Statusanzeigen** in der Monitor-Konsole  
- **Spinner und Fortschrittsbalken** für laufende Aktionen  
- **Reports automatisch erzeugt** in `reports/`  
- **Zwei Konsolenfenster:** Controller + Monitor  
- **Vollständig synchron**, keine Start-Jobs → kompatibel mit PowerShell 5.1  

---

## Installation & Nutzung

1. **Repository klonen oder ZIP herunterladen**:

bash
git clone https://github.com/<username>/win-diagnose-tool.git
cd win-diagnose-tool


2. **Ordnerstruktur prüfen**

   * `status/` und `reports/` werden automatisch angelegt.

3. **Tool starten**:

```bat
start.bat
```

* Es öffnet sich **Controller-Fenster** für die Auswahl der Checks
* Ein zweites Fenster zeigt den **Diagnose-Monitor mit Fortschritt, Spinner und Statusanzeigen**

4. **Controller-Menü**:

| Option               | Beschreibung                    |
| -------------------- | ------------------------------- |
| 1 - Komplettdiagnose | Führt alle Checks aus           |
| 2 - Nur RAM          | Führt nur RAM-Check aus         |
| 3 - Nur Security     | Führt nur Sicherheits-Check aus |
| 4 - Beenden          | Beendet das Tool                |

---

## Beispiel-Reports

* `reports/RAM_OK.txt`
* `reports/SECURITY_HINWEIS.txt`
* `reports/AUTOSTART_GEFAHR.txt`
* `reports/SUMMARY_GEFAHR.txt`

Jede Datei enthält **Status, Top-Prozesse oder Details** und einen **Zeitstempel**.

---

## Technische Hinweise

* **PowerShell 5.1 kompatibel** (Windows 10/11)
* UTF-8 ohne BOM
* Keine Start-Jobs → keine Parser-Fehler
* Relative Pfade für alle Checks
* Dynamische Status-Bestimmung anhand von Schwellwerten

---

## Mögliche Erweiterungen

* ASCII-Ladebalken in Monitor-Fenster
* Blacklist / Whitelist für Prozesse
* Erweiterte Sicherheits-Checks (z.B. UAC, Firewall-Status, Antivirus-Datenbank)
* Auto-Fix Optionen (z.B. unnötige Prozesse beenden)
* Portierung in **eine EXE** via PS2EXE oder C++ Frontend
* Netzwerk-Checks, Internet-Verfügbarkeit, Ping-Tests
* Export als **HTML- oder CSV-Report** für leichteres Sharing
* Integration mit Monitoring-Tools oder Ticketsystemen

---

## Lizenz

Dieses Projekt ist unter der **MIT-Lizenz** lizenziert. Du darfst es frei nutzen, modifizieren und weitergeben.

---

## Hinweise

* Das Tool ist **rein diagnostisch** – es nimmt keine kritischen Änderungen am System vor.
* Alle Checks laufen **sicher und synchron**.
* Für Erweiterungen sollte immer ein Backup oder ein Testsystem verwendet werden.

---

> Entwickelt von Fabian-dotcom – Windows Diagnose Tool für Administratoren & Support-Techniker
