#!/bin/bash
# Step 6 Verification: Exercise - Project Users
# Check if user created the Dalton team users

grep -q "useradd.*joe\|useradd.*jack\|useradd.*william\|useradd.*averall\|groupadd.*bank\|groupadd.*train" ~/.bash_history && exit 0 || exit 1
