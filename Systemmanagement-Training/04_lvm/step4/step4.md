# Step 4: Extending LVM

## Aufgabe

Lerne wie LVs dynamisch vergrößert werden. Du musst:
- Das `lvextend`-Kommando ausführen um ein LV zu vergrößern
- Das `resize2fs` (ext4) oder `xfs_growfs` (xfs) Kommando ausführen um das Dateisystem zu vergrößern
- Optional: Eine neue PV zur VG hinzufügen mit `vgextend`

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## LVs vergrößern: lvextend

**lvextend** vergrößert ein bestehendes Logical Volume um zusätzlichen Speicher.

### Syntax

```bash
# LV um Größe vergrößern
sudo lvextend -L +100G /dev/myvg/mylv

# LV auf exakte Größe setzen
sudo lvextend -L 200G /dev/myvg/mylv

# LV um Prozent der VG vergrößern
sudo lvextend -l +50%VG /dev/myvg/mylv
```

### Beispiele

```bash
# Um 50 GB vergrößern
sudo lvextend -L +50G /dev/myvg/mylv

# Auf 150 GB insgesamt setzen (nicht +)
sudo lvextend -L 150G /dev/myvg/mylv

# Um 100 PEs vergrößern
sudo lvextend -l +100 /dev/myvg/mylv
```

---

## Dateisystem vergrößern

Nach der LV-Vergrößerung muss auch das Dateisystem angepasst werden!

### ext4 — resize2fs

```bash
# Online (Dateisystem bleibt gemountet)
sudo resize2fs /dev/myvg/mylv

# Mit Größenangabe
sudo resize2fs /dev/myvg/mylv 150G

# Prüfen
df -h /mount-point
```

### xfs — xfs_growfs

```bash
# Nur möglich wenn gemountet!
sudo xfs_growfs /mount-point

# Prüfen
df -h /mount-point
```

---

## Szenario: Disk läuft voll

### Problem
```
Das Dateisystem /data hat nur noch 10 GB frei, aber noch 100 GB für
Backups vorhanden. Wie kann man vergrößern?
```

### Lösung

```bash
# 1. Aktuelle Größe prüfen
df -h /data
lvdisplay /dev/myvg/data

# 2. VG hat noch Speicher?
vgdisplay myvg | grep "Free"

# 3. LV um 50 GB vergrößern
sudo lvextend -L +50G /dev/myvg/data

# 4. Dateisystem vergrößern
sudo resize2fs /dev/myvg/data  # ext4
# oder
sudo xfs_growfs /data          # xfs

# 5. Neue Größe prüfen
df -h /data

# Ergebnis: /data ist jetzt 50 GB größer!
```

---

## Mehrere Disks kombinieren

Wenn die VG-Kapazität erschöpft ist, können neue Disks hinzugefügt werden.

### Szenario: VG vergrößern

```bash
# Aktuelle VG-Größe
sudo vgdisplay myvg | grep "VG Size"

# Neue Partition auf Disk 2
sudo parted /dev/vdc mkpart primary 0 500
sudo parted /dev/vdc set 1 lvm on

# PV erstellen
sudo pvcreate /dev/vdc1

# PV zur VG hinzufügen
sudo vgextend myvg /dev/vdc1

# Neue VG-Größe
sudo vgdisplay myvg | grep "VG Size"

# Jetzt können LVs weiter vergrößert werden
sudo lvextend -L +100G /dev/myvg/mylv
```

---

## LVs verkleinern: lvreduce

Auch Verkleinerung ist möglich (aber mit Vorsicht!):

```bash
# LV um 50 GB verkleinern
sudo lvreduce -L -50G /dev/myvg/mylv

# Dateisystem VORHER verkleinern!
sudo resize2fs /dev/myvg/mylv 100G  # zuerst FS
sudo lvreduce -L 100G /dev/myvg/mylv # dann LV

# Risiko: Datenverlust! Immer vorher backup!
```

---

## Übung: LV vergrößern

Führe diese Befehle aus (Achtung: LV muss vorher mit lvcreate erstellt sein!):

```bash
# 1. Aktuelle Größe anzeigen
sudo lvdisplay /dev/myvg/mylv
df -h /mnt/mydata

# 2. LV vergrößern um 50 MB
sudo lvextend -L +50M /dev/myvg/mylv

# 3. Neue LV-Größe anzeigen
sudo lvdisplay /dev/myvg/mylv

# 4. Dateisystem vergrößern (ext4)
sudo resize2fs /dev/myvg/mylv

# 5. Neue Dateisystem-Größe anzeigen
df -h /mnt/mydata

# Optional: VG vergrößern
# sudo pvcreate /dev/vdc1
# sudo vgextend myvg /dev/vdc1
# sudo lvextend -L +100G /dev/myvg/mylv
# sudo resize2fs /dev/myvg/mylv
```

Nach dieser Übung solltest du ein vergrößertes LV haben! Das ist die Kraft von LVM — online ohne Neustart! 🚀

## Key Takeaways

✓ `lvextend -L +size /dev/vg/lv` — LV vergrößern  
✓ `resize2fs` (ext4) / `xfs_growfs` (xfs) — Dateisystem anpassen  
✓ Online möglich — kein Neustart nötig!  
✓ `vgextend vg pv` — VG mit neuen Disks vergrößern  
✓ `lvreduce` — LV verkleinern (riskant!)  
✓ Das ist die Kraft von LVM!  

Glückwunsch! Du beherrschst jetzt Logical Volume Management! 🎉

Klicke **Check** um fortzufahren!
