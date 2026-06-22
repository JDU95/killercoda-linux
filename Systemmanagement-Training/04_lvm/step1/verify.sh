#!/bin/bash
# Step 1 Verification: LVM Concepts & Physical Volumes

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for pvcreate or pvdisplay command in history
grep -qE "pvcreate\b" "$HIST" || exit 1
grep -qE "(pvdisplay|pvs)\b" "$HIST" || exit 1

exit 0
