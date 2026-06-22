#!/bin/bash
# Step 4 Verification: Creating Filesystems

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for mkfs command in history
grep -qE "mkfs\b" "$HIST" || exit 1

# Check that a filesystem was created (ext4 or xfs)
( grep -qE "mkfs\.(ext4|xfs)" "$HIST" || grep -qE "mkfs\s" "$HIST" ) || exit 1

exit 0
