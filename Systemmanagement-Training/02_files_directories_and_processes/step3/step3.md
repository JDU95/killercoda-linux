# Step 3: Spezial-Bits – setuid, setgid, sticky

## Die drei Spezial-Bits

Über die normalen rwx-Bits hinaus gibt es drei weitere Bits:

### Setuid-Bit (4000) – für Dateien

Wenn eine Datei mit Setuid-Bit **ausgeführt** wird, erhält der Prozess die Rechte des **Dateibesitzers** (nicht die des aktuellen Benutzers).

```bash
ls -l /usr/bin/passwd
---s--x--x 1 root root /usr/bin/passwd
```

`passwd` muss `/etc/shadow` schreiben – das darf nur root. Dank Setuid läuft es mit root-Rechten, egal wer es aufruft. **Sicherheitsrisiko** bei falschem Einsatz!

### Setgid-Bit (2000)

**Für Dateien:** Prozess läuft mit der Gruppe der Datei (nicht der aktiven Gruppe des Users).

**Für Verzeichnisse:** Neue Dateien im Verzeichnis erben automatisch die Gruppe des Verzeichnisses – ideal für Projektverzeichnisse!

```bash
# Setgid auf Verzeichnis setzen:
chmod g+s /projects/bank
# oder oktal:
chmod 2770 /projects/bank
```

### Sticky-Bit (1000) – für Verzeichnisse

In einem Verzeichnis mit Sticky-Bit darf jeder Dateien ablegen, aber jeder Benutzer darf nur seine **eigenen** Dateien löschen.

```bash
ls -ld /tmp
drwxrwxrwt 14 root root 4096 /tmp
#        ^ t = sticky + x
```

Ohne Sticky-Bit könnte bei `chmod 777` jeder die Dateien anderer löschen.

## Darstellung der Spezial-Bits durch ls -l

| Bit | Position | Zeichen |
|-----|----------|---------|
| Setuid | x-Bit des Owners | `s` (mit x) / `S` (ohne x) |
| Setgid | x-Bit der Gruppe | `s` (mit x) / `S` (ohne x) |
| Sticky | x-Bit von Others | `t` (mit x) / `T` (ohne x) |

Ein `S` oder `T` (Großbuchstabe) deutet meist auf einen Fehler hin!

## Oktale Darstellung der Spezial-Bits

```
Setuid = 4000
Setgid = 2000
Sticky = 1000
```

```bash
chmod 4750 /usr/bin/meinprogramm   # Setuid + rwxr-x---
chmod 2770 /projects/bank          # Setgid + rwxrwx---
chmod 1777 /tmp                    # Sticky + rwxrwxrwx
```

> **Achtung:** `chmod <oktalcode>` kann Setuid/Setgid/Sticky nur **setzen**, nicht löschen!  
> Zum Löschen: `chmod u-s`, `chmod g-s`, `chmod -t`

## Anwendungsfälle

| Bit | Typische Anwendung |
|-----|-------------------|
| Setuid | `/usr/bin/passwd`, `/usr/bin/sudo` – müssen als root laufen |
| Setgid | Projektverzeichnisse – Dateien erben die Projektgruppe |
| Sticky | `/tmp` – jeder schreibt, keiner löscht fremde Dateien |

---

## Aufgabe (Übung 4)

**Setgid für Projektverzeichnisse setzen**

Die Verzeichnisse `/projects/bank` und `/projects/train` sollen so eingerichtet werden, dass:
- nur Gruppenmitglieder Dateien sehen und bearbeiten können
- alle neu erzeugten Dateien automatisch der richtigen Gruppe zugeordnet werden

```bash
# Setgid + volle Gruppenrechte, keine Rechte für andere:
sudo chmod 2770 /projects/bank
sudo chmod 2770 /projects/train

# Überprüfen:
ls -ld /projects/bank /projects/train
# Erwartet: drwxrws--- (s statt x bei Gruppe)

stat -c '%a %n' /projects/bank /projects/train
# Erwartet: 2770
```

**Testen ob Setgid wirkt:**

```bash
# Datei als joe erstellen – sollte Gruppe bank erhalten:
sudo -u joe touch /projects/bank/test_setgid
ls -l /projects/bank/test_setgid
# Erwartet: Gruppe = bank (nicht joes primäre Gruppe)
```

**Zusatz (Übung 6 – Beobachtung):**

```bash
# Wo ist passwd? Welche Spezial-Bits sind gesetzt? Warum?
which passwd
ls -l $(which passwd)
# Erwartet: ---s--x--x ... root root ... /usr/bin/passwd
# Setuid, weil passwd /etc/shadow schreiben muss (nur root darf das)
```

## Key Takeaways

✓ Setuid (4000): Prozess läuft mit Rechten des Dateibesitzers  
✓ Setgid (2000) auf Verzeichnissen: neue Dateien erben die Verzeichnisgruppe  
✓ Sticky (1000) auf Verzeichnissen: nur der Dateibesitzer darf seine Dateien löschen  
✓ `chmod 2770 /projects/bank` = Setgid + rwxrwx---  
✓ `ls -l` zeigt `s`/`t` für aktive Spezial-Bits, `S`/`T` wenn x fehlt (meist Fehler)

Weiter zu Inodes, Links und Device-Dateien!
