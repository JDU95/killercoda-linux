#!/bin/bash
# Step 5 Verification: Managing Groups
# Check if user created groups and managed memberships

grep -q "groupadd\|usermod" ~/.bash_history && exit 0 || exit 1
