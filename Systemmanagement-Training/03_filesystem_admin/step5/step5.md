# Step 5: Filesystem Repair & fsck

## Aufgabe

Lerne wie beschädigte Dateisysteme repariert werden. Du musst:
- Das `fsck`-Kommando (oder `xfs_repair`) ausführen
- Verstehen wie Dateisystemprüfung funktioniert
- Optional: Ein beschädigtes Dateisystem absichtlich zerstören und reparieren

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## Dateisystemfehler

Dateisysteme können beschädigt werden durch:
- Stromausfälle während Schreibvorgängen
- Hardware-Fehler (fehlerhafte Blöcke)
- Kernel-Crashes
- Unsauberes Herunterfahren

### Typische Fehler

- Blöcke gehören zu mehreren Dateien
- Blöcke markiert als frei, werden aber verwendet
- Verlorene Dateien (Inodes ohne Verzeichniseintrag)
- Inkonsistenzen zwischen Dateigröße und Blockanzahl

---

## fsck — Dateisystemprüfung und Reparatur

**fsck** (filesystem check) prüft ext4, ext3, ext2, FAT, NTFS und andere Dateisysteme.

```bash
# Nur prüfen (read-only)
sudo fsck -n /dev/vdb1

# Mit automatischer Reparatur
sudo fsck -y /dev/vdb1

# Interaktive Reparatur (fragt bei jedem Fehler)
sudo fsck -r /dev/vdb1

# Nur ext4
sudo fsck.ext4 /dev/vdb1
```

### fsck-Optionen

| Option | Bedeutung |
|--------|-----------|
| `-n` | Nur prüfen, nichts ändern (read-only) |
| `-y` | Automatisch "ja" zu allen Fragen (Reparatur) |
| `-c` | Nach defekten Blöcken suchen (langsam) |
| `-r` | Interaktiv (Fragen bei jedem Fehler) |
| `-f` | Prüfung erzwingen (auch wenn sauber) |
| `-v` | Verbose (detaillierte Ausgabe) |

### Wichtig: fsck nur auf unmounteten Dateisystemen!

```bash
# **FEHLER** — Dateisystem ist gemountet!
sudo fsck /dev/vdb1

# **RICHTIG** — Erst umounten
sudo umount /dev/vdb1
sudo fsck -y /dev/vdb1

# **AUSNAHME** — Root-FS auf read-only prüfen
sudo fsck -n /
```

---

## xfs_repair — XFS-Dateisysteme reparieren

```bash
# Nur prüfen
sudo xfs_repair -n /dev/vdb1

# Mit Reparatur
sudo xfs_repair /dev/vdb1

# Dangerous mode (repariert auch gemountete read-only FS)
sudo xfs_repair -d /dev/vdb1
```

---

## Journaling und schnelle Wiederherstellung

**Journaling** ermöglicht schnelle Wiederherstellung nach Crashes:

1. Änderungen werden zuerst im Journal geschrieben
2. Danach werden sie auf der Disk angewendet
3. Nach Crash: Journal wird geprüft und ggfs. aufgeräumt
4. Ergebnis: schnelle Wiederherstellung ohne vollständige fsck

**Ohne Journaling**: fsck kann Stunden dauern (langsam!)
**Mit Journaling**: Wenige Sekunden (schnell!)

Alle modernen Linux-Dateisysteme haben Journaling:
- ext4 — Journaling für Metadaten (default)
- xfs — Journaling für Metadaten
- btrfs — Copy-on-Write

---

## Szenario: Dateisystem reparieren

### Szenario 1: Fehlerhafte Partition prüfen

```bash
# Partition nach Fehlern scannen (nicht reparieren)
sudo fsck -n /dev/vdb1

# Falls Fehler gefunden: Umounten und Reparatur
sudo umount /dev/vdb1
sudo fsck -y /dev/vdb1

# Wieder mounten
sudo mount /dev/vdb1 /mnt/myfs
```

### Szenario 2: Beschädigter Superblock

Der Superblock ist die Dateisystem-Struktur. Wenn beschädigt: Dateisystem nicht lesbar!

```bash
# Mit Backup-Superblock reparieren
sudo fsck.ext4 -b 32768 /dev/vdb1

# (32768 ist eine typische Backup-Superblock-Position)
```

### Szenario 3: Verlorene Dateien wiederherstellen

```bash
# Verlorene Dateien finden
sudo fsck -y /dev/vdb1

# Dateien werden in lost+found/ gespeichert
ls /mnt/myfs/lost+found/
```

---

## Übung: Dateisystem prüfen

Führe diese Befehle aus:

```bash
# 1. Dateisystem scannen (nur prüfen, nicht reparieren)
sudo fsck -n /dev/vdb1

# 2. Alternativ mit fsck.ext4
sudo fsck.ext4 -n /dev/vdb1

# 3. Nach Fehlern suchen (langsam!)
sudo fsck.ext4 -c /dev/vdb1

# 4. Informationen zur Dateisystem
sudo tune2fs -l /dev/vdb1 | head -20
```

**Hinweis**: Diese Befehle ändern nichts! `-n` bedeutet "read-only".

## Key Takeaways

✓ `fsck` — ext4-Dateisysteme prüfen & reparieren  
✓ `xfs_repair` — XFS-Dateisysteme reparieren  
✓ Journaling ermöglicht schnelle Wiederherstellung  
✓ fsck nur auf **unmounteten** Dateisystemen  
✓ `-n` prüft nur, `-y` repariert automatisch  
✓ Verlorene Dateien landen in `lost+found/`  

Glückwunsch! Du hast alle Filesystem-Grundlagen gelernt! 🎉

Klicke **Check** um fortzufahren!
