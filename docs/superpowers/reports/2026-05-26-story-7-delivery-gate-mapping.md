# Story 7 Delivery Gate Mapping

> ZenTao Task: #53 Story#7 Delivery Gate Mapping：已完成任务到 BDD 门禁映射
> Date: 2026-05-26
> Role: QA Delivery Auditor

## Gate Decision Model

Story #7 can move from "tasks done" to "ready for human acceptance" only when implementation evidence, BDD assertions, test results, and gStack/Playwright evidence agree. A completed ZenTao task is input evidence, not acceptance by itself.

## Task To Acceptance Mapping

| ZenTao task | Claimed scope | BDD / evidence coverage required | Gate status |
| --- | --- | --- | --- |
| #35 School Catalog | Eight school catalog entries and ordering | G7-PW-03 mobile selector reaches all planned schools; widget tests cover catalog-driven chips | Needs Playwright evidence |
| #36 School Slider Bar | Horizontal school selector UI | G7-PW-01, G7-PW-02, G7-PW-03; selected and planned semantics assertions | Needs screenshots |
| #37 Explanation Panel States | available/planned/empty/error panel states | BDD negative and boundary scenarios; `planned_roadmap_bifa`, `panel_empty`, `panel_error` assertions | Needs browser-visible evidence |
| #38 客盘 Page Integration | Formal page integration and no recalculation on switch | BDD no-recalculation scenario; pan-visible region unchanged after switching | Critical gate, needs Playwright |
| #39 DevPage Verification Entry | Deterministic verification entry | G7-PW-04 and G7-PW-05 screenshots | Needs DevPage evidence |
| #40 Regression and Verification | Existing tests pass | `flutter test` or approved split commands; focused failure summary when failing | Needs current rerun before acceptance |
| #51 BDD Contract | User behavior scenarios | This document plus BDD contract path | In progress until ZenTao completion evidence is posted |
| #52 gStack/Playwright Matrix | Browser evidence plan | Matrix path and later browser artifacts | In progress until evidence exists |
| #53 Delivery Gate Mapping | Gate mapping | This document and final evidence links | In progress until completion evidence is posted |

## Required PASS Conditions

- `flutter test` passes, or any skipped split run is explicitly accepted with rationale.
- Formal page shows the school selector after a pan result.
- Default selected school is Yuding.
- Bifa or another planned school can be selected without app crash.
- Planned school state is visibly distinct from available Yuding content.
- School switching does not recalculate or mutate the pan-visible result.
- Mobile viewport does not show incoherent overlap in the school selector.
- DevPage route demonstrates the unified component path with deterministic sample content.

## Immediate NOT PASSED Conditions

- Any school switch triggers a new divination calculation.
- Yuding formal display regresses or is replaced by the generic sample widget.
- Planned, empty, and error states are indistinguishable to the user.
- Browser evidence is claimed but no screenshot/log exists.
- Flutter tests fail in a relevant school UI, registry, or core calculation area.
- A selector gap makes Playwright unable to locate critical behavior and no compensating Flutter integration assertion exists.

## Evidence Package Checklist

| Evidence | Owner | Required before human acceptance |
| --- | --- | --- |
| BDD contract | #51 / Codex | yes |
| gStack/Playwright matrix | #52 / Codex | yes |
| Delivery gate mapping | #53 / Codex | yes |
| Current `flutter test` result | Tester | yes |
| Desktop screenshots | gStack/Playwright runner | yes |
| Mobile screenshots | gStack/Playwright runner | yes |
| Pan stability observation | gStack/Playwright runner | yes |
| ZenTao bug links for failures | QA / runner | if any failure occurs |

## Current Known Gaps

- Browser evidence has not been executed in this task; the user plans to run Playwright later.
- Web start command and URL are not fixed in these documents and should be supplied by the Playwright runner.
- The formal page relies on actual pan state; if the runner cannot deterministically create one, acceptance must use an agreed seeded route or DevPage-only evidence must be marked partial.

## Gate Output Format For Later Acceptance

Use one of:

- `PASS`: all required PASS conditions met and evidence package complete.
- `NOT PASSED`: product behavior or tests fail; include ZenTao Bug IDs.
- `BLOCKED_ENVIRONMENT`: app or browser cannot start; include command and log.
- `PARTIAL`: DevPage evidence exists but formal user path or pan-stability evidence is missing.
