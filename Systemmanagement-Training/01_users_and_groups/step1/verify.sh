#!/bin/bash
# Step 1 Verification: Benutzer hat id und groups ausgeführt

# Prüfen ob id ausgeführt wurde
grep -q "^id$" ~/.bash_history || exit 1

# Prüfen ob groups ausgeführt wurde
grep -q "^groups$" ~/.bash_history || exit 1

exit 0
