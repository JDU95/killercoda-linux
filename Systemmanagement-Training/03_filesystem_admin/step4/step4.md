# Step 4: Creating Filesystems

## Aufgabe

Erstelle ein neues Dateisystem auf einer Partition. Du musst:
- Das `mkfs`-Kommando (oder `mkfs.ext4` / `mkfs.xfs`) ausführen
- Mindestens ein neues Dateisystem auf `/dev/vdb1` oder einer anderen Partition formatieren
- Optional: Mounten des neuen Dateisystems und Hinzufügen zu `/etc/fstab`

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## mkfs — Dateisystem erstellen

**mkfs** steht für "make filesystem" und formatiert eine Partition mit einem neuen Dateisystem.

```bash
# ext4-Dateisystem erstellen
sudo mkfs.ext4 /dev/vdb1

# xfs-Dateisystem erstellen
sudo mkfs.xfs /dev/vdb1

# Dateisystemtyp automatisch erkennen (meist ext4)
sudo mkfs /dev/vdb1
```

### mkfs.ext4 — Häufige Optionen

```bash
# Grundlegende Verwendung
sudo mkfs.ext4 /dev/vdb1

# Mit Bezeichnung/Label
sudo mkfs.ext4 -L "mydata" /dev/vdb1

# Mit Blockgröße
sudo mkfs.ext4 -b 4096 /dev/vdb1

# Nach defekten Blöcken suchen (sehr langsam!)
sudo mkfs.ext4 -c /dev/vdb1
```

**Wichtige Optionen**:
- `-L label` — Beschriftung für Dateisystem
- `-b blocksize` — Block-Größe (1024, 2048, 4096)
- `-c` — Prüfe auf defekte Blöcke
- `-m percentage` — Prozent für root reservieren (Default 5%)

### mkfs.xfs — Häufige Optionen

```bash
# Grundlegende Verwendung
sudo mkfs.xfs /dev/vdb1

# Mit Label
sudo mkfs.xfs -L "mydata" /dev/vdb1

# Mit Blockgröße
sudo mkfs.xfs -b size=4096 /dev/vdb1
```

---

## Dateisystem mounten

Nach der Formatierung muss das Dateisystem gemountet werden, um darauf zuzugreifen.

```bash
# 1. Mount-Punkt erstellen
sudo mkdir -p /mnt/myfs

# 2. Dateisystem mounten
sudo mount /dev/vdb1 /mnt/myfs

# 3. Prüfen
df -h /mnt/myfs
ls /mnt/myfs

# 4. In /etc/fstab eintragen (optional)
echo '/dev/vdb1  /mnt/myfs  ext4  defaults  0  2' | sudo tee -a /etc/fstab

# 5. Mit mount -a prüfen
sudo mount -a
```

---

## Dateisystem vergrößern

Wenn eine Partition vergrößert wurde (z.B. mit parted), muss auch das Dateisystem vergrößert werden.

### ext4 — resize2fs

```bash
# Online-Vergrößerung (Dateisystem bleibt gemountet)
sudo resize2fs /dev/vdb1

# Mit Größenangabe (z.B. auf 100 GByte)
sudo resize2fs /dev/vdb1 100G
```

### xfs — xfs_growfs

```bash
# Nur möglich wenn gemountet!
sudo xfs_growfs /mnt/myfs

# Anzeige der aktuellen Größe
sudo xfs_info /dev/vdb1
```

---

## tune2fs — ext4-Eigenschaften

Nach der Erstellung können ext4-Eigenschaften mit `tune2fs` geändert werden.

```bash
# Label ändern
sudo tune2fs -L "newlabel" /dev/vdb1

# Label anzeigen
sudo tune2fs -l /dev/vdb1 | grep "Filesystem volume name"

# Automatische fsck bei N Mounts
sudo tune2fs -c 30 /dev/vdb1

# Automatische fsck nach N Tagen
sudo tune2fs -i 180 /dev/vdb1

# UUID ändern
sudo tune2fs -U random /dev/vdb1

# Prozent für root reservieren
sudo tune2fs -m 1 /dev/vdb1
```

---

## Übung: Dateisystem erstellen und mounten

Führe diese Befehle aus (Achtung: Partition muss vorher mit parted erstellt sein!):

```bash
# 1. Partition formatieren (ext4)
sudo mkfs.ext4 -L "mydata" /dev/vdb1

# 2. Mount-Punkt erstellen
sudo mkdir -p /mnt/mydata

# 3. Mounten
sudo mount /dev/vdb1 /mnt/mydata

# 4. Prüfen
df -h /mnt/mydata
ls -la /mnt/mydata

# 5. In /etc/fstab eintragen
sudo sh -c 'echo "/dev/vdb1  /mnt/mydata  ext4  defaults  0  2" >> /etc/fstab'

# 6. Mit mount -a testen
sudo mount -a

# 7. Label überprüfen
sudo tune2fs -l /dev/vdb1 | head -5
```

Nach dieser Übung solltest du `/mnt/mydata` als neues eingebundenes Dateisystem haben!

## Key Takeaways

✓ `mkfs.ext4` / `mkfs.xfs` — neues Dateisystem erstellen  
✓ `-L label` — Beschriftung vergeben  
✓ `mount` — Dateisystem einbinden  
✓ `/etc/fstab` — automatisches Mounten beim Boot  
✓ `resize2fs` (ext4) / `xfs_growfs` (xfs) — vergrößern  
✓ `tune2fs` — ext4-Eigenschaften  

Klicke **Check** um fortzufahren!
