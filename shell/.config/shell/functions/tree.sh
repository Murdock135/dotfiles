#!/bin/bash

function tree() {
  local depth="${1:-3}" # default depth = 3
  if command -v eza >/dev/null 2>&1; then
    eza --tree --level="$depth" -la --group-directories-first --icons --ignore-glob='.git'
  elif command -v tree >/dev/null 2>&1; then
    command tree -a -L "$depth"
  else
    echo "Neither 'eza' nor 'tree' is installed." >&2
    return 1
  fi
}
