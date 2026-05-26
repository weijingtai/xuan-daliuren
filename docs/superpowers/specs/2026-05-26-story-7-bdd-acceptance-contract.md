# Story 7 BDD Acceptance Contract

> ZenTao Story: #7 大六壬多流派架构重构
> ZenTao Task: #51 Story#7 BDD Acceptance Contract：多流派用户行为验收合同
> Date: 2026-05-26
> Role: BDD Acceptance
> Validation layer: Playwright / gStack product-visible evidence

## Source

- Requirement: Story #7 requires a multi-school architecture foundation without regressing the existing Yuding path.
- Existing delivery tasks: #35 School Catalog, #36 School Slider Bar, #37 Explanation Panel States, #38 客盘 Page Integration, #39 DevPage Verification Entry, #40 Regression and Verification.
- User path: user opens 大六壬, completes or views a pan, sees the multi-school selector, and changes explanation school without recalculating the pan.

## Scope

This contract verifies observable user behavior. It does not prove all eight schools have production data, does not validate the full Bifa corpus, and does not replace the existing Flutter unit/widget tests.

## Stable Locators

| Target | Locator requirement |
| --- | --- |
| Formal page school slider | `Key('divination_school_slider_bar')` |
| Formal page selected panel | `ValueKey('school_explanation_panel_<schoolId>')` |
| DevPage multi-school section | `Key('dev_multi_school_section')` |
| DevPage school slider | `Key('dev_school_slider_bar')` |
| DevPage explanation panel | `Key('dev_school_explanation_panel')` |
| School chip | `Key('school_slider_chip_<schoolId>')` |
| Planned roadmap | `Key('planned_roadmap_<schoolId>')` |
| Empty panel | `Key('panel_empty')` |
| Error panel | `Key('panel_error')` |

Selectors may be reached through Flutter semantics, widget keys exposed to the test driver, or visible text when Playwright is running against Web output.

## Positive Scenarios

```gherkin
Scenario: Formal page defaults to Yuding after a pan is visible
  Given the user has opened the formal Da Liu Ren page
  And a divination result is visible
  When the multi-school section is rendered
  Then the school slider is visible
  And the Yuding school is selected
  And the selected panel key is school_explanation_panel_yuding
```

```gherkin
Scenario: User can switch from Yuding to Bifa planned explanation
  Given the formal page multi-school section is visible
  And Yuding is selected
  When the user selects the Bifa chip
  Then the Bifa chip becomes selected
  And the selected panel key becomes school_explanation_panel_bifa
  And the planned roadmap for bifa is visible
  And the panel communicates that Bifa is still being organized
```

```gherkin
Scenario: Switching schools does not recalculate the pan
  Given the formal page shows an existing pan
  And the current pan text or calculation-visible region has been captured
  When the user switches from Yuding to Bifa
  And the user switches back to Yuding
  Then the pan-visible region remains unchanged
  And no loading state for a new divination calculation appears
```

```gherkin
Scenario: DevPage verifies the unified entry display path
  Given the user opens /daliuren/dev
  When the user opens the multi-school verification section
  Then dev_school_slider_bar is visible
  And dev_school_explanation_panel is visible
  And selecting Yuding shows the sample SchoolEntryDisplayWidget content
```

## Negative Scenarios

```gherkin
Scenario: Unknown school does not crash the explanation panel
  Given the explanation panel receives an unknown selectedSchoolId
  When the panel renders
  Then an error or diagnostic state is visible
  And the app does not show a Flutter exception page
```

```gherkin
Scenario: Planned school does not show stale Yuding entry content
  Given Yuding content is visible in the explanation panel
  When the user selects Bifa
  Then Yuding-specific entry sections are no longer visible in the selected explanation panel
  And the Bifa planned roadmap is visible
```

```gherkin
Scenario: Empty result state is distinct from load failure
  Given the explanation panel has no matched entries for a valid school
  When the panel renders
  Then panel_empty is visible
  And panel_error is not visible
```

## Boundary Scenarios

```gherkin
Scenario: All eight planned schools fit the selector without overflow
  Given the school catalog contains the eight planned schools
  When the school slider is rendered on a mobile-width viewport
  Then every school chip can be reached by horizontal scrolling
  And no chip text overlaps neighboring chips
```

```gherkin
Scenario: Selected and planned states are exposed to accessibility semantics
  Given the school slider is visible
  When Yuding is selected
  Then the Yuding chip exposes selected semantics
  And planned school chips expose a label that includes 正在整理中
```

```gherkin
Scenario: Reduced motion does not block school switching
  Given the user environment disables animations
  When the user switches from Yuding to Bifa
  Then the explanation panel changes immediately or without animation delay
  And the final selected state is still observable
```

## Assertion Mapping

| Scenario | Then | Real assertion or observable result | Executable spec |
| --- | --- | --- | --- |
| Formal page defaults to Yuding | school slider visible | Find `divination_school_slider_bar` or visible school selector text | Playwright/gStack, Flutter integration |
| Formal page defaults to Yuding | Yuding selected | `school_slider_chip_yuding` has selected semantics or selected visual state | Existing widget test plus Playwright |
| Switch to Bifa | selected panel key changes | `school_explanation_panel_bifa` appears; previous selected panel disappears after switch | Playwright/gStack |
| Switch to Bifa | planned state visible | `planned_roadmap_bifa` visible; text/semantics contains 正在整理中 | Existing widget test plus Playwright |
| No recalculation | pan unchanged | Capture pan-visible text before and after school switch; compare exact visible value set | Playwright/gStack |
| DevPage path | unified panel visible | `dev_school_slider_bar` and `dev_school_explanation_panel` visible | Playwright/gStack |
| Unknown school | no crash | No Flutter exception text; `panel_error` or diagnostic visible | Widget/integration |
| Empty state | distinct state | `panel_empty` visible and `panel_error` absent | Widget/integration |
| Mobile selector | no overflow | Screenshot shows all chips reachable by scroll and no overlap | gStack screenshot review |

## Recommended Coverage

- Playwright/gStack: formal page happy path, school switching, no recalculation, mobile selector screenshot, DevPage verification path.
- Flutter widget tests: selected semantics, planned semantics, empty/error panel distinctions, panel state switching.
- Regression command: `flutter test`.

## Not Done Conditions

- Any Then lacks an executable assertion or visible observation.
- Bifa planned state can only be checked by reading implementation code.
- School switching triggers pan recalculation or changes pan-visible output.
- Planned, empty, and error states collapse into the same message.
- Evidence claims browser validation without screenshot, locator result, or run log.

## Open Questions For Playwright Runner

- Exact Web start command and port should be supplied by the runner if not already standardized.
- If Flutter Web does not expose keys directly to DOM, Playwright should use visible text and screenshot evidence, while Flutter integration tests cover widget-key assertions.
