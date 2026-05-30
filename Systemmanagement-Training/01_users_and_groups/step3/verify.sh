#!/bin/bash
# Step 3 Verification: Creating Users
# Check if user ran useradd command

grep -q "useradd" ~/.bash_history && exit 0 || exit 1
