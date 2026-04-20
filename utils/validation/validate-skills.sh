#!/bin/bash
# validate-skills.sh - Validate one or all skills in the repository
# Usage:
#   bash utils/validation/validate-skills.sh
#   bash utils/validation/validate-skills.sh --skill <name-or-path>
#
# This wrapper runs the official `agentskills` validator from the
# `skills-ref` package for each selected skill directory, then applies
# repository-specific markdown/link checks.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

SKILLS_DIR="skills"
ERRORS=0
STRICT_FLAG_SEEN=0
TARGET_SKILL=""

# Strict Agent Skills spec top-level fields.
STRICT_ALLOWED_FIELDS=("name" "description" "license" "allowed-tools" "metadata" "compatibility")

# Cross-platform superset used by default for broader compatibility.
PERMISSIVE_ALLOWED_FIELDS=("name" "description" "license" "allowed-tools" "metadata" "compatibility" "user-invocable")

URL_CHECK_JOBS="${URL_CHECK_JOBS:-8}"
URL_CONNECT_TIMEOUT="${URL_CONNECT_TIMEOUT:-2}"
URL_MAX_TIME="${URL_MAX_TIME:-5}"

is_validation_exempt_file() {
    local file_path="$1"

    case "$file_path" in
        "$REPO_ROOT"/template/*)
            return 0
            ;;
    esac

    return 1
}

markdown_slugify() {
    printf '%s' "$1" \
        | tr '[:upper:]' '[:lower:]' \
    | sed -E "s/<[^>]+>//g; s/&amp;/ and /g; s/&/ and /g; s#[/\\]# #g; s/[^a-z0-9 _-]/ /g; s/[[:space:]]+/-/g; s/-+/-/g; s/^-+//; s/-+$//"
}

markdown_anchor_exists() {
    local target_file="$1"
    local fragment="$2"
    local heading
    local slug

    while IFS= read -r heading; do
        slug=$(markdown_slugify "$heading")
        if [ "$slug" = "$fragment" ]; then
            return 0
        fi
    done <<EOF
$(sed -nE 's/^#{1,6}[[:space:]]+(.+)$/\1/p' "$target_file")
EOF

    return 1
}

resolve_link_target_path() {
    local source_file="$1"
    local target_path="$2"
    local source_dir

    source_dir="$(dirname "$source_file")"

    if [[ "$target_path" = /* ]]; then
        printf '%s\n' "$REPO_ROOT$target_path"
    else
        printf '%s\n' "$source_dir/$target_path"
    fi
}

validate_markdown_link_target() {
    local source_file="$1"
    local line_no="$2"
    local target="$3"
    local path_part="$target"
    local fragment=""
    local resolved_path

    case "$target" in
        http://*|https://*|mailto:*|tel:)
            return
            ;;
    esac

    if [[ "$target" = *#* ]]; then
        path_part="${target%%#*}"
        fragment="${target#*#}"
    fi

    if [ -z "$path_part" ]; then
        resolved_path="$source_file"
    else
        resolved_path="$(resolve_link_target_path "$source_file" "$path_part")"
    fi

    if [ ! -e "$resolved_path" ]; then
        echo "  FAIL: Broken markdown target '$target' in $source_file:$line_no"
        ERRORS=$((ERRORS + 1))
        return
    fi

    if [ -n "$fragment" ] && [[ "$resolved_path" = *.md ]]; then
        if ! markdown_anchor_exists "$resolved_path" "$fragment"; then
            echo "  FAIL: Broken markdown anchor '$target' in $source_file:$line_no"
            ERRORS=$((ERRORS + 1))
        fi
    fi
}

validate_markdown_links_in_file() {
    local source_file="$1"
    local target
    local line_no

    while IFS=$'\t' read -r line_no target; do
        validate_markdown_link_target "$source_file" "$line_no" "$target"
    done < <(
        perl -ne 'while (/\[[^\]\[]+\]\(([^)]+)\)/g) { print $. . "\t" . $1 . "\n"; }' "$source_file"
    )
}

collect_urls_from_file() {
    local source_file="$1"
    local output_file="$2"
    local url

    while IFS= read -r url; do
        while :; do
            case "$url" in
                *\"|*\'|*\`|*\)|*,|*.)
                    url="${url%?}"
                    ;;
                *)
                    break
                    ;;
            esac
        done

        case "$url" in
            "")
                ;;
            http://localhost*|http://127.0.0.1*|http://proxy:port*|https://proxy:port*)
                ;;
            *)
                printf '%s\n' "$url" >> "$output_file"
                ;;
        esac
    done < <(
        perl -ne 'while (/(https?:\/\/[^\s"\)]+)/g) { print $1 . "\n"; }' "$source_file"
    )
}

validate_unique_urls() {
    local urls_file="$1"
    local failures_file
    local temp_urls_file
    local url_count
    local failed_count

    if [ ! -s "$urls_file" ]; then
        echo "  OK: No external URLs to validate"
        return
    fi

    temp_urls_file="$(mktemp)"
    failures_file="$(mktemp)"
    trap 'rm -f "$temp_urls_file" "$failures_file"' RETURN

    sort -u "$urls_file" > "$temp_urls_file"
    url_count=$(wc -l < "$temp_urls_file" | tr -d ' ')

    echo "  INFO: Validating $url_count unique external URL(s) with $URL_CHECK_JOBS parallel job(s), connect-timeout ${URL_CONNECT_TIMEOUT}s, max-time ${URL_MAX_TIME}s"

    tr '\n' '\0' < "$temp_urls_file" | xargs -0 -P "$URL_CHECK_JOBS" -n 1 sh -c '
        connect_timeout="$1"
        max_time="$2"
        url="$3"

        code=$(curl --head --location --silent --show-error --output /dev/null --write-out "%{http_code}" --connect-timeout "$connect_timeout" --max-time "$max_time" "$url" 2>/dev/null || true)

        if [ -z "$code" ] || [ "$code" = "000" ]; then
            printf "%s\n" "$url"
            exit 0
        fi

        case "$url" in
            https://api.*|https://auth.*|https://mainnet.base.org*|https://api.mainnet-beta.solana.com*|https://emblemvault.ai*|https://emblemvault.dev*|https://*.rpc.*)
                if [ "$code" -ge 500 ]; then
                    printf "%s\n" "$url"
                fi
                ;;
            *)
                if [ "$code" -lt 200 ] || [ "$code" -ge 400 ]; then
                    case "$code" in
                        401|403|405)
                            ;;
                        *)
                            printf "%s\n" "$url"
                            ;;
                    esac
                fi
                ;;
        esac
    ' _ "$URL_CONNECT_TIMEOUT" "$URL_MAX_TIME" > "$failures_file"

    failed_count=$(grep -c '.' "$failures_file" 2>/dev/null || true)
    if [ "$failed_count" -gt 0 ]; then
        while IFS= read -r failed_url; do
            echo "  FAIL: Unreachable or invalid URL '$failed_url'"
            ERRORS=$((ERRORS + 1))
        done < "$failures_file"
    else
        echo "  OK: Validated $url_count unique external URL(s)"
    fi

    rm -f "$temp_urls_file" "$failures_file"
    trap - RETURN
}

build_repository_doc_roots() {
    if [ -n "$TARGET_SKILL" ]; then
        printf '%s\n' "$target_skill_dir"
    else
        printf '%s\n' "$REPO_ROOT"
    fi
}

validate_repository_links_and_urls() {
    local file_path
    local search_root
    local urls_file
    local root_count=0
    local file_count=0

    echo ""
    echo "--- repository-docs ---"

    urls_file="$(mktemp)"
    trap 'rm -f "$urls_file"' RETURN

    while IFS= read -r search_root; do
        root_count=$((root_count + 1))
        echo "  INFO: Scanning markdown docs under $search_root"

        while IFS= read -r -d '' file_path; do
            echo "  INFO: file_path $file_path"
            if is_validation_exempt_file "$file_path"; then
                continue
            fi

            file_count=$((file_count + 1))

            validate_markdown_links_in_file "$file_path"
            collect_urls_from_file "$file_path" "$urls_file"
        done < <(find "$search_root" \
            -path "$REPO_ROOT/.git" -prune -o \
            -path "$REPO_ROOT/template" -prune -o \
            -type f -name '*.md' -print0)
    done <<EOF
$(build_repository_doc_roots)
EOF

    echo "  INFO: Scanned $file_count markdown file(s) across $root_count root(s)"

    validate_unique_urls "$urls_file"

    echo "  OK: Markdown target and URL validation completed"

    rm -f "$urls_file"
    trap - RETURN
}

usage() {
    cat <<EOF
Usage:
    bash utils/validation/validate-skills.sh
    bash utils/validation/validate-skills.sh --skill <name-or-path>
    bash utils/validation/validate-skills.sh --skills-dir <path>

Options:
    --strict            Deprecated no-op; official agentskills validation is always spec-compatible
  --skill <value>     Validate only one skill (name under skills/ or directory path)
  --skills-dir <path> Override the skills directory (default: skills)
  -h, --help          Show this help
EOF
}

require_agentskills_cli() {
        if command -v agentskills >/dev/null 2>&1; then
                return 0
        fi

        echo "ERROR: Missing official Agent Skills validator 'agentskills'"
        echo "Install it with one of:"
        echo "  pip install skills-ref"
        echo "  python -m pip install skills-ref"
        exit 2
}

while [ $# -gt 0 ]; do
    case "$1" in
        --strict)
            STRICT_FLAG_SEEN=1
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

validate_frontmatter_is_valid_yaml() {
    local frontmatter="$1"

    if ! command -v ruby >/dev/null 2>&1; then
        echo "  INFO: Skipping YAML parse validation (ruby not available)"
        return
    fi

    if printf '%s\n' "$frontmatter" | ruby -e 'require "yaml"; YAML.safe_load(ARGF.read, permitted_classes: [], aliases: false)' >/dev/null 2>&1; then
        echo "  OK: Frontmatter is valid YAML"
    else
        echo "  FAIL: Frontmatter is not valid YAML"
        ERRORS=$((ERRORS + 1))
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

validate_allowed_tools_format() {
    if [ "$STRICT_MODE" -eq 0 ]; then
        echo "  INFO: Skipping strict allowed-tools format checks (permissive mode)"
        return
    fi

    local frontmatter="$1"
    local allowed_tools_value
    local token
    local invalid_token=""

    allowed_tools_value=$(extract_frontmatter_field_text "$frontmatter" "allowed-tools")

    if [ -z "$allowed_tools_value" ]; then
        return
    fi

    for token in $allowed_tools_value; do
        if ! echo "$token" | grep -qE '^[A-Za-z0-9_.:-]+(\([^[:space:]()]+\))?$'; then
            invalid_token="$token"
            break
        fi
    done

    if [ -n "$invalid_token" ]; then
        echo "  FAIL: allowed-tools must be a space-delimited list of tool tokens; invalid token '$invalid_token'"
        ERRORS=$((ERRORS + 1))
    else
        echo "  OK: allowed-tools uses space-delimited tool tokens"
    fi
}

validate_reserved_fields_not_nested_in_metadata() {
    local frontmatter="$1"
    local reserved_field
    local found_nested=0

    for reserved_field in "name" "description" "license" "compatibility" "allowed-tools"; do
        if echo "$frontmatter" | grep -qE "^  ${reserved_field}:"; then
            echo "  FAIL: Reserved field '${reserved_field}' must be top-level, not nested under metadata"
            ERRORS=$((ERRORS + 1))
            found_nested=1
        fi
    done

    if [ "$found_nested" -eq 0 ]; then
        echo "  OK: Reserved top-level fields are not nested under metadata"
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

    echo "  INFO: Running official validator"
    if ! agentskills validate "$skill_dir"; then
        ERRORS=$((ERRORS + 1))
        return
    fi

    frontmatter=$(sed -n '2,/^---$/p' "$skill_file" | sed '$d')

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

require_agentskills_cli

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
echo "Mode: official skills-ref validator + repository checks"
if [ "$STRICT_FLAG_SEEN" -eq 1 ]; then
    echo "INFO: --strict is deprecated; validation is already spec-compatible by default"
fi

if [ "${#skill_dirs[@]}" -eq 0 ]; then
    echo "ERROR: No skill directories found"
    exit 2
fi

for skill_dir in "${skill_dirs[@]}"; do
    validate_skill_dir "$skill_dir"
done

validate_repository_links_and_urls

echo ""
echo "========================================"
if [ "$ERRORS" -gt 0 ]; then
    echo "RESULT: $ERRORS error(s) found"
    exit 1
else
    echo "RESULT: All skills valid"
    exit 0
fi
