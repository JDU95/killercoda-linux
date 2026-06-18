# Step 6: Übung 2 – Projektteams einrichten

## Szenario

Du bist der Systemadministrator eines Unternehmens mit zwei laufenden Projekten.

### Projekt `bank`
- Benutzer: **joe** (Joe Dalton), **jack** (Jack Dalton), **william** (William Dalton)
- Projektverzeichnis: `/projects/bank`

### Projekt `train`
- Benutzer: **joe** (Joe Dalton), **averall** (Averall Dalton)
- Projektverzeichnis: `/projects/train`

**Anforderungen:**
- Jeder Benutzer hat sein eigenes Home-Verzeichnis
- Benutzer haben Zugriff auf die jeweiligen Projektverzeichnisse
- Alle Accounts sollen nach **90 Tagen** deaktiviert werden
- Das Passwort muss innerhalb dieser Zeit alle **30 Tage** geändert werden

## Schritt 1: Projektgruppen erstellen

```bash
sudo groupadd bank
sudo groupadd train

# Überprüfen
grep -E "^(bank|train):" /etc/group
```

## Schritt 2: Benutzer anlegen

```bash
# Bank-Projekt
sudo useradd -c "Joe Dalton"     -s /bin/bash -m joe
sudo useradd -c "Jack Dalton"    -s /bin/bash -m jack
sudo useradd -c "William Dalton" -s /bin/bash -m william

# Train-Projekt (averall; joe wurde bereits angelegt)
sudo useradd -c "Averall Dalton" -s /bin/bash -m averall

# Überprüfen
grep -E "^(joe|jack|william|averall):" /etc/passwd | cut -d: -f1
```

## Schritt 3: Passwörter setzen

```bash


# Force password change on first login
sudo chage -d 0 joe
sudo chage -d 0 jack
sudo chage -d 0 william
sudo chage -d 0 averall

echo "Passwords set - users must change on first login"
```
# Sichere Passwörter setzen (interaktiv)
```bash
sudo passwd joe
sudo passwd jack
sudo passwd william
sudo passwd averall
```

### Step 4: Configure Password Policies

```bash
EXPIRY=$(date -d "+90 days" +%Y-%m-%d)

for user in joe jack william averall; do
  # Sofortigen Passwortwechsel beim ersten Login erzwingen
  sudo chage -d 0 "$user"
  # Passwort-Ablauf: alle 30 Tage, Warnung 7 Tage vorher
  sudo chage -M 30 -W 7 "$user"
  # Account-Ablauf: 90 Tage ab heute
  sudo chage -E "$EXPIRY" "$user"
done

# Beispiel-Überprüfung
echo "=== Richtlinien für joe ==="
sudo chage -l joe
```

## Schritt 5: Benutzer den Gruppen zuordnen

```bash
# joe ist in beiden Projekten
sudo usermod -a -G bank joe
sudo usermod -a -G train joe

# jack und william nur im Bank-Projekt
sudo usermod -a -G bank jack
sudo usermod -a -G bank william

# averall nur im Train-Projekt
sudo usermod -a -G train averall

# Überprüfen
echo "=== Gruppenverteilung ===" 
echo "bank:" && grep "^bank:" /etc/group
echo "train:" && grep "^train:" /etc/group
```

## Schritt 6: Projektverzeichnisse einrichten

```bash
# Verzeichnisse erstellen
sudo mkdir -p /projects/bank
sudo mkdir -p /projects/train

# Gruppenbesitz setzen
sudo chown :bank /projects/bank
sudo chown :train /projects/train

# Berechtigungen: Besitzer voll, Gruppe lesen/schreiben/ausführen, andere nichts
sudo chmod 770 /projects/bank
sudo chmod 770 /projects/train

# Überprüfen
ls -ld /projects/bank /projects/train
```

## Schritt 7: Gesamtüberprüfung

```bash
echo "=== Benutzer und Home-Verzeichnisse ==="
for user in joe jack william averall; do
  echo -n "$user: "
  getent passwd "$user" | cut -d: -f1,3,6
done

echo ""
echo "=== Gruppen der Benutzer ==="
for user in joe jack william averall; do
  echo "$user: $(groups $user | cut -d: -f2)"
done

echo ""
echo "=== Passwort-Richtlinien ==="
for user in joe averall; do
  echo "--- $user ---"
  sudo chage -l "$user" | grep -E "Password expires|Account expires|Maximum"
done

echo ""
echo "=== Projektverzeichnisse ==="
ls -ld /projects/bank /projects/train
```

## Zugriff testen

```bash
# Testdateien als jeweilige Benutzer erstellen
sudo -u joe   touch /projects/bank/joe_bank.txt
sudo -u jack  touch /projects/bank/jack_bank.txt
sudo -u joe   touch /projects/train/joe_train.txt
sudo -u averall touch /projects/train/averall_train.txt

echo "=== Bank-Verzeichnis ===" && ls -l /projects/bank/
echo "=== Train-Verzeichnis ===" && ls -l /projects/train/
```

## Fehlerkorrektur

Falls etwas schiefgelaufen ist:

```bash
# Benutzer aus Gruppe entfernen
sudo gpasswd -d joe bank

# Benutzer löschen (inkl. Home-Verzeichnis)
sudo userdel -r benutzername

# Gruppe löschen
sudo groupdel gruppenname
```

## Key Takeaways

✓ Gruppen und Benutzer werden logisch nach Projekten organisiert  
✓ `chage -E` setzt ein Account-Ablaufdatum  
✓ `chage -M 30` erzwingt Passwortwechsel alle 30 Tage  
✓ Projektverzeichnisse mit `chown :gruppe` und `chmod 770` absichern  
✓ `joe` ist Mitglied beider Projektgruppen (bank und train)

Bereit für den letzten Schritt – administrative Zugriffsrechte! Weiter zum nächsten Schritt!
