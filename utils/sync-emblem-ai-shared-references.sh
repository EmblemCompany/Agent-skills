#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

sync_prompt_examples() {
  local source_file="$ROOT_DIR/shared/emblem-ai-prompt-examples.md"
  local source_dir="$ROOT_DIR/shared/emblem-ai-prompt-examples"
  local target="$ROOT_DIR/skills/emblem-ai-prompt-examples/references/emblem-ai-prompt-examples.md"
  local target_dir

  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"
  cp "$source_file" "$target"
  rm -rf "$target_dir/emblem-ai-prompt-examples"
  mkdir -p "$target_dir/emblem-ai-prompt-examples"
  cp -R "$source_dir/." "$target_dir/emblem-ai-prompt-examples/"

  echo "Synced shared EmblemAI prompt examples to emblem-ai-prompt-examples skill references."
}

cleanup_stale_prompt_examples() {
  local stale_reference_roots=(
    "$ROOT_DIR/skills/emblem-ai/references"
    "$ROOT_DIR/skills/emblem-ai-react/references"
    "$ROOT_DIR/skills/emblem-ai-agent-wallet/references"
  )
  local file_name="emblem-ai-prompt-examples.md"
  local dir_name="emblem-ai-prompt-examples"
  local cleaned=0
  local reference_root
  local file_path
  local dir_path

  for reference_root in "${stale_reference_roots[@]}"; do
    file_path="$reference_root/$file_name"
    dir_path="$reference_root/$dir_name"

    if [ -f "$file_path" ]; then
      rm -f "$file_path"
      cleaned=$((cleaned + 1))
    fi

    if [ -d "$dir_path" ]; then
      rm -rf "$dir_path"
      cleaned=$((cleaned + 1))
    fi
  done

  echo "Removed stale prompt example copies from excluded skills (${cleaned} items deleted)."
}

sync_react_references() {
  local source_dir="$ROOT_DIR/shared/emblem-ai-react-references"
  local target_dirs=(
    "$ROOT_DIR/skills/emblem-ai/references"
    "$ROOT_DIR/skills/emblem-ai-react/references"
  )
  local files=(
    "auth-react.md"
    "emblem-ai-react.md"
    "migratefun-react.md"
    "react-components.md"
  )
  local target_dir
  local file_name

  for target_dir in "${target_dirs[@]}"; do
    mkdir -p "$target_dir"
    for file_name in "${files[@]}"; do
      cp "$source_dir/$file_name" "$target_dir/$file_name"
    done
  done

  echo "Synced shared EmblemAI React references to ${#target_dirs[@]} skill reference locations."
}

sync_prompt_examples
cleanup_stale_prompt_examples
sync_react_references
