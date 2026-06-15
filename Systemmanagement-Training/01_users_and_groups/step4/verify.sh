#!/bin/bash
# Step 4 Verification: Password and chage settings for klaas (Übung 1 – Teil 2)

# 1. Check user klaas exists (from step 3)
getent passwd klaas >/dev/null 2>&1 || exit 1

# 2. Check klaas has a real password set (not '!' or '*' which mean locked/no-password)
klaas_hash=$(getent shadow klaas 2>/dev/null | cut -d: -f2)
[ -z "$klaas_hash" ] && exit 1
[[ "$klaas_hash" == "!" || "$klaas_hash" == "*" || "$klaas_hash" == "!!" ]] && exit 1

# 3. Check 'last changed' field is 0 (forces password change on next login)
last_changed=$(getent shadow klaas 2>/dev/null | cut -d: -f3)
[ "$last_changed" = "0" ] || exit 1

# 4. Check max password age is 180 days
max_days=$(chage -l klaas 2>/dev/null | grep "Maximum number of days" | grep -oE '[0-9]+')
[ "$max_days" = "180" ] || exit 1

exit 0
