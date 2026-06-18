#!/bin/bash
# Write history flush to .bashrc so the interactive shell picks it up
grep -q "PROMPT_COMMAND='history -a'" /root/.bashrc 2>/dev/null || \
    echo "PROMPT_COMMAND='history -a'" >> /root/.bashrc

# Also set it for this session
PROMPT_COMMAND='history -a'
export PROMPT_COMMAND
HISTFILE=/root/.bash_history
export HISTFILE

clear
