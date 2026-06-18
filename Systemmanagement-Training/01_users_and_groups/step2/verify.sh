#!/bin/bash
# Step 2 Verification: Benutzer hat die Konfigurationsdateien untersucht

# Prüfen ob ls -l auf die 4 Konfigurationsdateien ausgeführt wurde
grep -qF "ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow" ~/.bash_history || exit 1

# Prüfen ob head auf /etc/passwd ausgeführt wurde
grep -qE "^head.*/etc/passwd" ~/.bash_history || exit 1

exit 0
