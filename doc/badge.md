# BAIF Certification Badge

This document explains how to add a "BAIF Certified" badge to your project's README.

## How It Works

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  GitHub Action  │────►│ certification-   │────►│  shields.io     │
│  updates JSON   │     │ badge.json       │     │  renders badge  │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                                          │
                                                          ▼
                                                 ┌─────────────────┐
                                                 │  README.md      │
                                                 │  displays badge │
                                                 └─────────────────┘
```

## Setup

### 1. Add Badge JSON to Your Repo

Create `docs/certification-badge.json`:

```json
{
  "schemaVersion": 1,
  "label": "BAIF Certified",
  "message": "0/0 verified",
  "color": "gray",
  "namedLogo": "ethereum",
  "logoColor": "white"
}
```

### 2. Add Badge to README

Add this to your `README.md`:

```markdown
[![BAIF Certified](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/YOUR_ORG/YOUR_REPO/main/docs/certification-badge.json)](https://github.com/YOUR_ORG/YOUR_REPO/blob/main/docs/certifications.json)
```

Replace `YOUR_ORG/YOUR_REPO` with your repository path.

### 3. Update Badge in CI

In your certification workflow, add a step to update the badge:

```yaml
- name: Update certification badge
  run: |
    VERIFIED=${{ steps.verify.outputs.verified-count }}
    TOTAL=${{ steps.verify.outputs.total-functions }}
    
    # Determine color
    PERCENT=$((VERIFIED * 100 / TOTAL))
    if [ "$PERCENT" -ge 90 ]; then COLOR="brightgreen"
    elif [ "$PERCENT" -ge 70 ]; then COLOR="green"
    elif [ "$PERCENT" -ge 50 ]; then COLOR="yellow"
    else COLOR="orange"
    fi
    
    # Update badge JSON
    cat > docs/certification-badge.json << EOF
    {
      "schemaVersion": 1,
      "label": "BAIF Certified",
      "message": "${VERIFIED}/${TOTAL} verified",
      "color": "${COLOR}",
      "namedLogo": "ethereum",
      "logoColor": "white"
    }
    EOF

- name: Commit badge
  run: |
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add docs/certification-badge.json
    git diff --cached --quiet || git commit -m "chore: update badge [skip ci]"
    git push
```

## Badge Colors

| Verification % | Color |
|---------------|-------|
| ≥ 90% | ![brightgreen](https://img.shields.io/badge/-brightgreen-brightgreen) |
| ≥ 70% | ![green](https://img.shields.io/badge/-green-green) |
| ≥ 50% | ![yellow](https://img.shields.io/badge/-yellow-yellow) |
| < 50% | ![orange](https://img.shields.io/badge/-orange-orange) |

## Example Badges

**High verification:**
```json
{"schemaVersion":1,"label":"BAIF Certified","message":"48/50 verified","color":"brightgreen","namedLogo":"ethereum"}
```
![Example](https://img.shields.io/badge/BAIF_Certified-48%2F50_verified-brightgreen?logo=ethereum&logoColor=white)

**Partial verification:**
```json
{"schemaVersion":1,"label":"BAIF Certified","message":"35/50 verified","color":"green","namedLogo":"ethereum"}
```
![Example](https://img.shields.io/badge/BAIF_Certified-35%2F50_verified-green?logo=ethereum&logoColor=white)

## Linking to Certification History

The badge can link to your `docs/certifications.json` which contains the full certification history:

```markdown
[![BAIF Certified](https://img.shields.io/endpoint?url=...)](https://github.com/ORG/REPO/blob/main/docs/certifications.json)
```

Users can click the badge to see:
- All past certifications
- Ethereum transaction hashes
- Etherscan links for verification

## Caching Note

GitHub raw URLs are cached for ~5 minutes. After updating the badge JSON, it may take a few minutes for the new badge to appear.
