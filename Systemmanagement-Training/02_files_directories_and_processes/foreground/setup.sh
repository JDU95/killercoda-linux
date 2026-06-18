#!/bin/bash
# Enable real-time history tracking for verification scripts
export PROMPT_COMMAND='history -a'

# --- Prerequisite setup (users/groups/dirs from Szenario 01) ---
# Groups
getent group bank  >/dev/null 2>&1 || groupadd bank
getent group train >/dev/null 2>&1 || groupadd train

# Users (idempotent)
for user_spec in "joe:Joe Dalton" "jack:Jack Dalton" "william:William Dalton" "averall:Averall Dalton"; do
    user="${user_spec%%:*}"
    comment="${user_spec#*:}"
    getent passwd "$user" >/dev/null 2>&1 || useradd -c "$comment" -s /bin/bash -m "$user"
done

# Group memberships
usermod -a -G bank joe      2>/dev/null
usermod -a -G bank jack     2>/dev/null
usermod -a -G bank william  2>/dev/null
usermod -a -G train joe     2>/dev/null
usermod -a -G train averall 2>/dev/null

# Project directories
mkdir -p /projects/bank /projects/train
chown :bank  /projects/bank
chown :train /projects/train
chmod 770    /projects/bank
chmod 770    /projects/train

clear
