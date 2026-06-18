#!/bin/bash
# Step 1 Verification: Übung 1 – Zugriffsrechte für test1 und joe-and-jack

# 1. Datei test1 muss existieren
[ -f /projects/bank/test1 ] || exit 1

# 2. Besitzer muss joe sein
owner=$(stat -c '%U' /projects/bank/test1)
[ "$owner" = "joe" ] || exit 1

# 3. Gruppe muss bank sein
group=$(stat -c '%G' /projects/bank/test1)
[ "$group" = "bank" ] || exit 1

# 4. Berechtigungen müssen 640 sein (rw-r-----)
perms=$(stat -c '%a' /projects/bank/test1)
[ "$perms" = "640" ] || exit 1

# 5. Verzeichnis joe-and-jack muss existieren
[ -d /projects/bank/joe-and-jack ] || exit 1

# 6. Berechtigungen von joe-and-jack müssen 770 sein (rwxrwx---)
dir_perms=$(stat -c '%a' /projects/bank/joe-and-jack)
[ "$dir_perms" = "770" ] || exit 1

exit 0
