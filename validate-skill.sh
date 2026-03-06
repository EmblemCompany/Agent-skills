#!/bin/bash
# validate-skill.sh - Validate a single skill
# Usage: bash validate-skill.sh <skill-name-or-path> [--strict]

set -e

if [ $# -lt 1 ]; then
    echo "Usage: bash validate-skill.sh <skill-name-or-path> [--strict]"
    exit 2
fi

TARGET_SKILL="$1"
shift

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/utils/validation/validate-skills.sh" --skills-dir "$SCRIPT_DIR/skills" --skill "$TARGET_SKILL" "$@"
