#!/bin/bash
# Step 4 Verification: Managing Passwords
# Check if user used passwd or chage command

grep -q "passwd\|chage" ~/.bash_history && exit 0 || exit 1
