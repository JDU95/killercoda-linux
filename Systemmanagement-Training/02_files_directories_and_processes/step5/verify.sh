#!/bin/bash
# Step 5 Verification: Übung 12 – Prozesse auflisten

# 1. ps-Ausgabe muss in /tmp/step5_proc.txt gespeichert sein
[ -f /tmp/step5_proc.txt ] || exit 1
[ -s /tmp/step5_proc.txt ] || exit 1

# 2. Datei muss bash-Prozesse enthalten (ps aux Ausgabe)
grep -qi "bash" /tmp/step5_proc.txt || exit 1

# 3. pstree-Ausgabe muss in /tmp/step5_tree.txt gespeichert sein
[ -f /tmp/step5_tree.txt ] || exit 1
[ -s /tmp/step5_tree.txt ] || exit 1

# 4. pstree-Datei muss bash enthalten
grep -qi "bash" /tmp/step5_tree.txt || exit 1

exit 0
