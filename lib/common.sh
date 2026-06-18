#!/usr/bin/env bash
# lib/common.sh
# -----------------------------------------------------------------------------
# Shared helpers sourced by this repo's scripts. Source it like:
#   source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"
# (adjust the number of `../` to your script's depth).
# -----------------------------------------------------------------------------

# --- DOTFILES_DIR -------------------------------------------------------------
# Resolves the repo root from the *caller's* location (depth-independent —
# no script needs to count "../.." to find the root). Honors an
# already-exported DOTFILES_DIR so callers can still override it.
if [ -z "${DOTFILES_DIR:-}" ]; then
  _common_caller="${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}"

  # Follow symlinks manually (portable: works with both GNU and BSD readlink,
  # unlike `readlink -f` which BSD/macOS readlink doesn't support).
  while [ -L "$_common_caller" ]; do
    _common_link_dir="$(cd -P "$(dirname "$_common_caller")" && pwd)"
    _common_caller="$(readlink "$_common_caller")"
    case "$_common_caller" in
      /*) ;;
      *) _common_caller="$_common_link_dir/$_common_caller" ;;
    esac
  done

  _common_caller_dir="$(cd -P "$(dirname "$_common_caller")" >/dev/null 2>&1 && pwd)"
  DOTFILES_DIR="$(git -C "$_common_caller_dir" rev-parse --show-toplevel 2>/dev/null || true)"

  unset _common_caller _common_link_dir _common_caller_dir
fi
: "${DOTFILES_DIR:?Could not determine DOTFILES_DIR. Run this from inside a git checkout of the dotfiles repo, or export DOTFILES_DIR manually.}"
export DOTFILES_DIR

# --- Managed block helpers -----------------------------------------------------
# add_managed_block <file> <tag> <content>
# Idempotently writes `content` into `file`, wrapped in markers derived from
# `tag`. Re-running with the same tag replaces the previous block in place
# instead of duplicating it.
add_managed_block() {
  local target_file="$1" tag="$2" content="$3"
  local begin="# >>> ${tag} (managed by dotfiles) >>>"
  local end="# <<< ${tag} (managed by dotfiles) <<<"

  [ -f "$target_file" ] || : >"$target_file"

  local tmpfile
  tmpfile="$(mktemp "${target_file}.XXXX")"
  trap 'rm -f "$tmpfile"' RETURN

  awk -v start="$begin" -v end="$end" '
    $0 == start { skip = 1; next }
    $0 == end   { skip = 0; next }
    !skip { print }
  ' "$target_file" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' >"$tmpfile"

  {
    printf '\n%s\n' "$begin"
    printf '%s\n' "$content"
    printf '%s\n' "$end"
  } >>"$tmpfile"

  mv "$tmpfile" "$target_file"
}

# remove_managed_block <file> <tag>
# Removes the block previously written by add_managed_block for this tag.
# No-op if the file or block doesn't exist.
remove_managed_block() {
  local target_file="$1" tag="$2"
  local begin="# >>> ${tag} (managed by dotfiles) >>>"
  local end="# <<< ${tag} (managed by dotfiles) <<<"

  [ -f "$target_file" ] || return 0
  grep -Fq "$begin" "$target_file" || return 0

  local tmpfile
  tmpfile="$(mktemp "${target_file}.XXXX")"
  trap 'rm -f "$tmpfile"' RETURN

  awk -v start="$begin" -v end="$end" '
    $0 == start { skip = 1; next }
    $0 == end   { skip = 0; next }
    !skip { print }
  ' "$target_file" >"$tmpfile"

  mv "$tmpfile" "$target_file"
}
