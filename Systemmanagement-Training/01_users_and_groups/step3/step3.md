# Step 3: User erstellen mit useradd

## Das useradd-Kommando

Das Kommando **useradd** ist der Standardweg zum Erstellen neuer Benutzerkonten.
Bei Verwendung wird automatisch:
- Ein Eintrag in `/etc/passwd` angelegt
- Das Home-Verzeichnis erstellt (mit `-m`)
- Die Skeleton-Konfigurationsdateien aus `/etc/skel` kopiert
- Die korrekten Berechtigungen gesetzt

### Grundlegende Verwendung

```bash
# User mit Standardeinstellungen erstellen
sudo useradd benutzername

# User mit vollständigem Namen
sudo useradd -c "Vollständiger Name" benutzername
```

### Wichtige Optionen

| Option | Beschreibung |
|--------|-------------|
| `-c "Kommentar"` | Vollständiger Name oder Beschreibung |
| `-d /home/verz` | Home-Verzeichnis (Standard: `/home/username`) |
| `-m` | Home-Verzeichnis anlegen |
| `-g gruppenname` | Primäre Gruppe (Standard: neue Gruppe mit gleichem Namen) |
| `-G gruppe1,gruppe2` | Sekundäre Gruppen (kommagetrennt) |
| `-s /bin/shell` | Login-Shell (Standard: `/bin/bash`) |
| `-u UID` | Bestimmte UID vergeben |
| `-e JJJJ-MM-TT` | Ablaufdatum des Accounts |
| `-D` | Standardeinstellungen anzeigen/ändern |

### usermod – Account nachträglich ändern

```bash
# Sekundäre Gruppe hinzufügen (-a = append, wichtig!)
sudo usermod -a -G gruppenname benutzername

# Login-Namen ändern
sudo usermod -l neuer_name alter_name

# Home-Verzeichnis verschieben (Daten bleiben erhalten)
sudo usermod -m -d /home/neues_verz benutzername
```

### userdel – Account löschen

```bash
# Account entfernen (Daten bleiben erhalten)
sudo userdel benutzername

# Account und Home-Verzeichnis entfernen
sudo userdel -r benutzername
```

## Beispiel: Neuen Account einrichten

```bash

# User mit primärer default Gruppe und Shell erstellen
sudo useradd -c "Alice Smith"  -s /bin/bash -m alice

# Prüfen
grep "^alice:" /etc/passwd
ls -la /home/alice
```

## Create User with specific Primary Group

Let's create a user with a specific primary group:

```bash
# First, create a group (we'll learn this in detail later)
sudo groupadd developers

# Create user with developers as primary group
sudo useradd -c "Bob Johnson" -g developers -s /bin/bash bob
```

Verify:
```bash
grep "^bob:" /etc/passwd
grep "^developers:" /etc/group
```

## Create User with Secondary Groups

Create a user belonging to multiple groups:
```bash
# Create additional groups
sudo groupadd admins
sudo groupadd testing

# Create user with secondary groups
sudo useradd -c "Charlie Davis" -g developers -G admins,testing -s /bin/bash charlie
```

Verify:
```bash
# Check /etc/passwd
grep "^charlie:" /etc/passwd

# Check all groups
groups charlie
```


## Viewing User Information

```bash
# Show all users (including system users)
cut -d: -f1 /etc/passwd

# Count total users
wc -l /etc/passwd

# Show users with home in /home directory
cat /etc/passwd | grep "^[^:]*:[^:]*:[0-9]*:[0-9]*:[^:]*:/home/"
```

## Aufgabe (Übung 1 – Teil 1)

Richte einen neuen Benutzeraccount mit folgenden Einstellungen ein:

| Einstellung | Wert |
|-------------|------|
| Account-Name | `klaas` |
| Primäre Gruppe | `duck` |
| Vollständiger Name | `Klaas Klever` |
| Home-Verzeichnis | `/home/klaas_klever` |
| Shell | `/bin/bash` |

**Schritt 1: Primäre Gruppe erstellen**

```bash
sudo groupadd duck
```

**Schritt 2: Benutzer anlegen**

```bash
sudo useradd -c "Klaas Klever" -g duck -d /home/klaas_klever -m -s /bin/bash klaas
```

**Schritt 3: Überprüfen**

```bash
# Eintrag in /etc/passwd prüfen
grep "^klaas:" /etc/passwd

# Primäre Gruppe prüfen
grep "^duck:" /etc/group

# Home-Verzeichnis prüfen
ls -la /home/klaas_klever
```


> **Hinweis:** `useradd` doesn't set a password! You must use `passwd` (next step)

⚠️ **Default Shell**: Verify the shell exists in `/etc/shells`:
```bash
cat /etc/shells
```
⚠️ **Home Directory**: Created from `/etc/skel` template:
```bash
ls -la /etc/skel
```

## Key Takeaways

✓ `useradd` legt Benutzer an, setzt aber **kein** Passwort  
✓ `-g` setzt die primäre, `-G` setzt sekundäre Gruppen  
✓ Ohne `-m` wird kein Home-Verzeichnis erstellt  
✓ Mit `usermod` können Einstellungen nachträglich geändert werden  
✓ Die Skeleton-Dateien aus `/etc/skel` werden beim Anlegen kopiert

Bereit, das Passwort zu setzen? Weiter zum nächsten Schritt!
