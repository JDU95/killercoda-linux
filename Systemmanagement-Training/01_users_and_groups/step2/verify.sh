#!/bin/bash
# Step 2 Verification: Benutzer hat die 4 Konfigurationsdateien mit cat angezeigt
# und head auf /etc/shadow ausgeführt

# Alle 4 Dateien mit cat anzeigen – entweder als ein Befehl oder als 4 einzelne Befehle
check_cat_combined() {
    grep -qF "cat /etc/passwd /etc/shadow /etc/group /etc/gshadow" ~/.bash_history
}

check_cat_separate() {
    grep -qE "^cat /etc/passwd"  ~/.bash_history &&
    grep -qE "^cat /etc/shadow"  ~/.bash_history &&
    grep -qE "^cat /etc/group"   ~/.bash_history &&
    grep -qE "^cat /etc/gshadow" ~/.bash_history
}

check_cat_combined || check_cat_separate || exit 1

# head -15 /etc/shadow muss ausgeführt worden sein (Passwort-Datei)
grep -qE "^head.*/etc/shadow" ~/.bash_history || exit 1

exit 0
