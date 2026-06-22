#!/bin/bash
# Step 5 Verification: Filesystem Repair & fsck

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for fsck or xfs_repair command in history
grep -qE "(fsck|xfs_repair)" "$HIST" || exit 1

exit 0
