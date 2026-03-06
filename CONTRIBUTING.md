# Contributing to EmblemAI Agent Skills

## Adding a New Skill

1. Copy the template:
   ```bash
   cp -r template/ skills/your-skill-name/
   ```

2. Rename and edit `SKILL.md`:
   - Set `name` to match your directory name (lowercase, hyphens only)
   - Write a keyword-rich `description` (what it does + when to use it)
   - Add `license`, `compatibility`, and `metadata` fields
   - Keep SKILL.md under 500 lines (recommended)

3. Add supporting files:
   - `references/` — detailed documentation split by topic
   - `scripts/` — executable helpers (bash, python, etc.)
   - `assets/` — config templates, schemas
   - `examples/` — sample inputs/outputs

4. Validate:
   ```bash
   bash validate-all.sh
   ```

   Validate a single skill:
   ```bash
   bash validate-skill.sh your-skill-name
   ```

   Strict validation (agentskills.io-only frontmatter):
   ```bash
   bash validate-all.sh --strict
   ```

5. Open a PR against `main`.

## Skill Structure

```
skills/your-skill-name/
├── SKILL.md              # Required — entry point (recommended <500 lines)
├── references/           # Optional — detailed docs
│   └── *.md
├── scripts/              # Optional — executable code
│   └── *.sh, *.py, *.js
├── assets/               # Optional — templates, schemas
│   └── *.env, *.json
└── examples/             # Optional — sample outputs
    └── *.md
```

## SKILL.md Requirements

### Required Frontmatter
- `name` — 1-64 chars, lowercase + hyphens, matches directory name
- `description` — What the skill does + when to trigger it

### Recommended Frontmatter
- `license` — e.g., `MIT`
- `compatibility` — environment requirements
- `metadata` — author, version, homepage

### Body Guidelines
- Use imperative voice: "Parse the file" not "You should parse"
- Use third person in descriptions: "Processes files" not "I process"
- Include a Quick Start section at the top
- Link to reference files with bullet summaries
- Provide input/output examples

## Validation

Every PR triggers `validate-all.sh` via GitHub Actions. It checks:
- SKILL.md exists with valid frontmatter
- `name` matches directory name
- Line count recommendation (<500) with warning output
- Trailing newlines present
- Required fields present

## Code of Conduct

Be respectful. Write clear documentation. Test your skills before submitting.
