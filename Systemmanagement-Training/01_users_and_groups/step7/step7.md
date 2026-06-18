# Step 7: Übung 3 – sudo und administrativer Zugriff

## Das Problem mit dem gemeinsamen root-Passwort

Zur Administration eines wichtigen Servers sind oft mehrere Admins notwendig.
Wenn alle das root-Passwort kennen, ist das **unsicher und inflexibel**:
- Kein Audit-Trail (wer hat was gemacht?)
- Ein verlorenes Passwort → Notfallwiederherstellung nötig
- Ein kompromittiertes Passwort → vollständiger Systemzugriff

## Die Lösung: sudo

Mit **sudo** (substitute user do) können bestimmte Benutzer administrative Kommandos ausführen – **ohne das root-Passwort zu kennen**.

### Grundlegende Verwendung

```bash
# Einzelnes Kommando als root ausführen
sudo kommando

# Als anderer Benutzer ausführen
sudo -u benutzername kommando

# Root-Shell öffnen
sudo -s
# Zurück zum normalen User: exit oder Strg+D

# Root-Shell mit Login-Umgebung
sudo bash
```

### su – Benutzer wechseln

```bash
# Zu anderem Benutzer wechseln
su - benutzername

# Zu root wechseln (Passwort von root wird benötigt)
su - root

# Zurück zum vorherigen Benutzer
exit
```

## Die /etc/sudoers-Datei

Diese Datei steuert, wer sudo verwenden darf und welche Kommandos erlaubt sind.

> **WICHTIG:** Die Datei IMMER mit `visudo` bearbeiten – nie direkt mit einem Texteditor!  
> `visudo` prüft die Syntax und verhindert, dass man sich aussperrt.

```bash
sudo visudo
```

### Syntax der sudoers-Datei

```
user  host = (als_user) kommando
```

**Beispiele:**
```
# joe darf alle Kommandos als root ausführen
joe ALL=(ALL) ALL

# Alle Mitglieder der Gruppe bank dürfen sudo verwenden
%bank ALL=(ALL) ALL

# developers dürfen apache ohne Passwort neustarten
%developers ALL=(ALL) NOPASSWD: /usr/sbin/systemctl restart apache2

# operator darf nur reboot und shutdown
operator ALL=(ALL) /sbin/reboot, /sbin/shutdown
```

**Felder:**
- **User/Gruppe**: `benutzername` oder `%gruppenname`
- **Host**: `ALL` (auf jedem Host) oder Hostname
- **Als User**: `(ALL)` (als jeder) oder `(root)` oder `(user1,user2)`
- **Kommandos**: `ALL` (alles) oder vollständiger Pfad zu bestimmten Kommandos

### Empfohlene Methode: /etc/sudoers.d/

Statt die Hauptdatei zu bearbeiten, eigene Dateien in `/etc/sudoers.d/` anlegen:

```bash
# Regel für joe anlegen
echo "joe ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/joe

# Regel für bank-Gruppe anlegen
echo "%bank ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/bank_admins

# Syntax prüfen
sudo visudo -c
```

## Ubuntu/macOS vs. RHEL

| System | Verhalten |
|--------|-----------|
| macOS, Ubuntu | sudo vorkonfiguriert; root hat kein Passwort |
| RHEL, CentOS | Benutzer der `wheel`-Gruppe dürfen sudo verwenden |

## Sudo-Berechtigungen prüfen

```bash
# Eigene sudo-Berechtigungen anzeigen
sudo -l

# Berechtigungen eines anderen Users anzeigen
sudo -l -U joe
```

## Sudo-Protokoll

Sudo-Aktionen werden für Security-Audits protokolliert:

```bash
# Sudo-Log anzeigen
sudo grep sudo /var/log/auth.log | tail -10
```

## Aufgabe (Übung 3)

Richte administrative Rechte für die Projektteams aus Schritt 6 ein:

**Teil A: joe erhält administrative Rechte**

```bash
# Sudoers-Regel für joe anlegen
echo "joe ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/joe

# Inhalt prüfen
sudo cat /etc/sudoers.d/joe
```

**Teil B: Alle Mitglieder der bank-Gruppe werden Administratoren**

```bash
# Sudoers-Regel für die bank-Gruppe anlegen
echo "%bank ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/bank_admins

# Inhalt prüfen
sudo cat /etc/sudoers.d/bank_admins
```

**Teil C: Syntax prüfen**

```bash
sudo visudo -c
```

**Teil D: Überprüfen**

```bash
# Joes Berechtigungen anzeigen
sudo -l -U joe

# Alle sudoers.d-Regeln auflisten
sudo ls -la /etc/sudoers.d/
```

## Best Practices

✓ **Immer `visudo` verwenden** – nie `/etc/sudoers` direkt bearbeiten  
✓ **Gruppen statt Einzeluser** – einfacher zu verwalten  
✓ **Prinzip der geringsten Rechte** – nur notwendige Kommandos erlauben  
✓ **Spezifische Kommandos** – besser als `ALL` wenn möglich  
✓ **Logs überwachen** – regelmäßig sudo-Nutzung prüfen  
✓ **Sudoers einfach halten** – einfache Regeln sind leichter zu prüfen

## Key Takeaways

✓ `sudo` erlaubt Benutzern administrative Kommandos ohne root-Passwort  
✓ `/etc/sudoers.d/` ist der empfohlene Ort für eigene Regeln  
✓ `%gruppenname` gewährt allen Mitgliedern einer Gruppe sudo-Rechte  
✓ `visudo -c` prüft die Syntax der sudoers-Konfiguration  
✓ `sudo -l -U username` zeigt die Berechtigungen eines bestimmten Users

Herzlichen Glückwunsch! Du hast alle Übungen abgeschlossen. Klicke auf **Next** für die Zusammenfassung!
