#!/bin/bash
# validate-all.sh - Validate all skills in the repository with the official
# agentskills validator plus repository-specific checks.
# Usage: bash validate-all.sh [--strict]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/utils/sync-emblem-ai-shared-references.sh"

bash "$SCRIPT_DIR/utils/validation/validate-skills.sh" --skills-dir "$SCRIPT_DIR/skills" "$@"
