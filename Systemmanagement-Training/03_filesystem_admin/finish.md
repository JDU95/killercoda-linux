# Filesystem Administration — Abgeschlossen! ✓

Gratuliere! Du beherrschst jetzt die Linux-Dateisystemverwaltung.

## Gelernte Konzepte

### Dateisysteme
- ext4 (robust, Standard), xfs (große Dateisysteme), btrfs (COW, Snapshots)
- Journaling schützt Metadaten vor Beschädigungen

### Mounting & /etc/fstab
- `/etc/fstab` definiert automatisch einzubindende Dateisysteme
- `mount device mount-dir` — einbinden
- `umount device/mount-dir` — trennen
- `findmnt` — Mount-Punkte anzeigen

### Partitionierung
- **MBR**: max. 4 primäre Partitionen, max. 2 TByte
- **GPT**: bis zu 128 Partitionen, bis zu 8 Zettabyte
- Modern: GPT für neue Disks verwenden

### Dateisystemverwaltung
- `mkfs.ext4 device` — neues ext4-Dateisystem
- `resize2fs /dev/xxx` — ext4 vergrößern
- `xfs_growfs mount-point` — xfs vergrößern
- `tune2fs` — ext4-Eigenschaften ändern

### Reparatur
- `fsck` — ext4 prüfen & reparieren (offline)
- `xfs_repair` — xfs reparieren
- Journaling ermöglicht schnelle Wiederherstellung

## Wichtige Befehle

| Befehl | Zweck |
|--------|-------|
| `mount` / `umount` | Dateisystem ein-/ausbauen |
| `findmnt` | Mount-Punkte anzeigen |
| `lsblk` | Block-Devices auflisten |
| `blkid` | UUID von Dateisystemen |
| `df -h` / `du -h` | Speichernutzung |
| `parted /dev/disk` | Partitionierung |
| `mkfs.ext4 /dev/partition` | Dateisystem erstellen |
| `fsck -t ext4 /dev/partition` | Dateisystem prüfen |
| `tune2fs` | ext4-Eigenschaften |

## Häufige Szenarien

### Neue Partition hinzufügen
```bash
# 1. Partition erstellen
sudo parted /dev/vdb mkpart primary 0 100GB

# 2. Dateisystem formatieren
sudo mkfs.ext4 /dev/vdb1

# 3. Mount-Punkt erstellen
sudo mkdir -p /mnt/data

# 4. Mounten
sudo mount /dev/vdb1 /mnt/data

# 5. In /etc/fstab eintragen
echo '/dev/vdb1  /mnt/data  ext4  defaults  0  2' | sudo tee -a /etc/fstab
```

### Dateisystem reparieren
```bash
sudo fsck -y /dev/vdb1  # -y für automatische Reparatur
```

### Dateisystem vergrößern (online)
```bash
# 1. Partition vergrößern (parted)
# 2. Dateisystem vergrößern
sudo resize2fs /dev/vdb1
# (oder xfs_growfs für xfs)
```

## Nächste Schritte

Bereit für **Logical Volume Management (LVM)**? Das ist der nächste Schritt für professionelle Speicherverwaltung, die Dateisysteme über mehrere Disks verteilt.

**Weitere Ressourcen**:
- `man mount` — Mount-Kommando Dokumentation
- `man parted` — Partitionierung Dokumentation
- `man mkfs.ext4` — ext4 Formatierung

Viel Erfolg beim nächsten Szenario!
