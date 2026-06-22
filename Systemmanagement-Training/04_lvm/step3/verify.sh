#!/bin/bash
# Step 3 Verification: Logical Volumes & Mounting

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for lvcreate command
grep -qE "lvcreate\b" "$HIST" || exit 1

# Check for mkfs command
grep -qE "mkfs\b" "$HIST" || exit 1

# Check for mount command
grep -qE "mount\b" "$HIST" || exit 1

# Check for lvs or lvdisplay
grep -qE "(lvs|lvdisplay)\b" "$HIST" || exit 1

exit 0
