# Feature: [Name]

**Status:** DRAFT → APPROVED → IN PROGRESS → COMPLETE
**Created:** [YYYY-MM-DD HH:MM UTC]
**Approved:** [When human said PROCEED]
**Completed:** [When finished]

---

## 1. Overview

**What?** [One-sentence technical description]
**Why?** [Business value or user benefit]
**For whom?** [Who uses this / what system benefits]
**Success metric:** [How we know it works — quantifiable if possible]

---

## 2. Technical Approach

**Pattern:** [Reference existing pattern in codebase, or describe new one]
**Key decisions:** [Why this approach over alternatives]
**Dependencies:** [New packages, services, or infrastructure needed]
**Breaking changes:** [API changes, migrations, deprecations — or "None"]

---

## 3. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `src/path/file.ts` | Create | Core logic for X |
| `src/path/other.ts` | Modify | Add Y integration |
| `tests/path/file.test.ts` | Create | Unit tests |

---

## 4. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | [Function + condition] | [Input] | [Output] | High |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | [End-to-end flow] | [A → B → C] | [Result] | High |

### Security Tests (if applicable)
| ID | Threat | Attack | Expected defense |
|----|--------|--------|------------------|
| ST-01 | SQL injection | `' OR 1=1--` | 400 error, query not executed |
| ST-02 | XSS | `<script>alert(1)</script>` | Escaped output |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | [Edge case] | [When X happens] | [Graceful handling] |

---

## 5. Implementation Notes

*Decisions made during implementation, gotchas discovered, things to remember.*

---

## 6. Completion Record

**Status:** COMPLETE
**Date:** [YYYY-MM-DD HH:MM UTC]

### Files changed
```
src/path/file.ts         +120  -15
src/path/other.ts        +8   -2
tests/path/file.test.ts  +89  -0
```

### Test results
- Unit: X/X passing
- Integration: X/X passing
- Security: X/X passing
- Coverage: XX%

### Registry updates
- Added: [Components/functions added to registry.md]
- Modified: [Existing entries updated]

### Known issues
[Any limitations, tech debt, or follow-up work needed — or "None"]

---

**Verified by:** [Human name]
**Commit:** [hash]
