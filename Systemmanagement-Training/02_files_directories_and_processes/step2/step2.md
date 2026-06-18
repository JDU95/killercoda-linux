# Step 2: umask und Default-Zugriffsrechte

## Woher kommen die Default-Zugriffsrechte?

Wenn eine neue Datei oder ein neues Verzeichnis erzeugt wird, bestimmt die **umask** die Standard-Zugriffsrechte.

```bash
# Als root:
root# touch file && mkdir dir && ls -ld file dir
-rw-r--r-- 1 root root 0 file      # 644
drwxr-xr-x 2 root root 6 dir       # 755

# Als joe:
joe$ touch file && mkdir dir && ls -ld file dir
-rw-rw-r-- 1 joe joe 0 file        # 664
drwxrwxr-x 2 joe joe 6 dir         # 775
```

Die Unterschiede erklären sich durch unterschiedliche umask-Werte.

## umask – die Bit-Maske

```bash
root# umask
0022

joe$ umask
0002
```

Die umask enthält die **Bits, die NICHT gesetzt werden sollen**.

### umask-Mathematik

```
Verzeichnisrechte = 777 - umask
Dateirechte       = wie Verzeichnis, aber x-Bits werden NIE gesetzt
```

| umask | Neue Verzeichnisse | Neue Dateien |
|-------|-------------------|--------------|
| 0022  | 755 (rwxr-xr-x)   | 644 (rw-r--r--) |
| 0002  | 775 (rwxrwxr-x)   | 664 (rw-rw-r--) |
| 0077  | 700 (rwx------)   | 600 (rw-------) |
| 0027  | 750 (rwxr-x---)   | 640 (rw-r-----) |

**Beispiel:** umask = 027 → Verzeichnisse bekommen 777 - 027 = 750 (rwxr-x---), Dateien 640 (rw-r-----)

**Rückrechnung:** Ich will Verzeichnisse mit 754. Welche umask? → 777 - 754 = **023**

## Wichtig: chmod +x und umask

```bash
chmod +x  # Fügt nur die x-Bits hinzu, die die umask ERLAUBT
chmod -x  # Löscht alle x-Bits, die laut umask nicht vorgesehen sind
```

## Globale umask-Voreinstellung

| System | Ort |
|--------|-----|
| Red Hat / CentOS | `/etc/bashrc`, `/etc/profile` |
| Debian / Ubuntu | `/etc/login.defs` (via PAM) |
| Individuell | `~/.bashrc` (gilt nur für diesen Benutzer) |

Häufige Defaults: **0022** für root, **0002** für normale Benutzer.

---

## Aufgabe (Übung 2 + Übung 3)

**Übung 2: Mit umask experimentieren**

Neue Verzeichnisse sollen `rwx------` (700), neue Dateien `rw-------` (600) haben.

```bash
# Welche umask ergibt 700? → 777 - 700 = 077
umask 077

# Testen:
touch /tmp/testfile_077
mkdir /tmp/testdir_077
ls -ld /tmp/testfile_077 /tmp/testdir_077
# Erwartet: 600 für Datei, 700 für Verzeichnis

# Aufräumen:
rm -f /tmp/testfile_077
rmdir /tmp/testdir_077
```

**Rechenaufgabe:** Die umask lautet **027**.  
- Neues Verzeichnis → `777 - 027 = 750` (rwxr-x---)  
- Neue Datei → `640` (rw-r-----)

```bash
# Verifizieren:
umask 027
touch /tmp/testfile_027 && mkdir /tmp/testdir_027
stat -c '%a %n' /tmp/testfile_027 /tmp/testdir_027
# Erwartet: 640, 750
rm -f /tmp/testfile_027 && rmdir /tmp/testdir_027
```

**Übung 3: umask dauerhaft für joe konfigurieren**

Joe soll neue Dateien standardmäßig so anlegen, dass **user owner und group owner** lesen und schreiben dürfen, andere nicht (`rw-rw----` = 660 für Dateien, `rwxrwx---` = 770 für Verzeichnisse).

Benötigte umask: `777 - 770 = 007` → umask **007**

```bash
# umask permanent in joes ~/.bashrc eintragen:
echo 'umask 0007' | sudo tee -a /home/joe/.bashrc

# Verifizieren:
grep umask /home/joe/.bashrc
```

> **Hinweis:** Die umask gilt erst nach dem nächsten Login oder `source ~/.bashrc`.

## Key Takeaways

✓ `umask` zeigt die aktuelle Bit-Maske an und ändert sie  
✓ Formel: `777 - umask = Verzeichnisrechte` (Dateirechte ohne x-Bits)  
✓ root: 0022, normale Benutzer: 0002 (häufigste Defaults)  
✓ Permanent setzen: `umask 0002` am Ende von `~/.bashrc` eintragen

Weiter zu den Spezial-Bits!
