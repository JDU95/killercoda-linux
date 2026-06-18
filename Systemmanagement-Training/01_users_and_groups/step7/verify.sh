#!/bin/bash
# Step 7 Verification: Übung 3 – sudo configuration for joe and bank group

# Helper: check if a sudoers rule exists for a given pattern
# Searches both /etc/sudoers.d/ files and the main /etc/sudoers
sudoers_contains() {
    local pattern="$1"
    # Check sudoers.d directory
    if ls /etc/sudoers.d/ 2>/dev/null | xargs -I{} grep -ql "$pattern" /etc/sudoers.d/{} 2>/dev/null; then
        return 0
    fi
    # Check main sudoers file
    grep -q "$pattern" /etc/sudoers 2>/dev/null && return 0
    return 1
}

# 1. Check joe has a sudoers rule (user 'joe' with ALL privileges)
sudoers_contains "^joe" || exit 1

# 2. Check the bank group has a sudoers rule (%bank with ALL privileges)
sudoers_contains "^%bank" || exit 1

# 3. Check sudoers syntax is valid
visudo -c >/dev/null 2>&1 || exit 1

exit 0
