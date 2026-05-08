#!/usr/bin/env bash
set -euo pipefail

REMOTE_URL="https://github.com/Yuan1z0825/nature-skills.git"
DEST_ROOT="${CODEX_HOME:-$HOME/.codex}/skills"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required but not found." >&2
  exit 1
fi

mkdir -p "$DEST_ROOT"

if ! git clone --depth 1 "$REMOTE_URL" "$TMP_DIR/repo"; then
  echo "ERROR: failed to clone $REMOTE_URL" >&2
  exit 1
fi

REMOTE_SKILLS="$TMP_DIR/repo/skills"
if [[ ! -d "$REMOTE_SKILLS" ]]; then
  echo "ERROR: remote repository has no skills/ directory." >&2
  exit 1
fi

updated=()
unchanged_count=0

for remote_skill in "$REMOTE_SKILLS"/*; do
  [[ -d "$remote_skill" ]] || continue
  skill_name="$(basename "$remote_skill")"
  local_skill="$DEST_ROOT/$skill_name"

  if [[ ! -d "$local_skill" ]]; then
    rm -rf "$local_skill"
    cp -R "$remote_skill" "$local_skill"
    updated+=("$skill_name (new)")
    continue
  fi

  remote_hash="$(find "$remote_skill" -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | awk '{print $1}')"
  local_hash="$(find "$local_skill" -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | awk '{print $1}')"

  if [[ "$remote_hash" != "$local_hash" ]]; then
    rm -rf "$local_skill"
    cp -R "$remote_skill" "$local_skill"
    updated+=("$skill_name (updated)")
  else
    unchanged_count=$((unchanged_count + 1))
  fi
done

echo "Destination: $DEST_ROOT"
if [[ ${#updated[@]} -gt 0 ]]; then
  echo "Installed/Updated skills:"
  for item in "${updated[@]}"; do
    echo "- $item"
  done
else
  echo "Installed/Updated skills: none"
fi
echo "Unchanged skills: $unchanged_count"
