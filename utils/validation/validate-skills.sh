#!/bin/bash
# validate-skills.sh - Validate one or all skills in the repository
# Usage:
#   bash utils/validation/validate-skills.sh [--strict]
#   bash utils/validation/validate-skills.sh [--strict] --skill <name-or-path>

set -e

SKILLS_DIR="skills"
ERRORS=0
STRICT_MODE=0
TARGET_SKILL=""

# Strict Agent Skills spec top-level fields.
STRICT_ALLOWED_FIELDS=("name" "description" "license" "allowed-tools" "metadata" "compatibility")

# Cross-platform superset used by default for broader compatibility.
PERMISSIVE_ALLOWED_FIELDS=("name" "description" "license" "allowed-tools" "metadata" "compatibility" "user-invocable")

usage() {
    cat <<EOF
Usage:
  bash utils/validation/validate-skills.sh [--strict]
  bash utils/validation/validate-skills.sh [--strict] --skill <name-or-path>
  bash utils/validation/validate-skills.sh [--strict] --skills-dir <path>

Options:
  --strict            Use strict agentskills.io-compatible frontmatter checks
  --skill <value>     Validate only one skill (name under skills/ or directory path)
  --skills-dir <path> Override the skills directory (default: skills)
  -h, --help          Show this help
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --strict)
            STRICT_MODE=1
            ;;
        --skill)
            if [ -z "${2:-}" ]; then
                echo "ERROR: --skill requires a value"
                usage
                exit 2
            fi
            TARGET_SKILL="$2"
            shift
            ;;
        --skills-dir)
            if [ -z "${2:-}" ]; then
                echo "ERROR: --skills-dir requires a value"
                usage
                exit 2
            fi
            SKILLS_DIR="$2"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "ERROR: Unknown argument '$1'"
            usage
            exit 2
            ;;
    esac
    shift
done

contains_item() {
    local seek="$1"
    shift
    local item
    for item in "$@"; do
        if [ "$item" = "$seek" ]; then
            return 0
        fi
    done
    return 1
}

validate_name_format() {
    local skill_name="$1"

    if [ "${#skill_name}" -gt 64 ]; then
        echo "  FAIL: name must be <= 64 chars"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: name length <= 64"
    fi

    if ! echo "$skill_name" | grep -Eq '^[a-z0-9-]+$'; then
        echo "  FAIL: name must match ^[a-z0-9-]+$"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: name contains valid characters"
    fi

    if echo "$skill_name" | grep -q -- '--'; then
        echo "  FAIL: name must not contain consecutive hyphens (--)"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: no consecutive hyphens"
    fi

    if echo "$skill_name" | grep -Eq '^-|-$'; then
        echo "  FAIL: name must not start or end with hyphen"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: name does not start/end with hyphen"
    fi
}

validate_top_level_fields() {
    local frontmatter="$1"
    local field
    local unknown_found=0
    local -a allowed_fields

    if [ "$STRICT_MODE" -eq 1 ]; then
        allowed_fields=("${STRICT_ALLOWED_FIELDS[@]}")
    else
        allowed_fields=("${PERMISSIVE_ALLOWED_FIELDS[@]}")
    fi

    while IFS= read -r field; do
        if [ -z "$field" ]; then
            continue
        fi

        if ! contains_item "$field" "${allowed_fields[@]}"; then
            echo "  FAIL: Unknown top-level field '$field'"
            ERRORS=$((ERRORS + 1))
            unknown_found=1
        fi
    done <<EOF
$(echo "$frontmatter" | sed -nE 's/^([A-Za-z0-9-]+):.*/\1/p')
EOF

    if [ "$unknown_found" -eq 0 ]; then
        echo "  OK: Top-level fields are allowed"
    fi
}

