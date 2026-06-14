# Decouple DaLiuRen UI-MVVM-UseCase: Task Tracker

**Change:** decouple-daliuren-ui-mvvm-usecase
**Branch:** feature/decouple-ui-mvvm-dpre

---

## DPRE: Pre-Migration Setup (DONE)

- [x] DPRE-1: Create openspec change directory
- [x] DPRE-2: Define boundary scan patterns in design.md
- [x] DPRE-3: Create import_boundary_test.dart
- [x] DPRE-4: Update scan scope to domain/services/** (not just calculators)
- [x] DPRE-5: Verify boundary test runs and fails on existing violations

---

## D0: Baseline & Boundary Freeze (DONE)

- [x] D0.1: Create baseline-manifest.md
- [x] D0.2: Record route list (/daliuren, /daliuren/old, /daliuren/new)
- [x] D0.3: Run and record dart analyzer (0 errors, 43 warnings, 207 info)
- [x] D0.4: Run and record flutter test (50 passed, 1 expected failure)
- [x] D0.5: Run 4 boundary scans and record outputs
- [x] D0.6: Record baseline allow-list (10 violations: 9 UI, 1 domain service)
- [x] D0.7: Create golden fixture inventory (6 fixtures + expected stub)
- [x] D0.8: Verify negative dependency test exists (import_boundary_test.dart)
- [x] D0.9: Update tasks.md

---

## D1: ViewModel UseCase Migration (DONE)

- [x] D1.1: Replace direct repository calls in DaLiuRenViewModel with UseCase calls
- [x] D1.2: Wire UseCases into DI container
- [x] D1.3: Verify ViewModel deny-list scan still passes
- [x] D1.4: Run all tests, capture golden outputs

---

## D2: Move Business Input State Into ViewModel (DONE)

- [x] D2.1: Define DaLiuRenInputState (immutable model with copyWith, validationErrors, isReadyToSubmit)
- [x] D2.2: Add ViewModel intent methods (updateYearJiaZi, submitManualDivination, clearInput, etc.)
- [x] D2.3: Create input state tests (20 state tests + 21 intent tests = 41 new tests)
- [x] D2.4: Update tasks.md
- [x] D2.5: Run tests and commit (58 tests passed in test/presentation/)

---

## D3: Domain Service Cleanup (TODO)

- [ ] D3.1: Remove `package:flutter/material.dart` import from nine_zong_men_calculator_v1_2.dart
- [ ] D3.2: Verify repository reverse-dep scan passes (0 violations)
- [ ] D3.3: Run full test suite, all green

---

## D4: Validation & Sign-off (TODO)

- [ ] D4.1: Run final dart analyze — compare with D0 baseline
- [ ] D4.2: Run final flutter test — all green, no regressions
- [ ] D4.3: Run all 4 boundary scans — 0 violations
- [ ] D4.4: Verify golden fixtures match expected outputs
- [ ] D4.5: Update baseline-manifest.md with final state
- [ ] D4.6: Final commit and PR
