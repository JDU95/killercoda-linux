#!/bin/bash
# Step 2 Verification: Configuration Files
# Check if user examined /etc/passwd and /etc/shadow

grep -q "grep.*passwd\|grep.*shadow\|grep.*group\|cat /etc/passwd\|cat /etc/shadow" ~/.bash_history && exit 0 || exit 1
