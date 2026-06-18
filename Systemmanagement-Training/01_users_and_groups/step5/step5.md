# Step 5: Gruppen verwalten

## Gruppen-Kommandos

### Gruppen erstellen mit groupadd

```bash
sudo groupadd gruppenname
sudo groupadd -g GID gruppenname    # Bestimmte GID vergeben
```

### Gruppen ändern mit groupmod

```bash
sudo groupmod -n neuer_name alter_name   # Gruppe umbenennen
sudo groupmod -g neue_GID gruppenname    # GID ändern
```

### Gruppen löschen mit groupdel

```bash
sudo groupdel gruppenname    # Gruppe löschen
```

> **Hinweis:** Löschen ist nicht erlaubt, wenn die Gruppe die aktive primäre Gruppe eines Benutzers ist.

### Benutzer zu Gruppen hinzufügen

```bash
# Sekundäre Gruppe hinzufügen (IMMER -a verwenden!)
sudo usermod -a -G gruppenname benutzername

# Mehrere sekundäre Gruppen hinzufügen
sudo usermod -a -G gruppe1,gruppe2 benutzername

# Primäre Gruppe ändern
sudo usermod -g neue_gruppe benutzername
```

> **Wichtig:** Ohne `-a` werden alle bestehenden sekundären Gruppen des Benutzers ersetzt!

## Primäre und Sekundäre Gruppen

### Primäre Gruppe
- In `/etc/passwd` Feld 4 gespeichert
- Nicht entfernbar
- Neu erstellte Dateien gehören dieser Gruppe

### Sekundäre Gruppen
- In `/etc/group` (letzte Spalte) gespeichert
- Mit `usermod -a -G` hinzufügen
- Mit `gpasswd -d benutzername gruppenname` entfernen
- Mit `newgrp gruppenname` kann der Benutzer zwischen Gruppen wechseln

### Gruppen anzeigen

```bash
# Alle Gruppen eines Benutzers anzeigen
groups klaas

# Detaillierte UID/GID-Information
id klaas

# Alle Mitglieder einer Gruppe anzeigen
getent group duck
```

## Praktisches Beispiel: Projektgruppen

So könnte ein typisches Szenario aussehen:

```bash
# Projektgruppen erstellen
sudo groupadd webdev
sudo groupadd backend
sudo groupadd devops

# Verify groups were created
grep -E "^(webdev|backend|devops):" /etc/group
```

### Add Users to Groups



# Add alice to webdev group
sudo usermod -a -G webdev alice


e
```

### Check Group Contents

```bash
# Show all members of a group
grep "^webdev:" /etc/group

# List all groups for a user
id alice


```

### Create Shared Project Directory

Create a directory where team members can collaborate:

```bash
# Create project directory
sudo mkdir -p /projects/webdev

# Set group ownership to webdev
sudo chown :webdev /projects/webdev

# Set permissions: owner full, group read/write/execute
sudo chmod 770 /projects/webdev

# Überprüfen
ls -ld /projects/webdev

# Show user's primary and secondary groups
groups alice
```

## Aufgabe

Füge den Benutzer `klaas` aus den vorherigen Schritten einer neuen sekundären Gruppe hinzu:

**Schritt 1: Neue Gruppe erstellen**

```bash
sudo groupadd quack
```

**Schritt 2: klaas zur Gruppe quack hinzufügen (sekundär)**

```bash
sudo usermod -a -G quack klaas
```

**Schritt 3: Überprüfen**

```bash
# Alle Gruppen von klaas anzeigen
groups klaas

# Detaillierte Gruppeninfo
id klaas

# Mitglieder der Gruppe quack prüfen
getent group quack
```

**Erwartete Ausgabe von `groups klaas`:**
```
klaas : duck quack
```

> `duck` ist weiterhin die primäre Gruppe. `quack` wurde als sekundäre Gruppe hinzugefügt.

## Key Takeaways

✓ `groupadd` erstellt neue Gruppen  
✓ `groupmod -n` benennt Gruppen um  
✓ `groupdel` löscht Gruppen (nicht wenn primäre Gruppe eines aktiven Users)  
✓ `usermod -a -G` fügt sekundäre Gruppen hinzu – **IMMER `-a` verwenden!**  
✓ `groups` und `id` zeigen die Gruppenzugehörigkeit eines Benutzers

Bereit für das große Projekt-Szenario? Weiter zum nächsten Schritt!
