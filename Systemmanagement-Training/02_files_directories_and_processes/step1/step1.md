# Step 1: Zugriffsrechte – rwx, chown, chmod

## Dateien und Verzeichnisse in Linux

Linux speichert mit jeder Datei drei Informationen:
- **Besitzer** (user owner)
- **Gruppe** (group owner)
- **Zugriffsrechte** (rwx für owner / group / others)

Dateien haben je nach Typ unterschiedliche Rollen:
- Reguläre Datei (`-`): Speicherung von Daten
- Ausführbare Datei: execute-Bit gesetzt → Programm/Skript
- Verzeichnis (`d`): Organisation des Dateisystems
- Device (`b`/`c`): Zugriff auf Hardware
- Soft Link (`l`): Zeiger auf eine andere Datei

## rwx für Dateien

| Bit | Bedeutung |
|-----|-----------|
| `r` | Datei darf gelesen werden |
| `w` | Datei darf verändert werden |
| `x` | Datei kann ausgeführt werden (Shell-Scripts brauchen zusätzlich `r`) |

> **Achtung:** Um eine Datei zu **löschen**, braucht man kein `w`-Recht auf die Datei, sondern `w`-Recht auf das **Verzeichnis**, in dem sie liegt!

## rwx für Verzeichnisse

| Kombination | Bedeutung |
|-------------|-----------|
| `---` | kein Zugriff |
| `r--` | Dateinamen auflisten (`ls`), aber keine Metadaten |
| `--x` | `cd` möglich, Dateizugriff wenn Dateiname bekannt |
| `r-x` | Normalfall: Dateien auflisten und lesen/schreiben |
| `-wx` | Drop-Box: Dateien ablegen, aber nicht sehen |
| `rwx` | uneingeschränkter Zugriff |

## Dateitypen in ls -l

```
-rw-r--r-- 1 root root  2291 passwd       # reguläre Datei
drwxr-xr-x 2 root root  4096 /etc         # Verzeichnis
lrwxrwxrwx 1 root root     7 /bin -> usr/bin  # Soft Link
brw-rw---- 1 root disk  8, 0 /dev/sda     # Block Device
crw-rw-rw- 1 root root  1, 5 /dev/zero    # Character Device
```

## chown und chgrp

```bash
# Besitzer ändern (nur root!)
chown neuer-besitzer datei
chown neuer-besitzer:neue-gruppe datei

# Nur Gruppe ändern
chgrp neue-gruppe datei

# Rekursiv für ganzes Verzeichnis
chown -R joe:bank /projects/bank
```

> Nur **root** kann `chown` ausführen. Normale Benutzer können mit `chgrp` nur auf eigene Gruppen wechseln.

## chmod – symbolische Notation

```
chmod [Klasse][Operator][Typ] datei
```

| Klasse | Bedeutung |
|--------|-----------|
| `u` | user (Besitzer) |
| `g` | group |
| `o` | others |
| `a` | all (u+g+o) |

| Operator | Bedeutung |
|----------|-----------|
| `+` | Recht hinzufügen |
| `-` | Recht entfernen |
| `=` | Rechte exakt setzen |

```bash
chmod u+x skript.sh          # Besitzer darf ausführen
chmod g=rw datei             # Gruppe: nur lesen+schreiben
chmod o-rwx datei            # Anderen alle Rechte nehmen
chmod u=rwx,g=rx,o= verz    # Komplex: 750
```

## chmod – oktale Notation

Jede Gruppe (u/g/o) ist eine 3-Bit-Zahl: `r=4`, `w=2`, `x=1`

```
chmod 754 peter
```

| | User | Group | Other |
|--|------|-------|-------|
| Rechte | rwx | r-x | r-- |
| Binär | 111 | 101 | 100 |
| Oktal | **7** | **5** | **4** |

```bash
chmod 640 datei    # rw-r-----  (joe lesen+schreiben, gruppe lesen, andere nichts)
chmod 770 verz     # rwxrwx---  (besitzer+gruppe alles, andere nichts)
chmod 750 verz     # rwxr-x---
```

## ls vs. stat

```bash
ls -l /etc/passwd /etc/shadow
# -rw-r--r-- 1 root root 2291 passwd
# ---------- 1 root root 1277 shadow

# Oktalcode lesen:
stat -c '%a %n' /etc/passwd /etc/shadow
# 644 /etc/passwd
# 0   /etc/shadow
```

---

## Aufgabe (Übung 1)

Arbeite als root im Verzeichnis `/projects/bank`:

**Teil A: Datei `test1` erstellen**

```bash
# Datei erzeugen und Besitzer/Gruppe setzen
sudo touch /projects/bank/test1
sudo chown joe:bank /projects/bank/test1

# Rechte setzen: joe lesen+schreiben, bank-Gruppe lesen, andere nichts
sudo chmod u=rw,g=r,o= /projects/bank/test1

# Überprüfen (symbolisch)
ls -l /projects/bank/test1
```

**Teil B: Dasselbe mit oktaler Notation**

```bash
# 640 = rw-r-----
sudo chmod 640 /projects/bank/test1

# Oktal verifizieren
stat -c '%a %U %G %n' /projects/bank/test1
```

**Teil C: Verzeichnis `joe-and-jack` einrichten**

Nur joe und jack (beide in Gruppe `bank`) dürfen dieses Verzeichnis bearbeiten:

```bash
sudo mkdir /projects/bank/joe-and-jack
sudo chown joe:bank /projects/bank/joe-and-jack
sudo chmod 770 /projects/bank/joe-and-jack
```

**Teil D: Alle oktalen Codes in /projects/bank anzeigen**

```bash
stat -c '%a %n' /projects/bank/*
```

**Erwartetes Ergebnis:**
```
640 /projects/bank/test1
770 /projects/bank/joe-and-jack
```

## Key Takeaways

✓ `ls -l` zeigt Zugriffsrechte in rwx-Form; `stat -c '%a'` zeigt sie oktal  
✓ `chown` ändert Besitzer (nur root); `chgrp` ändert Gruppe  
✓ `chmod 640` = rw-r----- (Besitzer rw, Gruppe r, andere nichts)  
✓ Löschen einer Datei erfordert `w`-Recht auf das **Verzeichnis**, nicht die Datei

Weiter zum nächsten Schritt – `umask` und Default-Zugriffsrechte!