validate_metadata_values_are_strings() {
    # Strict mode matches agentskills.io expectations.
    if [ "$STRICT_MODE" -eq 0 ]; then
        echo "  INFO: Skipping strict metadata scalar checks (permissive mode)"
        return
    fi

    local frontmatter="$1"
    local in_metadata=0
    local line
    local meta_has_entries=0
    local meta_errors=0
    local meta_first_error=""

    while IFS= read -r line; do
        if echo "$line" | grep -qE '^metadata:'; then
            in_metadata=1
            continue
        fi

        if [ "$in_metadata" -eq 0 ]; then
            continue
        fi

        if echo "$line" | grep -qE '^[A-Za-z0-9-]+:'; then
            # Reached next top-level field.
            in_metadata=0
            continue
        fi

        if [ -z "$(echo "$line" | tr -d '[:space:]')" ]; then
            continue
        fi

        if ! echo "$line" | grep -qE '^  [A-Za-z0-9-]+:'; then
            if [ "$meta_errors" -eq 0 ]; then
                meta_first_error="$line"
            fi
            meta_errors=$((meta_errors + 1))
            continue
        fi

        meta_has_entries=1

        # Enforce scalar string values only. Reject nested objects/lists and blank values.
        if ! echo "$line" | grep -qE '^  [A-Za-z0-9-]+: .+'; then
            if [ "$meta_errors" -eq 0 ]; then
                meta_first_error="$line"
            fi
            meta_errors=$((meta_errors + 1))
            continue
        fi

        local value
        value=$(echo "$line" | sed -E 's/^  [A-Za-z0-9-]+: //')
        if echo "$value" | grep -qE '^\{.*\}$|^\[.*\]$'; then
            if [ "$meta_errors" -eq 0 ]; then
                meta_first_error="$line"
            fi
            meta_errors=$((meta_errors + 1))
        fi
    done <<EOF
$frontmatter
EOF

    if echo "$frontmatter" | grep -qE '^metadata:'; then
        if [ "$meta_has_entries" -eq 0 ]; then
            echo "  FAIL: metadata must contain at least one key: value entry"
            ERRORS=$((ERRORS + 1))
        elif [ "$meta_errors" -gt 0 ]; then
            echo "  FAIL: metadata values must be plain strings"
            ERRORS=$((ERRORS + 1))
        fi
        if [ "$meta_errors" -eq 0 ]; then
            echo "  OK: metadata values are plain strings"
        fi
    fi
}

extract_frontmatter_field_text() {
    local frontmatter="$1"
    local field="$2"

    echo "$frontmatter" | awk -v field="$field" '
BEGIN {
    in_field = 0
    block_mode = 0
    value = ""
    printed = 0
}
{
    if (in_field == 0 && $0 ~ ("^" field ":[[:space:]]*")) {
        in_field = 1
        line = $0
        sub("^" field ":[[:space:]]*", "", line)

        if (line ~ /^\||^>/) {
            block_mode = 1
            next
        }

        print line
        printed = 1
        exit
    }

    if (in_field == 1 && block_mode == 1) {
        if ($0 ~ /^[A-Za-z0-9-]+:[[:space:]]*/) {
            print value
            printed = 1
            exit
        }

        if ($0 ~ /^  /) {
            line = $0
            sub(/^  /, "", line)
            if (length(value) > 0) {
                value = value " " line
            } else {
                value = line
            }
            next
        }

        if ($0 ~ /^[[:space:]]*$/) {
            next
        }

        print value
        printed = 1
        exit
    }
}
END {
    if (in_field == 1 && block_mode == 1 && printed == 0) {
        print value
    }
}
'
}

resolve_target_skill_dir() {
    local target="$1"

    if [ -z "$target" ]; then
        return 1
    fi

    if [ -f "$target" ] && [ "$(basename "$target")" = "SKILL.md" ]; then
        dirname "$target"
        return 0
    fi

    if [ -d "$target" ]; then
        echo "$target"
        return 0
    fi

    if [ -d "$SKILLS_DIR/$target" ]; then
        echo "$SKILLS_DIR/$target"
        return 0
    fi

    if [ -d "$SKILLS_DIR/${target%/}" ]; then
        echo "$SKILLS_DIR/${target%/}"
        return 0
    fi

    return 1
}

