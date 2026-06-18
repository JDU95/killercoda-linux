#!/bin/bash
# Step 5 Verification: Group Management
# Check that klaas was added to the 'quack' secondary group

# 1. Check group 'quack' exists
getent group quack >/dev/null 2>&1 || exit 1

# 2. Check user 'klaas' is a member of group 'quack'
quack_members=$(getent group quack | cut -d: -f4)
echo "$quack_members" | grep -qw "klaas" || exit 1

# 3. Verify klaas's primary group (duck) is still intact from step 3
getent group duck >/dev/null 2>&1 || exit 1
duck_gid=$(getent group duck | cut -d: -f3)
klaas_gid=$(getent passwd klaas | cut -d: -f4)
[ "$duck_gid" = "$klaas_gid" ] || exit 1

exit 0
