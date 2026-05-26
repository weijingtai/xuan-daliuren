# Story 7 gStack / Playwright Acceptance Matrix

> ZenTao Task: #52 Story#7 gStack/Playwright Evidence Matrix：浏览器验收证据矩阵
> Date: 2026-05-26
> Purpose: provide executable product-visible evidence requirements for later Playwright acceptance.

## Evidence Rules

- Do not mark Story #7 accepted from ZenTao `done` status alone.
- Capture screenshots for desktop and mobile viewports whenever UI state, scrolling, or visual non-overlap is being accepted.
- Save the command, URL, viewport, scenario ID, result, and artifact path in the final evidence package.
- If a scenario fails because the product behavior is wrong, create a ZenTao Bug instead of completing the validation task.
- If a scenario is blocked by environment startup, report `BLOCKED_ENVIRONMENT` and include the failed command.

## Entry Points

| Entry | Purpose | Required evidence |
| --- | --- | --- |
| Formal Da Liu Ren page | Validate real user path after pan display | screenshot before switch, screenshot after switch, pan stability observation |
| `/daliuren/dev` | Validate unified component path with deterministic sample data | screenshot of `dev_multi_school_section`, screenshot after switching planned school |
| Widget/integration layer | Cover key/semantics assertions when Flutter Web DOM does not expose widget keys | test command output and focused assertion list |

## Playwright / gStack Flow Matrix

| ID | Viewport | Preconditions | Steps | Assertions | Evidence |
| --- | --- | --- | --- | --- | --- |
| G7-PW-01 | Desktop | App running, formal page reachable | Open formal page, reach visible pan result | School slider visible; Yuding selected; no exception page | screenshot: formal-yuding-default |
| G7-PW-02 | Desktop | G7-PW-01 passed | Capture pan-visible region, click Bifa, click Yuding | Panel changes to Bifa then Yuding; captured pan text remains unchanged | screenshots: bifa-planned, yuding-return; pan diff note |
| G7-PW-03 | Mobile | App running | Open formal page, scroll school slider horizontally | Eight planned schools reachable; chip text does not overlap | screenshot before/after horizontal scroll |
| G7-PW-04 | Desktop | DevPage route reachable | Open `/daliuren/dev`, locate multi-school section | Dev slider and explanation panel visible; Yuding sample entry shown | screenshot: dev-yuding |
| G7-PW-05 | Desktop | G7-PW-04 passed | Select Bifa on DevPage | Planned roadmap visible; Yuding sample entry absent from selected panel | screenshot: dev-bifa-planned |
| G7-PW-06 | Any | Test harness can inject/route unknown state | Render unknown selected school | Error or diagnostic state visible; no Flutter exception page | screenshot/log: unknown-school |

## Locator Strategy

Prefer this order:

1. Flutter integration or test driver key lookup for `Key(...)` and `ValueKey(...)`.
2. Playwright visible text and semantic labels.
3. Screenshot comparison for visual-only claims such as overflow and selected chip styling.

Required locator names:

- `divination_school_slider_bar`
- `school_explanation_panel_yuding`
- `school_explanation_panel_bifa`
- `school_slider_chip_yuding`
- `school_slider_chip_bifa`
- `planned_roadmap_bifa`
- `dev_multi_school_section`
- `dev_school_slider_bar`
- `dev_school_explanation_panel`

## Failure Classification

| Failure | ZenTao action |
| --- | --- |
| App cannot start | Comment on #52 as `BLOCKED_ENVIRONMENT`; include command and log |
| Selector missing but behavior visible | Comment as `SELECTOR_GAP`; add follow-up task if automation is blocked |
| UI state wrong, stale content, or exception page | Create Bug linked to Story #7 |
| School switch changes pan result | Create high-priority Bug linked to Task #38 and Story #7 |
| Screenshot shows mobile overflow/overlap | Create UI Bug linked to Task #36 |
| Planned/empty/error states indistinguishable | Create Bug linked to Task #37 |

## Minimum Evidence Package

| Artifact | Required |
| --- | --- |
| Desktop default Yuding screenshot | yes |
| Desktop Bifa planned screenshot | yes |
| Desktop return-to-Yuding screenshot | yes |
| Mobile slider screenshot | yes |
| DevPage Yuding screenshot | yes |
| DevPage Bifa screenshot | yes |
| Test command summary | yes |
| Known gaps and blocked scenarios | yes, even when empty |

## Suggested Verification Commands

```bash
flutter test test/presentation/widgets/school_slider_bar_test.dart test/presentation/widgets/school_explanation_panel_test.dart
flutter test
```

The later Playwright runner should add the project-specific Web start command and browser command. Do not infer acceptance from these Flutter tests alone; they are the assertion backing for browser-visible checks.
