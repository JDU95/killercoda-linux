#!/bin/bash
# Step 1 Verification: Understanding Users and Groups
# Check if user examined the system files

grep -q "whoami\|id\|groups\|cat /etc/passwd\|cat /etc/group" ~/.bash_history && exit 0 || exit 1
