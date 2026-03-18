# Pre-Commit Checklist

**Run through this before any commit. Stop on first failure.**

---

## Quick Check (Every commit)

- [ ] **Tests pass** — `npm test` (or equivalent)
- [ ] **No type errors** — `npm run typecheck` (if TypeScript)
- [ ] **No secrets** — `grep -rE "(password|secret|key).*=" src/` shows nothing sensitive
- [ ] **Registry updated** — Did I add new components/functions to `docs/registry.md`?
- [ ] **Only intended files** — `git status` shows what I expect

---

## Before Feature Completion

- [ ] **Spec exists** — `docs/specs/[feature].md` with what I built
- [ ] **Spec matches reality** — What I built matches what I said I'd build
- [ ] **Tests cover the feature** — Not just "tests exist" but "tests verify this feature"
- [ ] **Edge cases handled** — Empty input, invalid input, error states
- [ ] **No TODO/FIXME left behind** — `grep -r "TODO\|FIXME" src/`

---

## Security (For anything touching auth, payments, user data)

- [ ] **Input validated** — No raw user input used directly
- [ ] **Queries parameterized** — No string concatenation in SQL
- [ ] **Auth checked** — Protected routes actually check auth
- [ ] **Errors don't leak** — Error messages don't expose internals

---

## Self-Check (Honesty)

- [ ] **Did I actually test this?** — Not just "it compiles"
- [ ] **Am I sure the files I reference exist?** — Verified against registry
- [ ] **Did I add anything that wasn't requested?** — If yes, remove it
- [ ] **Is this the simplest solution?** — If not, simplify

---

## If Something Fails

1. Fix it
2. Don't commit until fixed
3. If I can't fix it, tell the human

**Never:** Skip checks, commit anyway, hope it works

---

*This checklist exists because I make mistakes. Following it prevents most of them.*
