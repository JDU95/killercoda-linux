# Logical Volume Manager — Abgeschlossen! ✓

Gratuliere! Du beherrschst jetzt Logical Volume Management!

## Gelernte Konzepte

### LVM-Glossar

| Begriff | Bedeutung |
|---------|-----------|
| **PV** (Physical Volume) | Partition oder ganze Disk als LVM-Basis |
| **VG** (Volume Group) | Speicher-Pool aus mehreren PVs |
| **LV** (Logical Volume) | Virtuelle Partition, Block-Device in VG |
| **PE** (Physical Extent) | Allocable Unit auf PV (meist 4 MB) |
| **LE** (Logical Extent) | Allocable Unit auf LV |

### LVM-Schema

```
Disks          → PVs         → VG       → LVs         → Filesystems
/dev/vdb1      → PV1         │          ├─ LV1 (100G) → /dev/mapper/vg1-lv1
/dev/vdc1      → PV2    →   VG1        ├─ LV2 (50G)  → /dev/mapper/vg1-lv2
               
               Mehrere PVs kombiniert zu einer VG
               VG wird in mehrere LVs unterteilt
               Jede LV hat ein eigenes Dateisystem
```

## Wichtige Befehle

| Kommando | Zweck |
|----------|-------|
| **Physical Volumes** | |
| `sudo pvcreate /dev/xxx` | Partition als PV initialisieren |
| `sudo pvdisplay` | Alle PVs anzeigen |
| `sudo pvremove /dev/xxx` | PV löschen |
| **Volume Groups** | |
| `sudo vgcreate vg1 /dev/pv1` | VG erstellen |
| `sudo vgextend vg1 /dev/pv2` | PV zu VG hinzufügen |
| `sudo vgdisplay` | Alle VGs anzeigen |
| `sudo vgreduce vg1 /dev/pv2` | PV von VG entfernen |
| **Logical Volumes** | |
| `sudo lvcreate -L 100G -n lv1 vg1` | LV erstellen (100 GB) |
| `sudo lvextend -L +50G /dev/vg1/lv1` | LV vergrößern (+50 GB) |
| `sudo lvreduce -L 30G /dev/vg1/lv1` | LV verkleinern (auf 30 GB) |
| `sudo lvremove /dev/vg1/lv1` | LV löschen |
| `sudo lvdisplay` | Alle LVs anzeigen |

## Typische Workflows

### 1. Neue LV erstellen

```bash
# 1. Partitionen (parted)
sudo parted /dev/vdb mkpart primary 0 500M
sudo parted /dev/vdb set 1 lvm on

# 2. Physical Volume
sudo pvcreate /dev/vdb1

# 3. Volume Group
sudo vgcreate myvg /dev/vdb1

# 4. Logical Volume
sudo lvcreate -L 400M -n mylv myvg

# 5. Dateisystem
sudo mkfs.ext4 /dev/myvg/mylv

# 6. Mount
sudo mkdir -p /mnt/mydata
sudo mount /dev/myvg/mylv /mnt/mydata
```

### 2. Mehrere Disks kombinieren

```bash
# Zwei PVs erstellen
sudo pvcreate /dev/vdb1 /dev/vdc1

# VG aus beiden PVs
sudo vgcreate bigvg /dev/vdb1 /dev/vdc1

# LV die über beide Disks geht
sudo lvcreate -L 800M -n biglv bigvg

# Größe prüfen
sudo lvdisplay /dev/bigvg/biglv
```

### 3. LV online vergrößern

```bash
# LV vergrößern
sudo lvextend -L +100G /dev/myvg/mylv

# Dateisystem vergrößern (ext4)
sudo resize2fs /dev/myvg/mylv

# (oder xfs_growfs für XFS)
sudo xfs_growfs /mnt/mydata

# Größe prüfen
df -h /mnt/mydata
```

### 4. PV zu VG hinzufügen

```bash
# Neue Partition & PV
sudo parted /dev/vdc mkpart primary 0 500M
sudo pvcreate /dev/vdc1

# Zu VG hinzufügen
sudo vgextend myvg /dev/vdc1

# Jetzt können LVs vergrößert werden (zusätzlicher Speicher)
```

## Nächste Schritte

Bereit für **RAID & Hochverfügbarkeit**? Mit LVM kannst du auch RAID-Devices als PVs verwenden!

**Weitere Ressourcen**:
- `man lvm` — LVM-Kommando Dokumentation
- `man pvcreate` / `man vgcreate` / `man lvcreate` — Detailierte Hilfe
- `/dev/mapper/` — Wo die LVs als Device-Dateien sichtbar sind

Viel Erfolg! 🚀
