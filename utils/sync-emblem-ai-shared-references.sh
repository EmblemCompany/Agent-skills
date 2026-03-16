#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

sync_prompt_examples() {
  local source_file="$ROOT_DIR/shared/emblem-ai-prompt-examples.md"
  local source_dir="$ROOT_DIR/shared/emblem-ai-prompt-examples"
  local targets=(
    "$ROOT_DIR/skills/emblem-ai/references/emblem-ai-prompt-examples.md"
    "$ROOT_DIR/skills/emblem-ai-react/references/emblem-ai-prompt-examples.md"
    "$ROOT_DIR/skills/emblem-ai-prompt-examples/references/emblem-ai-prompt-examples.md"
  )
  local target
  local target_dir

  for target in "${targets[@]}"; do
    target_dir="$(dirname "$target")"
    mkdir -p "$target_dir"
    cp "$source_file" "$target"
    rm -rf "$target_dir/emblem-ai-prompt-examples"
    mkdir -p "$target_dir/emblem-ai-prompt-examples"
    cp -R "$source_dir/." "$target_dir/emblem-ai-prompt-examples/"
  done

  echo "Synced shared EmblemAI prompt examples to ${#targets[@]} skill reference locations."
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
sync_react_references
