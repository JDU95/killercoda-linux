#!/bin/bash
# Step 3 Verification: Übung 4 – Setgid für /projects/bank und /projects/train

# 1. Verzeichnisse müssen existieren
[ -d /projects/bank  ] || exit 1
[ -d /projects/train ] || exit 1

# 2. Setgid-Bit muss gesetzt sein → Oktalcode beginnt mit "2"
#    Akzeptiere 2770 oder 3770 (falls auch sticky gesetzt)
bank_perms=$(stat -c '%a' /projects/bank)
train_perms=$(stat -c '%a' /projects/train)

[[ "$bank_perms"  =~ ^2 ]] || exit 1
[[ "$train_perms" =~ ^2 ]] || exit 1

# 3. Gruppenbesitz muss korrekt sein
bank_group=$(stat -c '%G' /projects/bank)
train_group=$(stat -c '%G' /projects/train)
[ "$bank_group"  = "bank"  ] || exit 1
[ "$train_group" = "train" ] || exit 1

exit 0
