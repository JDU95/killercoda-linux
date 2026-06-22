# Step 3: Logical Volumes & Mounting

## Aufgabe

Erstelle ein Logical Volume (LV) und binde es als Dateisystem ein. Du musst:
- Das `lvcreate`-Kommando ausführen um ein neues LV zu erstellen
- Mit `mkfs` ein Dateisystem auf der LV erstellen
- Mit `mount` die LV mounten
- Das `lvdisplay` oder `lvs` Kommando ausführen um die LV anzuzeigen

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## Logical Volumes erstellen: lvcreate

Ein **Logical Volume** ist wie eine virtuelle Partition, die aus dem Speicher einer VG geschnitten wird.

### Syntax

```bash
# LV mit Größe erstellen
sudo lvcreate -L 100G -n mylv myvg

# LV mit Größe in Prozent der VG
sudo lvcreate -l 50%VG -n mylv myvg

# LV mit exakter PE-Größe
sudo lvcreate -l 100 -n mylv myvg  # 100 PEs
```

### Parameter

| Parameter | Bedeutung |
|-----------|-----------|
| `-L size` | Größe (z.B. `100G`, `50M`) |
| `-l count` | Anzahl der Extents (Allocation Units) |
| `-n name` | LV-Name |
| `vg-name` | Name der Volume Group |

### Beispiele

```bash
# 100 GB LV auf myvg
sudo lvcreate -L 100G -n data myvg

# 50% der VG-Größe
sudo lvcreate -l 50%VG -n backup myvg

# 75% der VG-Größe
sudo lvcreate -l 75%VG -n archive myvg

# Mit Streifen (Striping) über mehrere PVs
sudo lvcreate -L 100G -i 2 -n striped myvg
```

---

## LVs erkunden: lvdisplay & lvs

### lvdisplay — detaillierte Informationen

```bash
# Alle LVs anzeigen
sudo lvdisplay

# Nur eine LV
sudo lvdisplay /dev/myvg/mylv

# Beispielausgabe:
# --- Logical volume ---
# LV Path                /dev/myvg/mylv
# LV Name                mylv
# VG Name                myvg
# LV UUID                uuid...
# LV Write Access        read/write
# LV Creation host, time ...
# LV Size                100 GiB
# Current LE             25600
# Segments               1
# Allocation             inherit
# Read ahead sectors     auto
```

### lvs — kompakte Ausgabe

```bash
# Alle LVs anzeigen (kompakt)
sudo lvs

# Beispielausgabe:
# LV    VG    Attr       LSize   Pool Origin Data%  Meta%
# mylv  myvg  -wi-a----- 100.00g
```

---

## Dateisystem auf LV erstellen

Nach Erstellung der LV muss ein Dateisystem darauf formatiert werden.

```bash
# ext4 auf LV
sudo mkfs.ext4 /dev/myvg/mylv

# Alternative: /dev/mapper/... Notation
sudo mkfs.ext4 /dev/mapper/myvg-mylv

# xfs auf LV
sudo mkfs.xfs /dev/myvg/mylv

# Mit Label
sudo mkfs.ext4 -L "mydata" /dev/myvg/mylv
```

---

## LV mounten

```bash
# 1. Mount-Punkt erstellen
sudo mkdir -p /mnt/mydata

# 2. Mounten
sudo mount /dev/myvg/mylv /mnt/mydata

# 3. Prüfen
df -h /mnt/mydata
ls -la /mnt/mydata

# 4. In /etc/fstab eintragen (optional)
echo '/dev/mapper/myvg-mylv  /mnt/mydata  ext4  defaults  0  2' | sudo tee -a /etc/fstab

# 5. Mit mount -a testen
sudo mount -a
```

---

## /dev/mapper — LV-Device-Dateien

LVs werden als Block-Devices in `/dev/mapper/` sichtbar:

```bash
# Alle LV-Devices anzeigen
ls -la /dev/mapper/

# Beispiel:
# /dev/mapper/myvg-mylv   ← LV mit Name mylv in VG myvg
# /dev/mapper/myvg-backup ← LV mit Name backup
```

Diese Dateien sind die Schnittstelle zu den tatsächlichen LVs.

---

## Übung: Logical Volume erstellen und mounten

Führe diese Befehle aus (Achtung: VG muss vorher mit vgcreate erstellt sein!):

```bash
# 1. LV erstellen (100 GB)
sudo lvcreate -L 100M -n mylv myvg

# 2. LV detailliert anzeigen
sudo lvdisplay

# 3. LV kompakt anzeigen
sudo lvs

# 4. Device-Datei prüfen
ls -la /dev/myvg/
ls -la /dev/mapper/ | grep myvg

# 5. Dateisystem erstellen
sudo mkfs.ext4 -L "mydata" /dev/myvg/mylv

# 6. Mount-Punkt erstellen
sudo mkdir -p /mnt/mydata

# 7. Mounten
sudo mount /dev/myvg/mylv /mnt/mydata

# 8. Größe prüfen
df -h /mnt/mydata

# 9. Optional: In /etc/fstab eintragen
sudo sh -c 'echo "/dev/mapper/myvg-mylv  /mnt/mydata  ext4  defaults  0  2" >> /etc/fstab'
```

Nach dieser Übung solltest du ein funktionierendes LV mit Dateisystem haben!

## Key Takeaways

✓ `lvcreate -L size -n name vg` — LV erstellen  
✓ `lvdisplay` — detaillierte LV-Informationen  
✓ `lvs` — kompakte LV-Ausgabe  
✓ LVs werden als `/dev/mapper/vg-lv` verfügbar  
✓ `mkfs` auf LV, dann `mount` wie normale Partitionen  
✓ In `/etc/fstab` mit `/dev/mapper/...` Notation  

Klicke **Check** um fortzufahren!
