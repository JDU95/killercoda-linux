#!/bin/bash
# Step 2 Verification: Creating Volume Groups

HIST=/root/.bash_history
history -a 2>/dev/null || true

# Check for vgcreate command in history
grep -qE "vgcreate\b" "$HIST" || exit 1

# Check for vgdisplay or vgs command
grep -qE "(vgdisplay|vgs)\b" "$HIST" || exit 1

exit 0
