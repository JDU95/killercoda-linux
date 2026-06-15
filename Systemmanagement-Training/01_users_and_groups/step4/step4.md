# Step 4: Passwörter und Password-Aging verwalten

## Passwörter setzen mit passwd

Das Kommando **passwd** setzt oder ändert Passwörter.

```bash
# Eigenes Passwort interaktiv ändern
passwd

# Passwort eines anderen Users setzen (nur root)
sudo passwd benutzername

# Set password non-interactively (for scripts)
echo "newpassword" | sudo passwd --stdin username

# Account sperren (Lock)
sudo passwd -l benutzername

# Account entsperren (Unlock)
sudo passwd -u benutzername

```

**Wie funktioniert Lock/Unlock?**  
`passwd -l` stellt ein `!` an den Beginn des Passwort-Hashes in `/etc/shadow`.
`passwd -u` entfernt das `!` wieder. Der Account existiert weiterhin, ein Login ist aber nicht möglich.


## Password-Aging mit chage

Das Kommando **chage** verwaltet Passwort-Ablaufrichtlinien und verbessert die Sicherheit durch erzwungene regelmäßige Passwortwechsel.

### chage-Optionen

| Option | Beschreibung |
|--------|-------------|
| `-l username` | Aktuelle Einstellungen anzeigen |
| `-d 0 username` | Zwingt beim nächsten Login zum Passwort-Wechsel |
| `-M n username` | Passwort muss spätestens nach n Tagen geändert werden |
| `-W n username` | Warnung n Tage vor Ablauf des Passworts |
| `-i n username` | Account wird n Tage nach Passwortablauf deaktiviert |
| `-E JJJJ-MM-TT username` | Account läuft zum angegebenen Datum ab |

### Einstellungen anzeigen

```bash
sudo chage -l klaas
```


### Set Initial Password
Let's set a password for alice:
```bash
# Set password for alice (will prompt for input)
sudo passwd alice
# Enter: alice123 (for demo purposes)
```
Verify in `/etc/shadow`:

```bash
# Show alice's shadow entry (password hash)
sudo grep "^alice:" /etc/shadow
```


### Neuen Account testen

Nach dem Erstellen eines Accounts empfiehlt sich:
- Benutzernamen, Passwort und Home-Verzeichnis überprüfen
- Init-Dateien prüfen (PATH, Aliase etc.)
- Mit `su - username` vorübergehend in den Account wechseln

```bash
# In Account wechseln (als root ohne Passwort)
su - klaas
```

## Aufgabe (Übung 1 – Teil 2)

Schließe die Einrichtung des Benutzers `klaas` aus Step 3 ab:

**Schritt 1: Passwort für klaas setzen**

```bash
sudo passwd klaas
# Gib das gewählte Passwort zweimal ein
```

**Schritt 3: Passwort-Richtlinien konfigurieren**

`klaas` muss sein Passwort nach dem ersten Login wechseln, danach alle 180 Tage:

```bash
# Sofortiger Passwortwechsel beim ersten Login erzwingen
# Danach alle 180 Tage wechseln
sudo chage -d 0 -M 180 klaas
```

**Schritt 4: Einstellungen überprüfen**

```bash
sudo chage -l klaas
```

Erwartete Ausgabe (Auszug):
```
Last password change                    : password must be changed
Maximum number of days between password change  : 180
```

**Schritt 5: Account testen**

```bash
# Überprüfe den shadow-Eintrag (Passwort-Hash muss gesetzt sein)
sudo grep "^klaas:" /etc/shadow
```


## Understanding /etc/shadow

View the shadow file to understand password aging:

```bash
# Show shadow format (only root can read this!)
sudo cat /etc/shadow | head -5

# Parse shadow file - format:
# username:password-hash:last-change:min-days:max-days:warning:inactive:expire:reserved

# Example fields explained:
sudo awk -F: '{if (NR <= 3) print "Username: "$1" | Last changed: "$3" | Max days: "$5}' /etc/shadow
```

⚠️ **Password History**: Check password requirements:
```bash
# View password requirements
sudo cat /etc/login.defs | grep -E "^PASS"
```

## Key Takeaways

✓ `passwd username` setzt das Passwort für einen Benutzer (nur root)  
✓ `chage -d 0` erzwingt einen Passwortwechsel beim nächsten Login  
✓ `chage -M 180` setzt das maximale Passwort-Alter auf 180 Tage  
✓ `passwd -l` sperrt, `passwd -u` entsperrt einen Account  
✓ Sichere Passwörter mit `mkpasswd` generieren

Weiter zur Gruppenverwaltung! Klicke auf **Next**.
