#!/bin/bash
# Step 4 Verification: Extending LVM

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for lvextend command
grep -qE "lvextend\b" "$HIST" || exit 1

# Check for resize2fs or xfs_growfs
grep -qE "(resize2fs|xfs_growfs)\b" "$HIST" || exit 1

exit 0
