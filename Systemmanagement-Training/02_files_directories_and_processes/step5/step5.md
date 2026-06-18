# Step 5: Prozesse, Signale und Dämonen

## Prozess-Attribute

Jeder Unix/Linux-Prozess hat eindeutige Attribute:

| Attribut | Bedeutung |
|----------|-----------|
| **PID** | Process ID – eindeutige Identifikation |
| **PPID** | Parent Process ID – welcher Prozess diesen gestartet hat |
| **Nice Number** | Scheduling-Priorität (-20 bis +19) |
| **TTY** | Terminal-Device des Prozesses |
| **RUID / EUID** | Real/Effective User ID – wer hat gestartet vs. mit welchen Rechten |
| **RGID / EGID** | Real/Effective Group ID (bei Setgid) |

Die EUID ist relevant bei Setuid-Programmen: `/usr/bin/passwd` hat RUID = aktueller User, EUID = root.

## Prozesse anzeigen

```bash
# Alle eigenen Prozesse:
ps

# Alle Prozesse aller Benutzer (BSD-Stil):
ps ax

# Alle Prozesse mit Benutzerinformation:
ps aux

# Prozesshierarchie (Paket psmisc):
pstree
pstree -p    # mit PIDs

# Interaktiv, geordnet nach CPU-Auslastung:
top
```

### ps-Ausgabe verstehen

```
USER  PID  %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root    1   0.0  0.1 167764  9388 ?        Ss   10:00   0:01 /sbin/init
joe  1234   0.0  0.0  21888  5120 pts/0    Ss   10:01   0:00 -bash
joe  1235   0.0  0.0  39084  3336 pts/0    R+   10:01   0:00 ps aux
```

## Signale an Prozesse senden

Signale sind numerische Nachrichten, die asynchron an Prozesse gesendet werden.

### Wichtige Signale

| Nr | Name | Bedeutung |
|----|------|-----------|
| 1 | SIGHUP | Konfiguration neu einlesen (Reload) |
| 2 | SIGINT | Interrupt (wie Strg+C) |
| 9 | SIGKILL | Sofort beenden – **kann nicht abgefangen werden** |
| 15 | SIGTERM | Höflich beenden (Standard von `kill`) |
| 19 | SIGSTOP | Prozess anhalten (Strg+Z) – `fg` / `bg` zum Fortsetzen |

```bash
# Signal an Prozess senden:
kill -15 1234      # SIGTERM an PID 1234
kill -9  1234      # SIGKILL an PID 1234
kill 1234          # Standard: SIGTERM

# An alle Prozesse mit einem Namen:
killall firefox

# An einen Shell-Job:
kill %1            # Job-Nummer 1
```

> **Regel:** Zuerst `kill -15` (höflich), dann wenn nötig `kill -9` (hart).

## Hintergrundprozesse (Jobs)

```bash
sleep 60 &         # Im Hintergrund starten
jobs               # Jobs anzeigen
fg %1              # Job 1 in den Vordergrund holen
bg %1              # Job 1 im Hintergrund fortsetzen
Strg+Z             # Aktuellen Prozess anhalten (SIGSTOP)
```

## Dämonen / Daemons

Dämonen sind Hintergrundprozesse ohne Terminal – meistens Server-Dienste. Sie werden durch das Init-System (**systemd**) gestartet und gestoppt.

| Dämon | Dienst |
|-------|--------|
| `sshd` | SSH-Server |
| `httpd` / `nginx` | Web-Server |
| `mysqld` | Datenbank-Server |
| `crond` | Cron-Jobs (Zeitgesteuerte Aufgaben) |
| `systemd` | Init-Prozess (PID 1) |

Dämonen haben als TTY meist `?` (kein Terminal).

---

## Aufgabe (Übung 12)

**Teil A: Prozesse auflisten und speichern**

```bash
# Alle Prozesse mit Benutzerinformation in Datei speichern:
ps aux > /tmp/step5_proc.txt

# Inhalt prüfen:
head -5 /tmp/step5_proc.txt
grep bash /tmp/step5_proc.txt
```

**Teil B: Prozesshierarchie analysieren**

```bash
# pstree mit PIDs installieren (falls nötig):
which pstree || apt-get install -y psmisc

# Prozessbaum mit PIDs speichern:
pstree -p > /tmp/step5_tree.txt

# Die aktuelle Shell finden:
echo "Meine Shell-PID: $$"
cat /tmp/step5_tree.txt | grep "$$"
```

**Teil C: Signale ausprobieren**

```bash
# Prozess im Hintergrund starten:
sleep 120 &
sleep_pid=$!
echo "Sleep PID: $sleep_pid"

# Mit SIGTERM beenden:
kill -15 $sleep_pid

# Prüfen ob der Prozess beendet wurde:
ps aux | grep "sleep 120" | grep -v grep
# Erwartet: keine Ausgabe mehr
```

**Teil D: Dämonen beobachten**

```bash
# Alle Daemons anzeigen (kein TTY = ?)
ps aux | awk '$7 == "?" {print $1, $2, $11}' | head -15

# systemd-Dienste anzeigen:
systemctl list-units --type=service --state=running 2>/dev/null | head -15
```

## Key Takeaways

✓ `ps aux` zeigt alle Prozesse mit Benutzer, PID, CPU/MEM, Status und Kommando  
✓ `pstree -p` zeigt die Prozesshierarchie mit PIDs  
✓ `kill -15 PID` (höflich) → `kill -9 PID` (hart, nicht abfangbar)  
✓ SIGKILL (9) kann NICHT abgefangen werden – Prozess endet sofort  
✓ Dämonen erkennt man an TTY = `?` in `ps aux`  
✓ `$$` gibt die PID der aktuellen Shell aus

Herzlichen Glückwunsch! Du hast alle Schritte abgeschlossen. Klicke auf **Finish**!
