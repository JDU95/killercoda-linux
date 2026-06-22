# Step 2: Creating Volume Groups

## Aufgabe

Erstelle eine Volume Group (VG) aus Physical Volumes. Du musst:
- Das `vgcreate`-Kommando ausführen um eine neue VG zu erstellen
- Das `vgdisplay` oder `vgs` Kommando ausführen um die VG anzuzeigen
- Optional: Eine zweite PV zur VG hinzufügen mit `vgextend`

Diese Befehle sollten in deiner Bash-History sichtbar sein für die Verifikation.

---

## Volume Group erstellen

Eine **Volume Group** kombiniert mehrere Physical Volumes zu einem Speicher-Pool.

### Syntax

```bash
# VG erstellen (Name: myvg, PV: /dev/vdb1)
sudo vgcreate myvg /dev/vdb1

# VG mit mehreren PVs
sudo vgcreate bigvg /dev/vdb1 /dev/vdc1
```

### Beispiel

```bash
# VG mit 500 MB PV
sudo vgcreate testvg /dev/vdb1

# Größe der VG sollte ungefähr der PV entsprechen
# (etwas weniger, da Metadaten Platz brauchen)
```

---

## VGs erkunden: vgdisplay & vgs

### vgdisplay — detaillierte Informationen

```bash
# Alle VGs anzeigen
sudo vgdisplay

# Nur eine VG
sudo vgdisplay myvg

# Beispielausgabe:
# --- Volume group ---
# VG Name               myvg
# System ID
# Format                lvm2
# Metadata Areas        1
# Metadata Sequence No  2
# VG Access             read/write
# VG Status             resizable
# MAX LV                0
# Cur LV                0
# Open LV               0
# Max PV                0
# Cur PV                1          ← Eine PV in dieser VG
# Act PV                1
# VG Size               500 MiB    ← Gesamtgröße
# PE Size               4 MiB      ← Allocation Unit
# Total PE              125
# Alloc PE / Size       0 / 0
# Free PE / Size        125 / 500 MiB   ← Freier Speicher für LVs
```

### pvs — kompakte Ausgabe

```bash
# Alle VGs anzeigen (kompakt)
sudo vgs

# Beispielausgabe:
# VG    #PV #LV #SN Attr   VSize   VFree
# myvg    1   0   0 wz--n- 500.00m 500.00m
```

---

## PV zu VG hinzufügen: vgextend

Eine bestehende VG kann durch Hinzufügen neuer PVs vergrößert werden.

```bash
# Zweite PV erstellen (auf /dev/vdc)
sudo parted /dev/vdc mkpart primary 0 500
sudo parted /dev/vdc set 1 lvm on
sudo pvcreate /dev/vdc1

# PV zur VG hinzufügen
sudo vgextend myvg /dev/vdc1

# Größe sollte jetzt verdoppelt sein
sudo vgdisplay myvg
```

---

## VG-Verwaltung: weitere Befehle

### vgreduce — PV entfernen

```bash
# PV von VG entfernen (Daten müssen migriert sein!)
sudo vgreduce myvg /dev/vdc1

# Hinweis: Funktioniert nur wenn LVs auf dieser PV nicht sind
```

### vgrename — VG umbenennen

```bash
# VG umbenennen
sudo vgrename oldname newname
```

### vgremove — VG löschen

```bash
# VG löschen (muss leer sein!)
sudo vgremove myvg
```

---

## Übung: Volume Group erstellen

Führe diese Befehle aus (Achtung: PV muss vorher mit pvcreate erstellt sein!):

```bash
# 1. VG erstellen (aus /dev/vdb1)
sudo vgcreate myvg /dev/vdb1

# 2. VG detailliert anzeigen
sudo vgdisplay myvg

# 3. VG kompakt anzeigen
sudo vgs

# 4. Zweite PV vorbereiten (optional)
sudo parted /dev/vdc mkpart primary 0 500
sudo parted /dev/vdc set 1 lvm on
sudo pvcreate /dev/vdc1

# 5. Zweite PV zur VG hinzufügen (optional)
sudo vgextend myvg /dev/vdc1

# 6. Größe überprüfen
sudo vgdisplay myvg | grep "VG Size"
```

Nach dieser Übung solltest du eine VG mit einer oder zwei PVs haben!

## Key Takeaways

✓ `vgcreate name pv1 [pv2 ...]` — VG erstellen  
✓ `vgdisplay` — detaillierte VG-Informationen  
✓ `vgs` — kompakte VG-Ausgabe  
✓ `vgextend vg pv` — PV zu VG hinzufügen  
✓ PE-Größe ist meist 4 MB  
✓ VG hat freien Speicher für LVs  

Klicke **Check** um fortzufahren!
