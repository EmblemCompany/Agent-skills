#!/bin/bash
# scan-security.sh - Run local security scans on all skills
# Usage: bash scan-security.sh [skill-name] [--json]
#
# Requires one of:
#   - snyk-agent-scan (via uvx): Full analysis matching skills.sh scanner
#     Install: pip install snyk-agent-scan OR use uvx
#     Auth: export SNYK_TOKEN=<your-token> (free at https://app.snyk.io/account)
#   - skill-security-scan (via pip3): Static pattern analysis (no auth needed)
#     Install: pip3 install skill-security-scan
#
# Examples:
#   bash scan-security.sh                    # Scan all skills with best available scanner
#   bash scan-security.sh emblem-ai          # Scan a specific skill
#   bash scan-security.sh --json             # JSON output (snyk-agent-scan only)
#   SNYK_TOKEN=xxx bash scan-security.sh     # Full Snyk analysis

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
SKILL_NAME=""
JSON_FLAG=""

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --json) JSON_FLAG="--json" ;;
    -*) echo "Unknown option: $arg"; exit 1 ;;
    *) SKILL_NAME="$arg" ;;
  esac
done

# Determine scan targets
if [ -n "$SKILL_NAME" ]; then
  TARGETS="$SKILLS_DIR/$SKILL_NAME/SKILL.md"
  if [ ! -f "$TARGETS" ]; then
    echo "Error: Skill not found: $TARGETS"
    exit 1
  fi
else
  TARGETS="$SKILLS_DIR"
fi

echo "╔══════════════════════════════════════════════╗"
echo "║  Agent-skills Security Scanner               ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# Prefer snyk-agent-scan via uvx (same engine as skills.sh/Snyk)
if command -v uvx &>/dev/null; then
  if [ -n "$SNYK_TOKEN" ]; then
    echo "🔍 Using snyk-agent-scan (full analysis — same engine as skills.sh)"
  else
    echo "⚠️  No SNYK_TOKEN set — running in inspect/discovery mode."
    echo "   For full security analysis, get a free token at https://app.snyk.io/account"
    echo "   Then: export SNYK_TOKEN=<your-token>"
    echo ""
    echo "🔍 Using snyk-agent-scan (inspect mode)"
  fi
  echo "   Target: $TARGETS"
  echo ""
  uvx snyk-agent-scan@latest --skills "$TARGETS" $JSON_FLAG
  exit $?
fi

echo "❌ No security scanner found."
echo "   Install uv (recommended): curl -LsSf https://astral.sh/uv/install.sh | sh"
echo "   Then run: bash scan-security.sh"
echo ""
echo "   For full analysis, also set: export SNYK_TOKEN=<your-token>"
echo "   Get a free token at: https://app.snyk.io/account"
exit 1
