# Herzlichen Glückwunsch!

Du hast das Szenario **Dateien, Verzeichnisse und Prozesse** erfolgreich abgeschlossen!

## Was du gelernt hast

### Zugriffsrechte
- **rwx für Dateien**: r = lesen, w = schreiben, x = ausführen
- **rwx für Verzeichnisse**: r = ls, w = Dateien anlegen/löschen, x = cd + Dateizugriff
- **chown / chgrp**: Besitzer und Gruppe ändern (nur root darf chown)
- **chmod**: symbolisch (`u+rw`, `g-x`) und oktal (`chmod 640 datei`)
- **stat -c '%a %n'**: oktale Zugriffsbits lesen

### umask
- Formel: `777 - umask = Verzeichnisrechte`, x-Bits bei Dateien immer weg
- root: umask 0022 → neue Dateien 644, Verzeichnisse 755
- Normale Benutzer: umask 0002 → Dateien 664, Verzeichnisse 775
- Permanent in `~/.bashrc` eintragen

### Spezial-Bits
- **Setuid (4000)**: Prozess läuft mit Rechten des Dateibesitzers (z.B. `/usr/bin/passwd`)
- **Setgid (2000)** auf Verzeichnissen: neue Dateien erben die Gruppe des Verzeichnisses
- **Sticky (1000)** auf Verzeichnissen: nur der Dateibesitzer darf seine eigenen Dateien löschen (z.B. `/tmp`)

### Inodes und Links
- Inode: Metadaten einer Datei (UID, GID, Rechte, Größe, Zeitstempel, Datenblock-Zeiger)
- **Hard Link** (`ln quelle ziel`): zweiter Verzeichniseintrag auf dieselbe Inode
- **Soft Link** (`ln -s quelle ziel`): winzige Datei, deren Inhalt der Zielpfad ist

### Device-Dateien
- `b` = Block Device (Festplatten, gepuffert)
- `c` = Character Device (ungepuffert: `/dev/null`, `/dev/zero`, `/dev/random`)
- Major/Minor Number steuern Kernel-Treiber und Sub-Device

### Prozesse und Signale
- `ps aux` / `pstree -p` / `top`: Prozesse anzeigen
- `kill -SIGNAL pid` / `killall name`
- Wichtige Signale: 1 SIGHUP, 2 SIGINT, 9 SIGKILL, 15 SIGTERM, 19 SIGSTOP

## Schnellreferenz

```bash
chmod 640 datei          # rw-r-----
chmod 2770 /projects/bank  # setgid + rwxrwx---
stat -c '%a %n' datei    # oktal lesen
umask 0022               # Default setzen
ln -s /tmp /root/tmp     # Soft Link
dd if=/dev/zero of=file bs=1M count=10  # 10 MiB Datei
ps aux | grep bash       # bash-Prozesse
kill -9 PID              # Prozess sofort beenden
```

Weiter zum nächsten Szenario: **Paketverwaltung und Dienste**!
