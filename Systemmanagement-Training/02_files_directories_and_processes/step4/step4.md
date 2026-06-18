# Step 4: Inodes, Links und Device-Dateien

## Inodes – die Datei hinter der Datei

Jede Datei im Linux-Dateisystem hat eine **Inode** (Index Node): eine Datenstruktur, die alle Metadaten einer Datei enthält.

### Was ein Inode speichert

| Feld | Inhalt |
|------|--------|
| UID + GID | Besitzer und Gruppe |
| Zugriffsrechte | rwx-Bits + Spezial-Bits |
| Dateityp | regulär, Verzeichnis, Link, Device… |
| Dateigröße | in Bytes |
| Zeitstempel | letzte Änderung, letzter Zugriff |
| Hard-Link-Zähler | wie viele Verzeichniseinträge zeigen auf diesen Inode |
| Block-Pointer | direkte, indirekte, doppelt-indirekte Zeiger auf Datenblöcke |

> **Wichtig:** Der **Dateiname** und der **Pfad** stehen NICHT im Inode – sie stehen im Verzeichnis.

Die Anzahl der Inodes wird beim Formatieren des Dateisystems festgelegt (üblicherweise 256 Byte pro Inode) und **begrenzt, wie viele Dateien maximal existieren können**, unabhängig vom freien Speicher.

## Dateitypen

Der erste Buchstabe in `ls -l` zeigt den Dateityp:

| Zeichen | Typ |
|---------|-----|
| `-` | reguläre Datei |
| `d` | Directory |
| `l` | symbolischer Link (soft link) |
| `b` | Block Device (Festplatten, gepuffert) |
| `c` | Character Device (ungepuffert: /dev/null, /dev/zero…) |
| `s` | Socket |
| `p` | Named Pipe |

## Character und Block Devices

Device-Dateien sind die Schnittstelle zur Hardware über Kernel-Treiber.

- **Character Devices**: zeichenweise, ungepuffert (kleine Datenmengen)
- **Block Devices**: blockweise, gepuffert, schnell (große Datenmengen)

Jedes Device hat zwei Kennzahlen (`ls -l` zeigt sie statt der Dateigröße):
- **Major Number**: bestimmt den Kernel-Treiber
- **Minor Number**: bestimmt das Sub-Device (z.B. Partition)

```bash
ls -l /dev/sda /dev/zero /dev/null
# brw-rw---- 1 root disk  8,  0 /dev/sda     (Block Device)
# crw-rw-rw- 1 root root  1,  5 /dev/zero    (Character Device)
# crw-rw-rw- 1 root root  1,  3 /dev/null    (Character Device)
```

Nützliche Devices:
- `/dev/zero` – liefert unendlich viele Null-Bytes
- `/dev/null` – Datenmüll (Schreiben ignoriert, Lesen leer)
- `/dev/random` – Zufallszahlen (kryptografisch sicher)
- `/dev/sda` – erste Festplatte/SSD

```bash
# 10 MiB Datei aus Null-Bytes erzeugen:
dd if=/dev/zero of=/tmp/myzero bs=1M count=10
```

## Hard Links

Ein Hard Link ist ein **zweiter Verzeichniseintrag**, der auf dieselbe Inode zeigt.

```bash
ln quelle hardlink

ls -l datei hardlink
# -rw-r--r-- 2 root root 0 datei       ← Link-Count = 2
# -rw-r--r-- 2 root root 0 hardlink
```

- Beide Namen zeigen auf **dieselben Daten**
- Die Daten bleiben erhalten, solange **mindestens ein** Hard Link existiert
- Hard Links können **nicht über Dateisystemgrenzen** gehen
- Hard Links auf Verzeichnisse sind nicht erlaubt

## Soft Links (symbolische Links)

Ein Soft Link ist eine kleine Datei, deren Inhalt der **Pfad** zur Zieldatei ist.

```bash
ln -s quelle softlink

ls -l softlink
# lrwxrwxrwx 1 root root 6 softlink -> quelle
```

- Kann über Dateisystemgrenzen zeigen
- Wenn die Quelldatei gelöscht wird → **dangling link** (zeigt ins Nichts)
- `pwd` vs. `/bin/pwd`: Shell verfolgt den symbolischen Pfad, `/bin/pwd` fragt den Kernel

```bash
ln -s /tmp /root/tmp
cd /root/tmp
pwd          # zeigt /root/tmp (Shell-Sicht)
/bin/pwd     # zeigt /tmp     (Kernel-Sicht)
cd ..        # geht nach /root (nicht nach /)!
```

---

## Aufgabe

**Übung 9: Device-Datei und 10-MiB-Datei**

```bash
# Welchen Typ und welche Major/Minor-Number hat /dev/zero?
ls -l /dev/zero
# Erwartet: c (Character Device), Major=1, Minor=5

# 10 MiB Null-Bytes erzeugen:
dd if=/dev/zero of=/tmp/myzero bs=1M count=10

# Prüfen:
ls -lh /tmp/myzero
stat -c '%s %n' /tmp/myzero
# Erwartet: 10485760 /tmp/myzero
```

**Übung 10: Soft Link**

```bash
# Soft Link /root/tmp → /tmp anlegen:
ln -s /tmp /root/tmp

# In den Link wechseln und pwd vergleichen:
cd /root/tmp
pwd           # → /root/tmp
/bin/pwd      # → /tmp  (Unterschied wegen Symlink-Auflösung)

# Parent Directory:
cd ..
pwd           # → /root (Shell folgt dem symlink-Pfad zurück)
```

**Übung 11: Hard Link**

```bash
# Datei mit Inhalt erstellen:
echo "meine wichtige Info" > /root/wichtig.txt

# Hard Link anlegen:
ln /root/wichtig.txt /root/telefonnr.txt

# Link-Count prüfen (muss ≥ 2 sein):
ls -l /root/wichtig.txt /root/telefonnr.txt
stat -c '%h %n' /root/wichtig.txt /root/telefonnr.txt
# Erwartet: 2 für beide

# Originaldatei löschen:
rm /root/wichtig.txt

# Daten noch lesbar?
cat /root/telefonnr.txt
# Erwartet: "meine wichtige Info" → Daten NICHT verloren!
```

## Key Takeaways

✓ Inode speichert Metadaten; Dateiname steht im Verzeichnis  
✓ `dd if=/dev/zero of=file bs=1M count=10` erzeugt eine 10-MiB-Datei aus Nullen  
✓ Hard Link: zweiter Name auf dieselbe Inode – Daten überleben das Löschen einer Verknüpfung  
✓ Soft Link: Datei mit Zielpfad – `ls -l` zeigt `l` und `-> Ziel`  
✓ `ln -s quelle ziel` (soft), `ln quelle ziel` (hard)

Weiter zum letzten Schritt: Prozesse und Signale!
