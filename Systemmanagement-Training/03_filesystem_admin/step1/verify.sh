#!/bin/bash
# Step 1 Verification: Filesystems & /etc/fstab

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for required commands in history
grep -qE "^mount\b" "$HIST" || exit 1
grep -qE "^findmnt\b" "$HIST" || exit 1
grep -qE "^lsblk\b" "$HIST" || exit 1

exit 0
