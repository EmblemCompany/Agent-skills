#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_FILE="$ROOT_DIR/shared/emblem-ai-prompt-examples.md"
SOURCE_DIR="$ROOT_DIR/shared/emblem-ai-prompt-examples"

TARGETS=(
  "$ROOT_DIR/skills/emblem-ai-agent-wallet/references/emblem-ai-prompt-examples.md"
  "$ROOT_DIR/skills/emblem-ai/references/emblem-ai-prompt-examples.md"
  "$ROOT_DIR/skills/emblem-ai-react/references/emblem-ai-prompt-examples.md"
  "$ROOT_DIR/skills/emblem-ai-prompt-examples/references/emblem-ai-prompt-examples.md"
)

for target in "${TARGETS[@]}"; do
  target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"
  cp "$SOURCE_FILE" "$target"
  rm -rf "$target_dir/emblem-ai-prompt-examples"
  mkdir -p "$target_dir/emblem-ai-prompt-examples"
  cp -R "$SOURCE_DIR/." "$target_dir/emblem-ai-prompt-examples/"
done

echo "Synced EmblemAI prompt example index and topic files to ${#TARGETS[@]} skill reference locations."