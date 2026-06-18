#!/bin/bash
# Step 6 Verification: Übung 2 – Projektteams (bank/train)

# 1. Check project groups exist
getent group bank  >/dev/null 2>&1 || exit 1
getent group train >/dev/null 2>&1 || exit 1

# 2. Check all four users exist
for user in joe jack william averall; do
    getent passwd "$user" >/dev/null 2>&1 || exit 1
done

# 3. Check bank group members: joe, jack, william must be in bank
bank_members=$(getent group bank | cut -d: -f4)
echo "$bank_members" | grep -qw "joe"     || exit 1
echo "$bank_members" | grep -qw "jack"    || exit 1
echo "$bank_members" | grep -qw "william" || exit 1

# 4. Check train group members: joe and averall must be in train
train_members=$(getent group train | cut -d: -f4)
echo "$train_members" | grep -qw "joe"    || exit 1
echo "$train_members" | grep -qw "averall" || exit 1

# 5. Check project directories exist
[ -d "/projects/bank"  ] || exit 1
[ -d "/projects/train" ] || exit 1

# 6. Check group ownership of project directories
bank_group=$(stat -c '%G' /projects/bank)
train_group=$(stat -c '%G' /projects/train)
[ "$bank_group"  = "bank"  ] || exit 1
[ "$train_group" = "train" ] || exit 1

# 7. Check permissions are 770
bank_perms=$(stat -c '%a' /projects/bank)
train_perms=$(stat -c '%a' /projects/train)
[ "$bank_perms"  = "770" ] || exit 1
[ "$train_perms" = "770" ] || exit 1

# 8. Check password max-age = 30 days for all users
for user in joe jack william averall; do
    max_days=$(chage -l "$user" 2>/dev/null | grep "Maximum number of days" | grep -oE '[0-9]+')
    [ "$max_days" = "30" ] || exit 1
done

# 9. Check that account expiry is set (not 'never') for all users
for user in joe jack william averall; do
    expires=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2 | xargs)
    [ "$expires" = "never" ] && exit 1
    [ -z "$expires" ]        && exit 1
done

exit 0
