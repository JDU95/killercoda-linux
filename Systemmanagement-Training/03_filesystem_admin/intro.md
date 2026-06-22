# Filesystem Administration

Willkommen zur Verwaltung von Linux-Dateisystemen! In diesem Szenario lernst du, wie Linux Speicher organisiert, Dateisysteme verwaltet und von Fehlern wiederherstellt.

## Themenübersicht

- **Dateisysteme** — ext4, xfs, btrfs; Journaling; Fehlertoleranz
- **Mounting** — /etc/fstab, mount/umount, automatische Einbindung
- **Partitionierung** — MBR vs GPT, parted, Geräte (/dev/sdaN, /dev/vdaN)
- **Dateisystemverwaltung** — mkfs, Vergrößerung (resize2fs), Eigenschaften (tune2fs)
- **Reparatur** — fsck, xfs_repair, Fehlertoleranz

## Was du lernen wirst

✓ Unterschied zwischen Dateisystem und Block-Device
✓ Filesysteme mounten und automatisch einbinden (/etc/fstab)
✓ Partitionen mit GPT und MBR erstellen
✓ Neue Dateisysteme formatieren (mkfs.ext4, mkfs.xfs)
✓ Dateisysteme vergrößern und reparieren

## Voraussetzungen

- Linux-Grundkenntnisse (Navigation, Permissions)
- Verständnis von Benutzern und Gruppen (Scenario 01)
- Terminal/Bash-Erfahrung

## Vorsicht ⚠️

In diesem Szenario wirst du mit Block-Devices arbeiten. **Nicht die /root- oder /boot-Partitionen ändern!** Wir verwenden virtuelle Dateisysteme in /dev/vdb.

Los geht's — klicke auf **Start**!
