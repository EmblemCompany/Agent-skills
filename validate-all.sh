#!/bin/bash
# validate-all.sh - Validate all skills in the repository
# Usage: bash validate-all.sh

set -e

SKILLS_DIR="skills"
ERRORS=0

echo "Validating all skills in $SKILLS_DIR/"
echo "========================================"

for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    echo ""
    echo "--- $skill_name ---"

    # Check SKILL.md exists
    if [ ! -f "$skill_file" ]; then
        echo "  FAIL: Missing SKILL.md"
        ERRORS=$((ERRORS + 1))
        continue
    fi
    echo "  OK: SKILL.md exists"

    # Check frontmatter exists
    if ! head -1 "$skill_file" | grep -q "^---$"; then
        echo "  FAIL: Missing frontmatter (no opening ---)"
        ERRORS=$((ERRORS + 1))
        continue
    fi
    echo "  OK: Frontmatter present"

    # Extract frontmatter
    frontmatter=$(sed -n '2,/^---$/p' "$skill_file" | sed '$d')

    # Check required fields
    for field in "name:" "description:"; do
        if ! echo "$frontmatter" | grep -q "^$field"; then
            echo "  FAIL: Missing required field '$field'"
            ERRORS=$((ERRORS + 1))
        else
            echo "  OK: Has '$field'"
        fi
    done

    # Check name matches directory
    yaml_name=$(echo "$frontmatter" | grep "^name:" | sed 's/^name: *//')
    if [ "$yaml_name" != "$skill_name" ]; then
        echo "  FAIL: name '$yaml_name' does not match directory '$skill_name'"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: name matches directory"
    fi

    # Check line count
    line_count=$(wc -l < "$skill_file" | tr -d ' ')
    if [ "$line_count" -gt 500 ]; then
        echo "  WARN: SKILL.md has $line_count lines (recommended < 500)"
    else
        echo "  OK: $line_count lines (< 500)"
    fi

    # Check trailing newline
    if [ -n "$(tail -c 1 "$skill_file")" ]; then
        echo "  FAIL: Missing trailing newline"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: Has trailing newline"
    fi

    # Check for recommended fields
    for field in "license:" "compatibility:" "metadata:"; do
        if echo "$frontmatter" | grep -q "$field"; then
            echo "  OK: Has recommended '$field'"
        else
            echo "  INFO: Missing optional '$field'"
        fi
    done
done

echo ""
echo "========================================"
if [ $ERRORS -gt 0 ]; then
    echo "RESULT: $ERRORS error(s) found"
    exit 1
else
    echo "RESULT: All skills valid"
    exit 0
fi
