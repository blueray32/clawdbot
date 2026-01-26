---
description: "Generate execution report template for completed implementation"
argument-hint: [feature-name]
---

# Generate Execution Report

## Feature: $ARGUMENTS

## Purpose

Create a structured execution report documenting what was implemented vs planned, capturing divergences and their justifications.

## Process

### 1. Locate the Plan

Find the corresponding plan file:
```bash
ls -la .agents/plans/*$ARGUMENTS* 2>/dev/null || ls -la .agents/plans/
```

If no plan exists, note this in the report as "Ad-hoc implementation without plan".

### 2. Analyze Implementation

Compare plan to actual implementation:

**For each planned file, check if it exists:**
```bash
# List files that should have been created
# Check git status for recent changes
git diff --name-only HEAD~5
git status --short
```

### 3. Calculate Adherence

```
Adherence = (files created as planned + files modified as planned) / total planned files × 100
```

### 4. Generate Report

Create file: `.agents/execution-reports/$ARGUMENTS.md`

## Report Template

```markdown
# Execution Report: {Feature Name}

**Date**: {YYYY-MM-DD}
**Plan file**: `.agents/plans/{plan-name}.md` or "No plan - ad-hoc implementation"
**Status**: Complete | Partial | Blocked

---

## Plan Adherence

| Metric | Planned | Actual | Notes |
|--------|---------|--------|-------|
| Files to create | X | Y | |
| Files to modify | X | Y | |
| Tests to write | X | Y | |
| **Adherence** | - | **Z%** | |

---

## Files Created

| File | Planned | Status | Notes |
|------|---------|--------|-------|
| `path/to/file.ts` | ✓ | ✅ Created | |
| `path/to/other.ts` | ✓ | ❌ Skipped | Reason |

## Files Modified

| File | Planned | Status | Notes |
|------|---------|--------|-------|
| `path/to/existing.ts` | ✓ | ✅ Modified | |

---

## Divergences

### Divergence 1: {Short Title}

| Aspect | Detail |
|--------|--------|
| **Planned** | What the plan specified |
| **Actual** | What was implemented |
| **Reason** | Why the change was necessary |
| **Classification** | Good ✅ (justified) or Bad ❌ (problematic) |
| **Impact** | Effect on feature/architecture |

### Divergence 2: {Short Title}
...

---

## Validation Results

### Type Checking
```bash
npm run type-check
# Output:
```

### Tests
```bash
npm test
# Output:
```

### Build
```bash
npm run build
# Output:
```

---

## Skipped Items

| Item | Reason | Follow-up Required |
|------|--------|-------------------|
| {feature/file} | {why skipped} | Yes/No |

---

## Technical Debt Created

| Debt | Description | Priority |
|------|-------------|----------|
| Missing tests | {description} | P1/P2/P3 |
| Hardcoded values | {description} | P1/P2/P3 |

---

## Recommendations

### Immediate
- [ ] {action needed now}

### Follow-up
- [ ] {action for next sprint}

### Process Improvements
- [ ] {suggestion for planning/execution process}

---

## Summary

{2-3 sentence summary of what was delivered, key divergences, and overall assessment}
```

## Output

After generating the report:

1. Confirm file created at `.agents/execution-reports/{feature-name}.md`
2. Report adherence percentage
3. List key divergences
4. Note any follow-up actions required

## Quality Checklist

- [ ] All planned files accounted for (created or documented as skipped)
- [ ] All divergences have documented reasons
- [ ] Validation commands were run and results captured
- [ ] Technical debt is documented with priority
- [ ] Recommendations are actionable
