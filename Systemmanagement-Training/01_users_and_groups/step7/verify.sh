#!/bin/bash
# Step 7 Verification: sudo Configuration
# Check if user configured sudoers

grep -q "visudo\|sudoers\|sudo bash" ~/.bash_history && exit 0 || exit 1
