#!/bin/bash
# Step 2 Verification: Benutzer hat die 4 Konfigurationsdateien mit cat angezeigt

HIST=/root/.bash_history

# Flush current session history to file before checking
history -a 2>/dev/null || true

# Alle 4 Dateien mit cat – entweder als ein kombinierter Befehl oder als 4 einzelne
check_cat_combined() {
    grep -qF "cat /etc/passwd /etc/shadow /etc/group /etc/gshadow" "$HIST"
}

check_cat_separate() {
    grep -qE "cat.*/etc/passwd"  "$HIST" &&
    grep -qE "cat.*/etc/shadow"  "$HIST" &&
    grep -qE "cat.*/etc/group"   "$HIST" &&
    grep -qE "cat.*/etc/gshadow" "$HIST"
}

check_cat_combined || check_cat_separate || exit 1

# head auf /etc/shadow muss ausgeführt worden sein (Datei mit Passwort-Infos)
grep -qE "head.*/etc/shadow" "$HIST" || exit 1

exit 0
