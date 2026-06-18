#!/bin/bash
# Step 4 Verification: Übung 9 (myzero), Übung 10 (softlink), Übung 11 (hardlink)

# 1. /tmp/myzero muss existieren und genau 10 MiB (10485760 Bytes) groß sein
[ -f /tmp/myzero ] || exit 1
size=$(stat -c '%s' /tmp/myzero)
[ "$size" -eq 10485760 ] || exit 1

# 2. /root/tmp muss ein Soft Link sein, der auf /tmp zeigt
[ -L /root/tmp ] || exit 1
target=$(readlink /root/tmp)
[ "$target" = "/tmp" ] || exit 1

# 3. /root/telefonnr.txt muss existieren und Link-Count >= 2 haben
[ -f /root/telefonnr.txt ] || exit 1
linkcount=$(stat -c '%h' /root/telefonnr.txt)
[ "$linkcount" -ge 2 ] || exit 1

exit 0
