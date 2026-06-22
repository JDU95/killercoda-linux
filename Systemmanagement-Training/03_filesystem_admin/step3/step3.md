# Step 3: Partitionierung — MBR vs GPT

## Aufgabe

Lerne die Partitionierungsformate MBR und GPT kennen und erstelle eine neue Partition. Du musst:
- Das `parted`-Kommando ausführen um die Partitionstabelle zu untersuchen
- Eine neue Partitionstabelle auf `/dev/vdb` erstellen (GPT oder MBR)
- Mindestens eine neue Partition hinzufügen

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## Partitionen

Eine **Partition** ist ein abgegrenzter Bereich einer Festplatte/SSD, der als unabhängiger Speicher behandelt wird.

Warum Partitionen?
- Mehrere Dateisysteme auf einer Disk
- Daten trennen (z.B. `/` und `/home`)
- Backup und Verwaltung erleichtern
- Verschiedene Dateisystemtypen nebeneinander

### MBR (Master Boot Record)

**Älteres Partitionsformat** (seit 1980er Jahren):

```
┌─ MBR (512 bytes) ──┐
├─ Boot Code        │  ← Bootloader
├─ Partition Table  │  ← max. 4 Einträge
└─ Signature        │  ← 0x55AA
```

**Limitierungen**:
- Maximal **4 primäre Partitionen**
- Maximal **eine erweiterte Partition** (kann logische Partitionen enthalten)
- Max. **15 logische Partitionen** in erweiterte Partition
- Max. Partitionsgröße: **2 TByte**
- Max. Diskgröße: **2 TByte**

**Partitionsnummern**:
- 1-4: Primär/Erweitert
- 5+: Logisch

**Kommandos**: `fdisk`, `parted`, `gparted`

### GPT (GUID Partition Table)

**Modernes Partitionsformat** (seit 2000er Jahre):

```
┌─ Protective MBR ──┐
├─ GPT Header       │  ← Header für Partitionstabelle
├─ Partition Array  │  ← bis zu 128 Partitionen
├─ Datenbereich     │
└─ GPT Trailer      │
```

**Vorteile**:
- **Bis zu 128 Partitionen** (Standard)
- Maximal **8 Zettabyte** Partitionsgröße (unrealistisch groß)
- **UEFI-Bootfähig** (bessere Sicherheit)
- **Redundanz**: Partition Table am Anfang und Ende der Disk
- **Checksummen** zur Fehlertoleranz

**Kommandos**: `parted`, `gparted` (nicht fdisk!)

### MBR vs GPT Vergleich

| Eigenschaft | MBR | GPT |
|------------|-----|-----|
| Maximale Partitionen | 4 primär, 15 logisch | 128 |
| Max. Partitionsgröße | 2 TByte | 8 Zettabyte |
| Max. Diskgröße | 2 TByte | 8 Zettabyte |
| Boot-Standard | BIOS | UEFI |
| Fehlertoleranz | Nein | Ja (Redundanz) |
| Modernes System | Nein | **Ja** |

**Faustregel**: GPT für neue Systeme, MBR nur für USB-Sticks/alte Hardware.

---

## parted — Partitionierungstool

```bash
# Partitionstabelle auf /dev/vdb anzeigen
sudo parted /dev/vdb print

# Interaktiver Modus starten
sudo parted /dev/vdb
```

### Wichtige parted-Befehle

```bash
# GPT-Partitionstabelle erstellen (LÖSCHT ALLE DATEN!)
(parted) mklabel gpt

# MBR-Partitionstabelle erstellen
(parted) mklabel msdos

# Einheit auf MiB setzen
(parted) unit mib

# Neue Partition erstellen (GPT)
(parted) mkpart primary 0 500

# Neue Partition (MBR)
(parted) mkpart primary 0 500

# Partitionstabelle anzeigen
(parted) print

# Partition 1 löschen
(parted) rm 1

# Beenden
(parted) quit
```

### Vorsicht: MBR ↔ GPT Konversion

**WARNUNG**: Wechsel zwischen MBR und GPT **zerstört alle Daten!**

Immer `mklabel gpt/msdos` nur auf bereits leeren Disks verwenden!

---

## Device-Namenskonvention

Auf diesem System:
- `/dev/vda` — erste virtuelle Disk (root-Dateisystem)
- `/dev/vdb` — zweite virtuelle Disk (für Übungen)
- `/dev/vdc` — dritte virtuelle Disk (optional)

---

## Übung: Partitionen mit parted erstellen

Führe diese Befehle aus:

```bash
# Aktuelle Partitionen anzeigen
sudo lsblk

# parted starten (interaktiv)
sudo parted /dev/vdb

# Im parted-Menü:
(parted) print                    # Aktuelle Partitionstabelle
(parted) mklabel gpt              # GPT erstellen (LÖSCHT ALLE DATEN!)
(parted) unit mib                 # Einheit = MiB
(parted) mkpart primary 0 500     # 500 MiB Partition
(parted) print                    # Anzeigen
(parted) quit                     # Beenden

# Partitionen mit lsblk prüfen
sudo lsblk /dev/vdb
```

Nach dieser Übung solltest du `/dev/vdb1` sehen können!

## Key Takeaways

✓ **MBR**: Alt, max. 4 primäre Partitionen, 2 TByte Limit  
✓ **GPT**: Modern, bis zu 128 Partitionen, praktisch unbegrenzt groß  
✓ Nutze **GPT für neue Systeme**, MBR nur für alte Hardware  
✓ `parted` — Partitionierung für beide Formate  
✓ **Vorsicht**: `mklabel gpt/msdos` zerstört Daten!  

Klicke **Check** um fortzufahren!
