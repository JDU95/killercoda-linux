#!/bin/bash
# Step 1 Verification: Understanding Users and Groups
# Check if the user saved their id/groups output to the verification file

[ -f /tmp/step1_verification.txt ] || exit 1

# File must not be empty
[ -s /tmp/step1_verification.txt ] || exit 1

# File should contain uid= or gid= output from 'id'
grep -qE "uid=|gid=" /tmp/step1_verification.txt || exit 1

exit 0
