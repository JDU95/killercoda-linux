# Step 2: Block Devices & Device Naming

## Aufgabe

Erkunde die Block-Devices und Speicherstruktur deines Systems. Du musst die folgenden Befehle ausführen:
- Zeige Block-Devices mit `lsblk` an
- Zeige UUID der Dateisysteme mit `blkid` an
- Zeige Speichernutzung mit `df -h` an
- Zeige Größe von Verzeichnissen mit `du -h` an

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## Block-Devices und Gerätedateien

Ein **Block-Device** ist eine physikalische oder logische Speichereinheit:
- Festplatte/SSD
- Partition
- RAID-Device
- Logical Volume (LVM)

### Device-Namensschema

Linux benennt Block-Devices nach folgendem Muster:

```
/dev/sdX{N}    oder    /dev/vdX{N}
```

- **sd** = SCSI/SATA-Festplatte (ältere Konvention)
- **vd** = Virtual Disk (KVM/QEMU/Hypervisor)
- **nvme** = NVMe SSD (moderne Konvention)
- **X** = Buchstabe der Disk (a, b, c, ...)
- **N** = Partitionsnummer (1, 2, 3, ...)

### Beispiele

| Device | Beschreibung |
|--------|-----------|
| `/dev/sda` | 1. SATA-Festplatte (ganze Disk) |
| `/dev/sda1` | 1. Partition auf 1. SATA-Festplatte |
| `/dev/sda2` | 2. Partition auf 1. SATA-Festplatte |
| `/dev/sdb` | 2. SATA-Festplatte |
| `/dev/nvme0n1` | 1. NVMe-SSD |
| `/dev/nvme0n1p1` | 1. Partition auf 1. NVMe-SSD |
| `/dev/vdb` | 2. Virtuelle Disk (Killercoda) |
| `/dev/vdb1` | 1. Partition auf 2. Virtueller Disk |

---

## lsblk — Block-Devices auflisten

```bash
# Alle Block-Devices anzeigen
lsblk

# Mit Größen in human-readable format
lsblk -h

# Mit Dateisystem-Typen
lsblk -f

# Beispielausgabe:
# NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
# sda      8:0    0  100G  0 disk
# ├─sda1   8:1    0  500M  0 part /boot
# ├─sda2   8:2    0   50G  0 part /
# └─sda3   8:3    0   49G  0 part /home
# vdb    251:0    0   10G  0 disk
```

**Spalten**:
- `NAME` — Gerätename
- `SIZE` — Größe
- `TYPE` — Typ (disk, part, lvm, etc.)
- `MOUNTPOINT` — Wo gemountet

---

## blkid — UUIDs und Dateisystemtypen

```bash
# UUID aller Dateisysteme anzeigen
blkid

# UUID eines spezifischen Geräts
blkid /dev/sda1

# Beispielausgabe:
# /dev/sda1: UUID="8d5c4a33-..." TYPE="ext4" PARTUUID="..."
# /dev/sda2: UUID="7c3a9b2f-..." TYPE="ext4" PARTUUID="..."
```

**UUID** = Universally Unique Identifier — eindeutige Kennung für Dateisysteme (zuverlässiger als `/dev/sdaX`, die sich ändern können).

In `/etc/fstab` können UUIDs verwendet werden:
```bash
UUID=8d5c4a33-...  /boot  ext4  defaults  0  2
```

---

## df -h — Speichernutzung (Dateisystem-Ebene)

```bash
# Speichernutzung aller gemounteten Dateisysteme
df -h

# Nur bestimmten Mount-Punkt
df -h /boot

# Beispielausgabe:
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1       500M  100M  400M  20% /boot
# /dev/sda2        50G   25G   25G  50% /
# /dev/sdb1        10G    1G    9G  10% /mnt/data
```

**Spalten**:
- `Size` — Gesamtgröße des Dateisystems
- `Used` — Belegter Speicher
- `Avail` — Verfügbar für Benutzer
- `Use%` — Prozentuale Auslastung
- `Mounted on` — Mount-Punkt

---

## du -h — Speichernutzung (Verzeichnis-Ebene)

```bash
# Größe eines Verzeichnisses
du -h /home

# Größe aller Unterverzeichnisse
du -h -d 1 /

# Top 10 größte Verzeichnisse
du -h /home | sort -rh | head -10

# Beispielausgabe:
# 4.2G  /home/user1
# 1.8G  /home/user1/Downloads
# 950M  /home/user1/Pictures
# 500M  /home/user2
```

**Optionen**:
- `-h` — Human-readable (GB, MB statt Bytes)
- `-s` — Summary (nur Summe, keine Unterverzeichnisse)
- `-d N` — Depth (nur N Ebenen tief)

---

## Speichernutzung analysieren

### Wie viel Speicher hat die Root-Partition frei?

```bash
df -h /
```

Wenn `Avail` kleiner als 1 GB wird → Platzprobleme möglich!

### Welche Verzeichnisse belegen am meisten Speicher?

```bash
sudo du -h -d 2 / | sort -rh | head -10
```

Typische Platzverschwender:
- `/home` — Benutzer-Daten
- `/var/log` — Log-Dateien
- `/opt` — Große Anwendungen
- `/usr` — System-Software

---

## Übung: Speicherstruktur erkunden

Führe diese Befehle aus:

```bash
# Alle Block-Devices
lsblk

# UUIDs
blkid

# Speichernutzung (Dateisystem)
df -h

# Speichernutzung (Verzeichnisse)
du -h -d 1 /

# Größte Verzeichnisse
du -h / | sort -rh | head -10
```

Notiere: Wie viel Speicher hat dein Root-Dateisystem frei? Welches Verzeichnis belegt am meisten Platz?

## Key Takeaways

✓ Block-Devices: `/dev/sdX`, `/dev/vdX`, `/dev/nvmeXnYpZ`  
✓ `lsblk` — Devices und Partitionen anzeigen  
✓ `blkid` — UUIDs von Dateisystemen  
✓ `df -h` — Speicher nach Dateisystem  
✓ `du -h` — Speicher nach Verzeichnis  

Klicke **Check** um fortzufahren!
