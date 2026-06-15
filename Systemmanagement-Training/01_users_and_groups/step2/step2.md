# Step 2: System- und Konfigurationsdateien für User und Gruppen

## Die vier zentralen Dateien

Linux verwaltet Benutzer- und Gruppeninformationen in vier Konfigurationsdateien:

| Datei | Inhalt |
|-------|--------|
| `/etc/passwd` | Benutzerdaten außer dem Passwort |
| `/etc/shadow` | Passwort als Hash-Code sowie Aging-Daten |
| `/etc/group` | Gruppendaten |
| `/etc/gshadow` | Gruppenpasswörter als Hash-Code (unüblich!) |

---

### 1. /etc/passwd – Benutzerdaten außer Passwort

Diese Datei enthält grundlegende Benutzerinformationen außer dem Passwort. Jede Zeile stellt einen User/Account dar und besteht aus **7 Feldern**, die durch Doppelpunkte getrennt sind:

```
username:x:UID:GID:comment:home-directory:login-shell
```

**Beispiel:**
```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
john:x:1000:1000:John Doe:/home/john:/bin/bash
```

**Feldbeschreibung:**
1. **username** – Login-Name
2. **x** – Passwort-Hash (wird jetzt in `/etc/shadow` gespeichert)
3. **UID** – User ID (0 = root)
4. **GID** – Primary Group ID
5. **comment** – Vollständiger Name/Beschreibung
6. **home-directory** – Pfad zum Home-Verzeichnis
7. **login-shell** – Shell beim Login

**Berechtigungen:** Alle Benutzer dürfen `/etc/passwd` **lesen**, aber nur root darf die Datei **verändern**.

---

### 2. /etc/shadow – Passwort und Aging-Daten

Enthält verschlüsselte Passwörter (Hash-Codes) und Passwort-Aging-Informationen.
**Nur root kann diese Datei lesen und verändern!**

Jede Zeile hat 9 Felder:
```
username:pwd-hash:changed:minlife:maxlife:warn:inactive:expires:unused
```

**Aging-Daten (Erläuterung):**
- **changed** – Datum der letzten Passwort-Änderung (Tage seit dem 01.01.1970)
- **minlife** – Minimale Tage bevor das Passwort geändert werden darf (0 = kein Limit)
- **maxlife** – Maximale Tage bis das Passwort geändert werden muss (9999 ≈ unbegrenzt)
- **warn** – Tage vor Ablauf des Passworts, an denen gewarnt wird (leer = keine Warnung)
- **inactive** – Tage nach Passwortablauf bis der Account deaktiviert wird (leer = kein Limit)
- **expires** – Datum, an dem der Account auf jeden Fall deaktiviert wird (leer = kein Limit)

---

### 3. /etc/group – Gruppeninformationen

Enthält Gruppendaten. Jede Zeile hat **4 Felder**:

```
groupname:x:GID:additional-users
```

**Beispiel:**
```
root:x:0:
developers:x:1001:john,sarah,mike
accounting:x:1002:alice,bob
```

Gruppen können auch implizit durch die Nennung der GID in `/etc/passwd` definiert werden (ohne eigenen Eintrag in `/etc/group`). Dies ist unüblich – die Gruppe hat dann keinen Namen.

**Feldbeschreibung:**
1. **groupname** - Gruppenname
2. **x** - Gruppenpasswort (selten verwendet)
3. **GID** - Gruppen-ID
4. **additional-users** - Sekundäre Gruppenmitglieder (kommagetrennt)

---

### 4. /etc/gshadow – Gruppenpasswörter (unüblich)

Enthält verschlüsselte Gruppenpasswörter. Ähnliche Struktur wie `/etc/shadow`, aber für Gruppen. In der Praxis kaum verwendet.

---

## Zugriffsrechte auf die Konfigurationsdateien

Es ist **sicherheitskritisch**, dass niemand außer root Schreibrechte auf diese Dateien hat!

```bash
# Berechtigungen der Konfigurationsdateien anzeigen
ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow
```

**Erwartete Ausgabe:**
```
-rw-r--r-- 1 root root   /etc/group
-rw-r----- 1 root shadow /etc/gshadow
-rw-r--r-- 1 root root   /etc/passwd
-rw-r----- 1 root shadow /etc/shadow
```

- `/etc/passwd` und `/etc/group`: lesbar für alle (`-rw-r--r--`)
- `/etc/shadow` und `/etc/gshadow`: nur root und Gruppe `shadow` (`-rw-r-----`)

## Musterdateien für Benutzerinitialisierung (/etc/skel)

Das Verzeichnis `/etc/skel` enthält Musterkonfigurationsdateien. Beim Einrichten eines neuen Accounts werden sie automatisch in das Heimatverzeichnis kopiert:

```bash
ls -la /etc/skel/
```

Shell-abhängige Dateien z.B.:
- **bash**: `.profile`, `.bash_logout`, `.bashrc`
- **C Shell**: `.login`, `.logout`, `.cshrc`

## Dateien untersuchen

Untersuche die Konfigurationsdateien auf deinem System:

```bash
# /etc/passwd anzeigen (erste 15 Zeilen)
head -15 /etc/passwd
```

```bash
# /etc/group anzeigen (erste 15 Zeilen)
head -15 /etc/group
```

```bash
# Eigenen Eintrag in /etc/passwd finden
grep "^$(whoami):" /etc/passwd
```

```bash
# Eigene Gruppen in /etc/group finden
grep "$(whoami)" /etc/group
```

## Aufgabe

Speichere die Dateiberechtigungen der Konfigurationsdateien zur Überprüfung:

```bash
ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow > /tmp/step2_verification.txt
```

Überprüfe das Ergebnis:

```bash
cat /tmp/step2_verification.txt
```

## Key Takeaways

✓ `/etc/passwd` – Benutzer-Account-Infos (für alle lesbar)  
✓ `/etc/shadow` – Verschlüsselte Passwörter (nur root!)  
✓ `/etc/group` – Gruppendefinitionen und Mitglieder  
✓ `/etc/gshadow` – Gruppenpasswörter (selten verwendet)  
✓ Diese Dateien müssen sorgfältig geschützt werden – Schreibrechte nur für root!

Bereit, deinen ersten User zu erstellen? Weiter zum nächsten Schritt!
