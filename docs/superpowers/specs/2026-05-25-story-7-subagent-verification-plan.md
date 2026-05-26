# Story 7 Subagent Acceptance & Verification Plan

This document defines the acceptance criteria for subagents working on Story 7 (Multi-School Foundation).

## 1. Role Separation (Mandatory)
- **Domain Subagent**: Responsible for logic and metadata in `lib/domain/`.
- **UI Subagent**: Responsible for widgets and views in `lib/presentation/`.
- **QA Subagent**: Responsible for cross-functional regression and visual evidence.

## 2. Acceptance Criteria (AC)

### Task 35: School Catalog (Domain) - DONE
- **Logic**: Must provide all 8 schools in the defined preference order.
- **TDD**: 100% test coverage in `test/domain/schools/school_catalog_test.dart`.
- **Trace ID**: `XUAN-ZT35`.

### Task 36-37: UI Widgets (UI Specialist Needed)
- **Visuals**: Must use the project's standard styling. Horizontal scrolling must be smooth.
- **Evidence**: Provide screenshots or Playwright recordings of the `SchoolSliderBar` in action.
- **Trace ID**: `XUAN-ZT36` / `XUAN-ZT37`.

### Task 38: integration (UI Specialist Needed)
- **Rule**: Switching schools must NOT trigger a re-calculation of the divination board.
- **Evidence**: Log showing state change without re-divination.
- **Trace ID**: `XUAN-ZT38`.

### Task 40: Regression & Verification (QA) - DONE
- **Rule**: All 10 existing core tests must pass.
- **Bug Fix**: Fixed pre-existing `GuiRen` mapping ('阴' -> `TAI_YIN`).
- **Trace ID**: `XUAN-ZT40`.

## 3. General Quality Gates
1. **No `xuan_` prefix** in any identifiers.
2. **Atomic Commits**: One commit per ZenTao task ID.
3. **Audit First**: All changes must be verified by `flutter test` before submission.