validate_skill_dir() {
    local skill_dir="$1"
    local skill_name
    local skill_file
    local frontmatter
    local field
    local yaml_name
    local description_value
    local description_len
    local compatibility_value
    local compatibility_len
    local line_count

    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    echo ""
    echo "--- $skill_name ---"

    # Check SKILL.md exists
    if [ ! -f "$skill_file" ]; then
        echo "  FAIL: Missing SKILL.md"
        ERRORS=$((ERRORS + 1))
        return
    fi
    echo "  OK: SKILL.md exists"

    # Check frontmatter exists
    if ! head -1 "$skill_file" | grep -q "^---$"; then
        echo "  FAIL: Missing frontmatter (no opening ---)"
        ERRORS=$((ERRORS + 1))
        return
    fi
    echo "  OK: Frontmatter present"

    # Check frontmatter closing delimiter exists.
    if [ "$(grep -c '^---$' "$skill_file")" -lt 2 ]; then
        echo "  FAIL: Missing frontmatter closing delimiter (---)"
        ERRORS=$((ERRORS + 1))
        return
    fi
    echo "  OK: Frontmatter closing delimiter present"

    # Extract frontmatter
    frontmatter=$(sed -n '2,/^---$/p' "$skill_file" | sed '$d')

    validate_top_level_fields "$frontmatter"

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

    validate_name_format "$yaml_name"

    # Check description length (spec max 1024 chars)
    description_value=$(extract_frontmatter_field_text "$frontmatter" "description")
    description_len=${#description_value}
    if [ "$description_len" -gt 1024 ]; then
        echo "  FAIL: description is $description_len chars (max 1024)"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: description length <= 1024"
    fi

    # Check compatibility length if present (spec max 500 chars)
    compatibility_value=$(extract_frontmatter_field_text "$frontmatter" "compatibility")
    if [ -n "$compatibility_value" ]; then
        compatibility_len=${#compatibility_value}
        if [ "$compatibility_len" -gt 500 ]; then
            echo "  FAIL: compatibility is $compatibility_len chars (max 500)"
            ERRORS=$((ERRORS + 1))
        else
            echo "  OK: compatibility length <= 500"
        fi
    fi

    validate_metadata_values_are_strings "$frontmatter"

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
    for field in "license:" "compatibility:" "metadata:" "allowed-tools:"; do
        if echo "$frontmatter" | grep -q "$field"; then
            echo "  OK: Has recommended '$field'"
        else
            echo "  INFO: Missing optional '$field'"
        fi
    done
}

skill_dirs=()

if [ -n "$TARGET_SKILL" ]; then
    if ! target_skill_dir=$(resolve_target_skill_dir "$TARGET_SKILL"); then
        echo "ERROR: Could not resolve skill target '$TARGET_SKILL'"
        exit 2
    fi
    skill_dirs=("$target_skill_dir")
    echo "Validating selected skill: $target_skill_dir"
else
    echo "Validating all skills in $SKILLS_DIR/"
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [ -d "$skill_dir" ]; then
            skill_dirs+=("$skill_dir")
        fi
    done
fi

echo "========================================"
if [ "$STRICT_MODE" -eq 1 ]; then
    echo "Mode: strict (agentskills.io-compatible)"
else
    echo "Mode: permissive (cross-platform)"
fi

if [ "${#skill_dirs[@]}" -eq 0 ]; then
    echo "ERROR: No skill directories found"
    exit 2
fi

for skill_dir in "${skill_dirs[@]}"; do
    validate_skill_dir "$skill_dir"
done

echo ""
echo "========================================"
if [ "$ERRORS" -gt 0 ]; then
    echo "RESULT: $ERRORS error(s) found"
    exit 1
else
    echo "RESULT: All skills valid"
    exit 0
fi
