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

## D3: Legacy Page Migration (DONE)

- [x] D3a: Add LoadYuDingDataUseCase to DaLiuRenViewModel (field, getter, cached loadYuDingData method)
- [x] D3b: Migrate my_home_page.dart — replace DaLiuRenOfficialDataRepository with ViewModel.loadYuDingData()
- [x] D3b: Migrate new_home_page.dart — replace DaLiuRenOfficialDataRepository with ViewModel.loadYuDingData()
- [x] D3.6: Update tasks.md
- [x] D3.7: Commit

---

## D3: Domain Service Cleanup (DONE)
- [x] D3.1: Remove `package:flutter/material.dart` import from nine_zong_men_calculator_v1_2.dart
- [x] D3.2: Verify repository reverse-dep scan passes (0 violations)
- [x] D3.3: Run full test suite, all green

---

## D4: Row-Level Equivalence Freeze + Legacy Deletion + DI Restriction (DONE)
- [x] D4.1: Verify remaining DaLiuRenOfficialDataRepository ref in pages/ — 0 matches (clean)
- [x] D4.2: DI Restriction — removed global Provider<DaLiuRenOfficialDataRepository>.value()
- [x] D4.3: Legacy page analysis — MyHomePage used in /daliuren/old + /taiyishenshu/primary, SKIP deletion
- [x] D4.4: Run 4 boundary scans — all 0 violations
- [x] D4.5: Run flutter test — 91 pass, 1 pre-existing fail (no regressions)
- [x] D4.6: Update tasks.md
- [x] D4.7: Commit
