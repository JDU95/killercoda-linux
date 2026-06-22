#!/bin/bash
# Step 3 Verification: Partitioning with parted

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for parted command in history
grep -qE "parted\b" "$HIST" || exit 1

# Check that a partition was created (lsblk or parted show partition)
( [ -b /dev/vdb1 ] || grep -qE "mkpart" "$HIST" ) || exit 1

exit 0
