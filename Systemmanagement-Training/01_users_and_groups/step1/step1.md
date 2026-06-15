# Step 1: Verstehen von Usern und Gruppen

## Kernkonzepte

### Was ist ein User?

Ein **Benutzer/User** (oder Account) unter Linux kann Programme ausführen und Dateien besitzen. Jeder Benutzer hat:

- **Username**: einen eindeutigen Namen (z.B. `john`, `sarah`)
- **UID**: eine eindeutige User Identification Number (z.B. 1000, 1001)
- **Primäre Gruppe**: Hauptgruppe die dem User zugeordnet ist. Ein User kann mehreren Gruppen angehören, muss aber immer genau eine primäre Gruppe haben (Standard: selber Name wie Username)
- **Home-Verzeichnis**: Standardverzeichnis, in dem sich ein Benutzer nach dem Login befindet (z.B. `/home/john`)
- **Login Shell**: Shell die verwendet wird, wenn sich ein User einloggt (z.B. `/bin/bash`)

### Was ist eine Gruppe?

Eine **Gruppe** ist eine Sammlung von Benutzern, die gemeinsame Berechtigungen für Dateien und Verzeichnisse teilen. Jede Gruppe hat:

- **Gruppenname**: Eindeutiger Bezeichner (z.B. `developers`, `accounting`)
- **GID (Group ID)**: Eindeutige numerische Kennung (z.B. 1000, 1001)
- **Mitglieder**: Benutzer/User, die der Gruppe angehören

## Primäre und Sekundäre Gruppen

Die Benutzer- und Gruppenzuordnung entscheidet, wer auf welche Verzeichnisse und Dateien zugreifen darf.

### Primäre Gruppe
- Jeder Benutzer ist genau **einer** primären Gruppe zugeordnet (4. Spalte in `/etc/passwd`)
- Wird beim Erstellen des Benutzers festgelegt
- Neu erstellte Dateien gehören standardmäßig dieser Gruppe
- Nach dem Login ist immer die primäre Gruppe aktiv

### Sekundäre Gruppen
- Ein User kann beliebig vielen sekundären Gruppen zugeordnet werden (letzte Spalte in `/etc/group`)
- Ermöglicht gemeinsamen Zugriff auf Gruppenressourcen
- Wird mit `usermod -a -G` hinzugefügt
- Der Benutzer kann mit `newgrp` eine andere seiner Gruppen aktivieren

## Warum Gruppen wichtig sind

Gruppen erlauben:
- **Gemeinsamer Zugriff**: Mehrere Benutzer können auf dieselben Dateien/Verzeichnisse zugreifen
- **Projektorganisation**: Dateien nach Projektteams gruppieren
- **Rechtemanagement**: Berechtigungen an Gruppen statt an einzelne Benutzer vergeben

### Praktischer Anwendungsfall

Gruppen müssen nicht zwangsläufig die Unternehmensstruktur widerspiegeln.
Gruppen werden bei Bedarf eingerichtet, wenn mehrere Benutzer Dateien gemeinsam nutzen/bearbeiten sollen (gemeinsames Projekt):

1. Neue Gruppe für das Projekt einrichten
2. Gemeinsames Verzeichnis einrichten
3. Die betreffenden Benutzer der neuen Gruppe zuordnen

## Systeminformationen anzeigen

Führe die folgenden Befehle aus, um die User- und Gruppeninfos deines Systems zu erkunden:

```bash
# Aktuellen Benutzer anzeigen
whoami
```

```bash
# Detaillierte UID/GID-Informationen anzeigen
id
```

```bash
# Alle Gruppen des aktuellen Benutzers auflisten
groups
```

```bash
# Ersten 10 Einträge der Passwortdatei anzeigen
head /etc/passwd
```

```bash
# Ersten 10 Gruppeneinträge anzeigen
head /etc/group
```

## Aufgabe

Führe den folgenden Befehl aus, um deine Benutzer- und Gruppeninformationen zu speichern:

```bash
id > /tmp/step1_verification.txt && groups >> /tmp/step1_verification.txt
```

Überprüfe das Ergebnis:

```bash
cat /tmp/step1_verification.txt
```

## Key Takeaways

✓ Benutzer haben eindeutige Benutzernamen und UIDs  
✓ Jeder Benutzer gehört mindestens einer primären Gruppe an  
✓ Benutzer können Mitglieder mehrerer sekundärer Gruppen sein  
✓ Gruppen ermöglichen Rechteverwaltung und gemeinsamen Zugriff auf Dateien

Weiter zu den Konfigurationsdateien! Klicke auf **Next**.
