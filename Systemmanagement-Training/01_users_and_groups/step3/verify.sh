#!/bin/bash
# Step 3 Verification: Creating User klaas (Übung 1 – Teil 1)
# Check that klaas user was created with the correct settings

# 1. Check that group 'duck' exists
getent group duck >/dev/null 2>&1 || exit 1

# 2. Check that user 'klaas' exists
getent passwd klaas >/dev/null 2>&1 || exit 1

# 3. Check that klaas's primary group is 'duck'
duck_gid=$(getent group duck | cut -d: -f3)
klaas_gid=$(getent passwd klaas | cut -d: -f4)
[ "$duck_gid" = "$klaas_gid" ] || exit 1

# 4. Check that home directory is /home/klaas_klever
klaas_home=$(getent passwd klaas | cut -d: -f6)
[ "$klaas_home" = "/home/klaas_klever" ] || exit 1

# 5. Check that the home directory actually exists
[ -d "/home/klaas_klever" ] || exit 1

# 6. Check full name/comment contains 'Klaas' and 'Klever'
klaas_comment=$(getent passwd klaas | cut -d: -f5)
echo "$klaas_comment" | grep -qi "Klaas" || exit 1
echo "$klaas_comment" | grep -qi "Klever" || exit 1

exit 0
