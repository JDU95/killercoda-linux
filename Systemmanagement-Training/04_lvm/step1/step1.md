# Step 1: LVM Concepts & Physical Volumes

## Aufgabe

Verstehe das LVM-Konzept und erstelle deine erste Physical Volume (PV). Du musst:
- Das `pvcreate`-Kommando ausführen um eine Partition als PV zu initialisieren
- Das `pvdisplay` oder `pvs` Kommando ausführen um die PV anzuzeigen
- Verstehen wie LVM eine Abstraktionsschicht ist zwischen physischen Disks und Dateisystemen

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## Traditionale Speicherverwaltung vs LVM

### Problem der traditonalen Partitionierung

```
Festplatte
├─ Partition 1 (50 GB)      Filesystem: /dev/sda1 → /
│  └─ Problem: Volles Dateisystem, kann nicht vergrößert werden!
│
└─ Partition 2 (200 GB)
   └─ Viel freier Speicher, aber nicht mit Partition 1 vereinbar
```

**Ohne LVM**:
- Partitionsgröße ist starr (bei Erstellung definiert)
- Vergrößerung erfordert Neustart + Datenmigration
- Speicher über mehrere Disks ist kompliziert
- Keine flexible Verwaltung

### Lösung: Logical Volume Manager (LVM)

```
Disk 1              Disk 2
├─ PV1              └─ PV2
└────────────────────────┘
   Volume Group (VG)
   ├─ LV1 (50 GB)    ← Kann online vergrößert werden
   ├─ LV2 (80 GB)
   └─ LV3 (30 GB)
   
   Freier Speicher: 40 GB (zur dynamischen Erweiterung)
```

**Mit LVM**:
- Flexible Größen der logischen Volumes
- Online-Vergrößerung ohne Datenmigration
- Mehrere Disks zu einer LV kombinierbar
- Snapshots für Backups
- Professionelle Speicherverwaltung

---

## LVM-Glossar

### Physical Volume (PV)

Ein **Physical Volume** ist eine Partition oder ganze Disk, die als Basis für LVM dient.

- Wird mit `pvcreate` initialisiert
- Enthält LVM-Metadaten
- Mehrere PVs können zu einer VG kombiniert werden

```bash
# Partition mit LVM-Flag markieren (parted)
sudo parted /dev/vdb set 1 lvm on

# Als PV initialisieren
sudo pvcreate /dev/vdb1

# Ergebnis: /dev/vdb1 ist jetzt ein Physical Volume
```

### Volume Group (VG)

Eine **Volume Group** ist ein Speicher-Pool, der aus einem oder mehreren PVs besteht.

- Speichert mehrere Logical Volumes
- Wächst durch Hinzufügen von PVs
- Hat eine Extent-Größe (meist 4 MB)

```bash
# VG aus einer PV erstellen
sudo vgcreate myvg /dev/vdb1

# VG anzeigen
sudo vgdisplay myvg

# Zweite PV hinzufügen
sudo vgextend myvg /dev/vdc1
```

### Logical Volume (LV)

Ein **Logical Volume** ist eine virtuelle Partition, die auf einer VG basiert.

- Wird als Block-Device behandelt (`/dev/mapper/...`)
- Kann Dateisysteme enthalten
- Größe kann online verändert werden

```bash
# LV mit 100 GB erstellen
sudo lvcreate -L 100G -n mylv myvg

# Ergebnis: /dev/mapper/myvg-mylv ist die LV
```

### Allocation Units

- **PE** (Physical Extent): Allocable Unit auf PV (meist 4 MB)
- **LE** (Logical Extent): Allocable Unit auf LV (1 LE = mehrere PEs)

Beispiel:
- VG mit PE-Größe 4 MB
- LV mit 100 GB = 25.000 LEs
- Jede LE wird auf verschiedene PEs verteilt

---

## Praxis: Physical Volumes erstellen

### Schritt 1: Partition vorbereiten

```bash
# Mit parted Partition erstellen
sudo parted /dev/vdb
(parted) mkpart primary 0 500
(parted) set 1 lvm on  # ← LVM-Flag setzen!
(parted) print
(parted) quit

# Oder mit einem Befehl:
sudo parted -s /dev/vdb mkpart primary 0 500 set 1 lvm on
```

### Schritt 2: PV erstellen

```bash
# Physical Volume initialisieren
sudo pvcreate /dev/vdb1

# PVs anzeigen
sudo pvdisplay
sudo pvs  # ← kompakte Variante
```

### Schritt 3: Ergebnis verifikationieren

```bash
# PV-Info anzeigen
sudo pvdisplay /dev/vdb1
# Zeigt: UUID, Size, PE Size, etc.

# Kompakte Ausgabe
sudo pvs
# Zeigt: PV, VG, Fmt, Attr, PSize, PFree
```

---

## Übung: Erste PV erstellen

Führe diese Befehle aus:

```bash
# 1. Partition mit parted
sudo parted /dev/vdb mkpart primary 0 500
sudo parted /dev/vdb set 1 lvm on

# 2. PV erstellen
sudo pvcreate /dev/vdb1

# 3. PVs auflisten
sudo pvdisplay

# 4. Kompakte Ausgabe
sudo pvs

# 5. UUID/Details einer PV
sudo pvdisplay /dev/vdb1
```

Nach dieser Übung solltest du `/dev/vdb1` als Physical Volume sehen können!

## Key Takeaways

✓ **LVM** ist eine Abstraktionsschicht für flexible Speicherverwaltung  
✓ **PV** = Partition/Disk als LVM-Basis  
✓ **VG** = Speicher-Pool aus mehreren PVs  
✓ **LV** = Virtuelle Partition in VG  
✓ `pvcreate` — PV erstellen  
✓ `pvdisplay`/`pvs` — PVs anzeigen  

Klicke **Check** um fortzufahren!
