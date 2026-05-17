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

installed=()

for remote_skill in "$REMOTE_SKILLS"/*; do
  [[ -d "$remote_skill" ]] || continue
  skill_name="$(basename "$remote_skill")"
  local_skill="$DEST_ROOT/$skill_name"

  rm -rf "$local_skill"
  cp -R "$remote_skill" "$local_skill"
  installed+=("$skill_name")
done

echo "Destination: $DEST_ROOT"
echo "Installed/Refreshed skills:"
if [[ ${#installed[@]} -eq 0 ]]; then
  echo "- none"
else
  for item in "${installed[@]}"; do
    echo "- $item"
  done
fi

echo "Installed count: ${#installed[@]}"
