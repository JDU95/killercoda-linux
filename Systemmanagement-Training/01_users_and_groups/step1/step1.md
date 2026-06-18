# Step 1: Verstehen von Usern und Gruppen

## Aufgabe

Erkunde dein System – du kannst unten stehende Befehle ausführen und dir die Ausgaben ansehen.
Du musst auch die beiden Befehle eingeben zum Anzeigen von User-Infos und zum anzeigen der aktuellen Gruppen diese sind hier noch nicht sofort angezeigt(falls du sie noch nicht weißt findest du sie in der Theorie unten erklärt):

```bash
whoami
head /etc/passwd
head /etc/group
```

> Die Theorie unten erklärt, was du siehst.

---

## Was ist ein User?

Ein **Benutzer/User** unter Linux kann Programme ausführen und Dateien besitzen. Jeder Benutzer hat:

- **Username**: einen eindeutigen Namen (z.B. `john`, `sarah`)
- **UID**: eine eindeutige User Identification Number (z.B. 1000, 1001)
- **Primäre Gruppe**: Hauptgruppe des Users – neu erstellte Dateien gehören dieser Gruppe
- **Home-Verzeichnis**: Startverzeichnis nach dem Login (z.B. `/home/john`)
- **Login Shell**: z.B. `/bin/bash`

## Was ist eine Gruppe?

Eine **Gruppe** ist eine Sammlung von Benutzern mit gemeinsamen Berechtigungen. Jede Gruppe hat:

- **Gruppenname**: z.B. `developers`, `accounting`
- **GID (Group ID)**: eindeutige numerische Kennung
- **Mitglieder**: alle User, die der Gruppe angehören

## Primäre und Sekundäre Gruppen

### Primäre Gruppe
- Jeder Benutzer ist genau **einer** primären Gruppe zugeordnet (4. Spalte in `/etc/passwd`)
- Neue Dateien gehören automatisch dieser Gruppe
- Nach dem Login ist immer die primäre Gruppe aktiv

### Sekundäre Gruppen
- Ein User kann beliebig vielen sekundären Gruppen angehören (letzte Spalte in `/etc/group`)
- Ermöglicht gemeinsamen Zugriff auf Gruppenressourcen
- Hinzufügen mit `usermod -a -G gruppenname username`
- Aktive Gruppe wechseln mit `newgrp gruppenname`

## Was du gerade gesehen hast

| Befehl | Was er zeigt |
|--------|-------------|
| `whoami` | Den aktuellen Benutzernamen |
| `id` | UID, primäre GID und alle Gruppen-IDs |
| `groups` | Alle Gruppen des aktuellen Benutzers (nur Namen) |
| `head /etc/passwd` | Die ersten 10 Zeilen der Benutzerdatenbank |
| `head /etc/group` | Die ersten 10 Zeilen der Gruppendatenbank |

**Beispielausgabe von `id`:**
```
uid=1000(joe) gid=1000(joe) groups=1000(joe),27(sudo),1001(bank)
```
- `uid=1000(joe)` – Benutzer-ID
- `gid=1000(joe)` – primäre Gruppe
- `groups=...` – alle Gruppen (primäre + sekundäre)

## Warum Gruppen wichtig sind

Gruppen ermöglichen:
- **Gemeinsamen Dateizugriff**: mehrere User können auf dieselben Ressourcen zugreifen
- **Projektorganisation**: Dateien nach Projektteams gruppieren
- **Rechtemanagement**: Berechtigungen an Gruppen statt Einzelpersonen vergeben

Typischer Ablauf für ein neues Projekt:
1. Neue Gruppe einrichten
2. Gemeinsames Verzeichnis anlegen
3. Betreffende Benutzer der Gruppe zuordnen

## Key Takeaways

✓ Benutzer haben eindeutige Benutzernamen und UIDs  
✓ Jeder Benutzer gehört genau einer primären Gruppe an  
✓ Sekundäre Gruppen erlauben zusätzliche Zugriffsrechte  
✓ `id` zeigt UID + alle GIDs; `groups` zeigt nur die Gruppennamen

Weiter zu den Konfigurationsdateien! Klicke auf **Next**.
