#!/bin/bash
# Step 2 Verification: Übung 3 – umask dauerhaft für joe konfigurieren

# /home/joe/.bashrc muss eine umask-Zeile mit 0007 oder 007 enthalten
[ -f /home/joe/.bashrc ] || exit 1
grep -qE 'umask[[:space:]]+0?007' /home/joe/.bashrc || exit 1

exit 0
