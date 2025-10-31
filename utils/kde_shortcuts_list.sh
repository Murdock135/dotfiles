#!/bin/bash
grep -v "^#\|^$\|^\[" ~/.config/kglobalshortcutsrc | \
  grep -v "=none" | \
  awk -F'=' '{print $1 " → " $2}' | \
  column -t -s'→' | \
  fzf --header="Active KDE Shortcuts"


# ==================================================
# Alternative
# ==================================================

# awk '/^\[.*\]/{component=$0} /^[^_#].*=.+/ && !/=none/ {print component, $0}' ~/.config/kglobalshortcutsrc | less
