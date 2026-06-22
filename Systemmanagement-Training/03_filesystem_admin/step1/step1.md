# Step 1: Filesystems & /etc/fstab

## Aufgabe

Erkunde die aktiven Dateisysteme deines Systems. Du musst die folgenden Befehle ausführen:
- Zeige alle aktiven Dateisysteme mit `mount` an
- Verwende `findmnt` um eine formatierte Liste zu sehen
- Verwende `lsblk` um Block-Devices anzuzeigen
- Lies `/etc/fstab` um zu verstehen, welche Dateisysteme automatisch eingebunden werden

Hinweis: Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## Dateisysteme in Linux

Ein **Dateisystem** ist eine Struktur, die Dateien und Verzeichnisse auf einem Block-Device (Festplatte, SSD, Partition) organisiert.

### Populäre Linux-Dateisysteme

| Dateisystem | Eigenschaften | Einsatz |
|-------------|--------------|---------|
| **ext4** | Robust, Journaling, zuverlässig | Standard bei vielen Distributionen |
| **xfs** | Sehr groß, Striping-Support | Red Hat, CentOS (>16 TByte) |
| **btrfs** | Copy-on-Write, Snapshots, Modern | SUSE, experimentell |
| **zfs** | Bestes Unix-FS, Lizenzprobleme | BSD, Solaris, Linux-Lizenzprobleme |

### Journaling

**Journaling** ist ein Mechanismus zur Vermeidung von Dateisystemschäden bei Stromausfällen oder Crashes.

- Änderungen an Metadaten werden zuerst in ein Log geschrieben
- Nach einem Crash kann das Dateisystem schnell wieder in einen gültigen Zustand gebracht werden
- Schützt nicht vor Datenverlust von gerade geschriebenen Dateien
- Alle modernen Linux-Dateisysteme verwenden Journaling

---

## Mount und /etc/fstab

### Mount-Kommando

Das `mount`-Kommando bindet ein Dateisystem in den Verzeichnisbaum ein:

```bash
# Alle aktiven Mounts anzeigen
mount

# Spezifisches Dateisystem mounten (Eintrag muss in /etc/fstab sein)
sudo mount /boot

# Dateisystem mit Gerätepfad mounten
sudo mount /dev/vdb1 /mnt/myfs
```

### findmnt und lsblk

```bash
# Mount-Punkte schöner formatiert
findmnt

# Block-Devices und Partitionen auflisten
lsblk

# Block-Device mit UUID anzeigen
blkid /dev/vdb1
```

### /etc/fstab — Automatische Mounts

Die Datei `/etc/fstab` definiert, welche Dateisysteme beim Bootvorgang automatisch eingebunden werden.

**Format:**
```
device           mount-dir  fs-type  options    dump  fsck
/dev/sda1        /boot      ext4     defaults   0     2
UUID=1234...     /          ext4     defaults   0     1
LABEL=backup     /mnt/bak   xfs      defaults   0     2
```

**Spalten:**
1. **device**: `/dev/xxx`, `UUID=...`, oder `LABEL=...`
2. **mount-dir**: Wo einbinden (z.B. `/boot`, `/mnt/data`)
3. **fs-type**: `ext4`, `xfs`, `swap`, `auto` (auto-detect)
4. **options**: `defaults`, oder `rw`, `ro`, `noauto`, `noexec`, etc.
5. **dump**: 1 für Systempartition, 0 für andere (wird ignoriert)
6. **fsck**: 0 = keine Prüfung, 1 = zuerst prüfen, 2 = später prüfen

### Wichtige mount-Optionen

| Option | Bedeutung |
|--------|-----------|
| `defaults` | Standard: rw,suid,dev,exec,auto,nouser,async |
| `ro` | Read-only |
| `rw` | Read-write |
| `noauto` | Nicht automatisch mounten |
| `noexec` | Programme können nicht ausgeführt werden |
| `nodev` | Device-Files werden ignoriert |
| `nosuid` | Setuid-Bit wird ignoriert |
| `users` | Normale Benutzer dürfen mounten |

### Vorsicht: /etc/fstab-Fehler

Ein Fehler in `/etc/fstab` kann den Boot-Vorgang blockieren! Deshalb:
- Immer vorher mit `mount` und `umount` testen
- `sudo mount -a` — testet alle Einträge

---

## Verzeichnisbaum und Dateisysteme

Linux hat einen **root-Dateisystem** (`/`), der beim Boot zuerst gemountet wird (read-only, dann read-write gemäß `/etc/fstab`).

Später können weitere Dateisysteme an beliebigen Orten (Mount-Punkte) eingefügt werden:

```
/                      ← Root-Dateisystem (sda1)
├── /boot              ← Kernel & Bootloader (sda2)
├── /home              ← Benutzer-Homeverzeichnisse (sdb1)
└── /mnt/backup        ← Externe Festplatte (sdc1)
```

Jedes Dateisystem ist unabhängig — kann z.B. separat repariert oder vergrößert werden.

---

## Übung: Dateisysteme erkunden

Führe folgende Befehle aus und beobachte die Ausgabe:

```bash
# Alle Mounts anzeigen
mount

# Mounted Filesystems schöner
findmnt

# Block-Devices
lsblk

# /etc/fstab lesen
cat /etc/fstab

# UUID von Dateisystemen
blkid
```

Notiere: Welche Dateisysteme sind gemountet? Welche zusätzlichen Optionen sind in `/etc/fstab` für dein Root-FS definiert?

## Key Takeaways

✓ Dateisysteme organisieren Daten auf Block-Devices  
✓ Journaling schützt vor Dateisystemschäden  
✓ `/etc/fstab` definiert automatisch einzubindende Dateisysteme  
✓ `mount` / `umount` — manuelle Einbindung  
✓ `findmnt` und `lsblk` zeigen aktive Mounts an  

Klicke **Check** um fortzufahren!
