#!/bin/bash
# Step 2 Verification: Block Devices & Device Naming

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for required commands in history
grep -qE "^lsblk\b" "$HIST" || exit 1
grep -qE "^blkid\b" "$HIST" || exit 1
grep -qE "^df\b" "$HIST" || exit 1
grep -qE "^du\b" "$HIST" || exit 1

exit 0
