#!/bin/bash

# This script finds all Lua files in the nvim config and prints their content
find ~/.config/nvim -name "*.lua" -type f -exec bash -c 'echo -e "\n--- PATH: ${1/#$HOME/\~} ---"; cat "$1"' _ {} \;
