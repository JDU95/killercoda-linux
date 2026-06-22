# Logical Volume Manager (LVM)

Willkommen zu Logical Volume Manager — der professionellen Speicherverwaltung für Linux!

## Themenübersicht

- **Traditionale Speicherverwaltung vs LVM** — Unterschiede und Vorteile
- **LVM-Glossar** — PV, VG, LV verstehen
- **Physical Volumes** — Partitionen als Basis vorbereiten
- **Volume Groups** — Speicher-Pool aus mehreren PVs
- **Logical Volumes** — Virtuelle Partitionen mit Dateisystemen
- **Erweiterung & Verwaltung** — dynamisches Wachstum

## Was ist LVM?

**LVM** = Logical Volume Manager — eine Abstraktionsschicht zwischen physischen Disks und Dateisystemen.

### Traditionale Speicherverwaltung

```
Disk 1          Disk 2
├─ Partition 1  ├─ Partition 3
│  └─ ext4      │  └─ xfs
└─ Partition 2  └─ Partition 4
   └─ xfs          └─ ext4

Problem: Partitionen sind starr!
- Können nicht vergrößert werden (ohne Neustart)
- Können nicht über mehrere Disks gehen
- Schwierig zu verwalten
```

### Mit LVM

```
Disk 1          Disk 2
├─ PV1          └─ PV2
└─ into VG1 ─────────┘
   └─ LV1 (100 GB)
      └─ ext4
   └─ LV2 (50 GB)
      └─ xfs

Vorteile: Flexible & dynamisch!
- LVs können online vergrößert werden
- LVs können über mehrere Disks gehen
- Snapshots für Backups möglich
- Professionelle Speicherverwaltung
```

## Was du lernen wirst

✓ Unterschied zwischen traditionaler Partitionierung und LVM  
✓ Physical Volumes (PV) aus Partitionen erstellen  
✓ Volume Groups (VG) zum Speichern-Pool kombinieren  
✓ Logical Volumes (LV) als virtuelle Partitionen  
✓ LVs online vergrößern und verkleinern  
✓ Mehrere Disks zu einer LV kombinieren  

## Voraussetzungen

- Filesystem Administration (Scenario 03)
- Verständnis von Partitionierung (parted, MBR/GPT)
- Linux-Grundkenntnisse

## Vorsicht ⚠️

LVM ist mächtig, aber auch komplex. In diesem Szenario:
- Wir verwenden `/dev/vdb` und `/dev/vdc` für Übungen
- **Nicht die Root-LV ändern!** (könnte Boot-Fehler verursachen)
- LVM-Befehle benötigen `sudo`

Los geht's — klicke auf **Start**!
