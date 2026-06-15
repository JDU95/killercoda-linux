#!/bin/bash
# Step 2 Verification: Configuration Files
# Check if user saved the file permissions to the verification file

[ -f /tmp/step2_verification.txt ] || exit 1

# File must not be empty
[ -s /tmp/step2_verification.txt ] || exit 1

# File should contain entries for /etc/passwd and /etc/shadow
grep -q "passwd" /tmp/step2_verification.txt || exit 1
grep -q "shadow" /tmp/step2_verification.txt || exit 1

exit 0
