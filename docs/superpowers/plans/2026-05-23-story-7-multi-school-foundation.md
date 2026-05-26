# Story 7 Multi-School Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first-stage multi-school foundation for xuan-daliuren without completing full school data sources.

**Architecture:** Add a domain-level `SchoolCatalog` for all planned schools and keep `SchoolRegistry` for implemented providers. The客盘 result page renders a horizontally scrollable school slider after divination, with御定 using the existing formal display path and planned schools showing roadmap empty states. DevPage hosts the new unified school-entry verification path.

**Tech Stack:** Flutter, Dart, Provider, existing xuan-daliuren MVVM/Repository structure, Flutter widget/unit tests.

---

### File Structure

- Create: `lib/domain/schools/school_catalog.dart`
  - Defines `SchoolCatalogEntry`, `SchoolAvailabilityStatus`, and fixed user-preference ordering for eight schools.
- Create: `lib/presentation/widgets/school_slider_bar.dart`
  - Horizontally scrollable tab/slider bar for客盘 page.
- Create: `lib/presentation/widgets/planned_school_roadmap_widget.dart`
  - Route-map empty state for planned schools.
- Create: `lib/presentation/widgets/school_explanation_panel.dart`
  - Chooses available/planned/empty/error display behavior.
- Modify: `lib/presentation/views/widgets/divination_display_widget.dart`
  - Adds the school explanation region after stable pan display without changing起盘 flow.
- Modify: `lib/pages/dev.dart`
  - Adds DevPage section for unified school-entry component verification.
- Test: `test/domain/schools/school_catalog_test.dart`
  - Verifies catalog ordering and statuses.
- Test: `test/presentation/widgets/school_slider_bar_test.dart`
  - Verifies rendering, scrolling semantics, selection callbacks.
- Test: `test/presentation/widgets/school_explanation_panel_test.dart`
  - Verifies available/planned/empty/error state rendering.

### Task 1: School Catalog

**Files:**
- Create: `lib/domain/schools/school_catalog.dart`
- Test: `test/domain/schools/school_catalog_test.dart`

- [ ] **Step 1: Write the failing catalog test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:daliuren/domain/schools/school_catalog.dart';

void main() {
  group('SchoolCatalog', () {
    test('uses fixed user-preference order for all eight schools', () {
      expect(
        SchoolCatalog.all.map((entry) => entry.id).toList(),
        [
          'yuding',
          'bifa',
          'zhinan',
          'kejing',
          'daliuren_daquan',
          'rengui',
          'liuren_cuiyan',
          'guanlu_shenshu',
        ],
      );
    });

    test('only yuding is available in first stage', () {
      final available = SchoolCatalog.all
          .where((entry) => entry.status == SchoolAvailabilityStatus.available)
          .map((entry) => entry.id)
          .toList();

      expect(available, ['yuding']);
      expect(SchoolCatalog.byId('bifa')!.status, SchoolAvailabilityStatus.planned);
    });

    test('planned schools expose roadmap metadata', () {
      final bifa = SchoolCatalog.byId('bifa')!;

      expect(bifa.displayName, '毕法赋');
      expect(bifa.representativeBook, '《毕法赋》');
      expect(bifa.description, isNotEmpty);
      expect(bifa.tags, contains('法则'));
    });
  });
}
```

- [ ] **Step 2: Run the failing test**

Run: `flutter test test/domain/schools/school_catalog_test.dart`

Expected: FAIL because `school_catalog.dart` does not exist.

- [ ] **Step 3: Implement `SchoolCatalog`**

```dart
enum SchoolAvailabilityStatus {
  available,
  planned,
}

class SchoolCatalogEntry {
  final String id;
  final String displayName;
  final String shortName;
  final String representativeBook;
  final String era;
  final String description;
  final List<String> tags;
  final SchoolAvailabilityStatus status;
  final int displayOrder;

  const SchoolCatalogEntry({
    required this.id,
    required this.displayName,
    required this.shortName,
    required this.representativeBook,
    required this.era,
    required this.description,
    required this.tags,
    required this.status,
    required this.displayOrder,
  });
}

class SchoolCatalog {
  static const List<SchoolCatalogEntry> all = [
    SchoolCatalogEntry(
      id: 'yuding',
      displayName: '御定大六壬',
      shortName: '御定',
      representativeBook: '《御定大六壬直指》',
      era: '清代',
      description: '清代宫廷编撰的官方大六壬体系，当前作为默认解释流派。',
      tags: ['官方', '权威', '默认'],
      status: SchoolAvailabilityStatus.available,
      displayOrder: 1,
    ),
    SchoolCatalogEntry(
      id: 'bifa',
      displayName: '毕法赋',
      shortName: '毕法赋',
      representativeBook: '《毕法赋》',
      era: '宋代',
      description: '以歌诀形式总结占断要诀，共一百条法则，便于学习和快速查用。',
      tags: ['法则', '歌诀', '入门'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 2,
    ),
    SchoolCatalogEntry(
      id: 'zhinan',
      displayName: '大六壬指南',
      shortName: '指南',
      representativeBook: '《大六壬指南》',
      era: '明代',
      description: '注重实际占验案例，强调活法和实证应用。',
      tags: ['案例', '实证', '活法'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 3,
    ),
    SchoolCatalogEntry(
      id: 'kejing',
      displayName: '大六壬课经',
      shortName: '课经',
      representativeBook: '《大六壬课经》',
      era: '明代',
      description: '以课体分类为核心，适合结构化理解课格和吉凶走向。',
      tags: ['课体', '分类', '结构'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 4,
    ),
    SchoolCatalogEntry(
      id: 'daliuren_daquan',
      displayName: '大六壬大全',
      shortName: '大全',
      representativeBook: '《大六壬大全》',
      era: '明代',
      description: '集成诸家之说，内容全面，适合后续作为综合资料库扩展。',
      tags: ['集成', '全面', '资料'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 5,
    ),
    SchoolCatalogEntry(
      id: 'rengui',
      displayName: '壬归',
      shortName: '壬归',
      representativeBook: '《壬归》',
      era: '清代',
      description: '按事项分类组织占法，贴近用户具体问题场景。',
      tags: ['事项', '分类', '实用'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 6,
    ),
    SchoolCatalogEntry(
      id: 'liuren_cuiyan',
      displayName: '六壬粹言',
      shortName: '粹言',
      representativeBook: '《六壬粹言》',
      era: '清代',
      description: '精选诸家精华，偏向进阶用户的精要参考。',
      tags: ['精要', '进阶', '参考'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 7,
    ),
    SchoolCatalogEntry(
      id: 'guanlu_shenshu',
      displayName: '管辂神书',
      shortName: '管辂',
      representativeBook: '《管辂神书》',
      era: '三国',
      description: '保留古法风格，重视天将与神煞，后续作为古法体系扩展。',
      tags: ['古法', '天将', '神煞'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 8,
    ),
  ];

  static SchoolCatalogEntry? byId(String id) {
    for (final entry in all) {
      if (entry.id == id) return entry;
    }
    return null;
  }
}
```

- [ ] **Step 4: Run the test**

Run: `flutter test test/domain/schools/school_catalog_test.dart`

Expected: PASS.

### Task 2: School Slider Bar

**Files:**
- Create: `lib/presentation/widgets/school_slider_bar.dart`
- Test: `test/presentation/widgets/school_slider_bar_test.dart`

- [ ] **Step 1: Write widget tests**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daliuren/domain/schools/school_catalog.dart';
import 'package:daliuren/presentation/widgets/school_slider_bar.dart';

void main() {
  testWidgets('renders all school tabs in catalog order', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('御定'), findsOneWidget);
    expect(find.text('毕法赋'), findsOneWidget);
    expect(find.text('指南'), findsOneWidget);
    expect(find.text('课经'), findsOneWidget);
  });

  testWidgets('calls onChanged when a planned school is tapped', (tester) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (id) => selected = id,
          ),
        ),
      ),
    );

    await tester.tap(find.text('毕法赋'));
    await tester.pump();

    expect(selected, 'bifa');
  });
}
```

- [ ] **Step 2: Run the failing test**

Run: `flutter test test/presentation/widgets/school_slider_bar_test.dart`

Expected: FAIL because `SchoolSliderBar` does not exist.

- [ ] **Step 3: Implement `SchoolSliderBar`**

Use a `SingleChildScrollView(scrollDirection: Axis.horizontal)` with stable chip/button dimensions. Selected tab uses the theme primary color. Planned schools remain clickable and may show a subtle outline/status dot, but must not be disabled.

- [ ] **Step 4: Run the test**

Run: `flutter test test/presentation/widgets/school_slider_bar_test.dart`

Expected: PASS.

### Task 3: Explanation Panel States

**Files:**
- Create: `lib/presentation/widgets/planned_school_roadmap_widget.dart`
- Create: `lib/presentation/widgets/school_explanation_panel.dart`
- Test: `test/presentation/widgets/school_explanation_panel_test.dart`

- [ ] **Step 1: Write state tests**

Test planned schools show roadmap metadata; available yuding can use a child builder or placeholder hook for existing formal content; empty/error states render distinct text.

- [ ] **Step 2: Implement widgets**

`PlannedSchoolRoadmapWidget` displays school display name, representative book, description, tags, and `正在整理中`. `SchoolExplanationPanel` switches on catalog status and selected school id.

- [ ] **Step 3: Run tests**

Run: `flutter test test/presentation/widgets/school_explanation_panel_test.dart`

Expected: PASS.

### Task 4:客盘 Page Integration

**Files:**
- Modify: `lib/presentation/views/widgets/divination_display_widget.dart`
- Test: add or extend widget tests when the viewmodel can be mocked safely.

- [ ] **Step 1: Add selected school local state**

Convert only the minimum widget boundary that needs state to a `StatefulWidget` or introduce a small stateful child for the explanation region. Default selected id is `yuding`.

- [ ] **Step 2: Insert explanation region after pan/lesson display**

Keep existing pan, keti, and shen sha sections unchanged. Add:

```text
SchoolSliderBar
SchoolExplanationPanel
```

- [ ] **Step 3: Preserve formal yuding display**

When selected school is `yuding`, render the current formal御定/课体 explanation path. Do not replace it with the new unified component in the formal客盘 path during first stage.

- [ ] **Step 4: Verify no recalc on tab switch**

Switching tabs should only call local setState; it must not call `recalculate()` or `calculateDivination()`.

### Task 5: DevPage Verification Entry

**Files:**
- Modify: `lib/pages/dev.dart`

- [ ] **Step 1: Add a simple section switcher**

Keep the existing four-class debug content, but add a small segmented control or list of debug sections.

- [ ] **Step 2: Add multi-school debug section**

Use `SchoolSliderBar` and `SchoolEntryDisplayWidget` to validate the new unified display path with御定 data or a fixed in-memory `SchoolEntry` test adapter.

- [ ] **Step 3: Keep DevPage out of formal navigation**

Do not add it to the normal user navigation unless an existing debug route already exposes it.

### Task 6: Regression and Verification

**Files:**
- No production files unless tests expose needed seams.

- [ ] **Step 1: Run targeted tests**

Run:

```bash
flutter test test/domain/schools/school_catalog_test.dart
flutter test test/presentation/widgets/school_slider_bar_test.dart
flutter test test/presentation/widgets/school_explanation_panel_test.dart
```

Expected: PASS.

- [ ] **Step 2: Run existing core regression**

Run:

```bash
flutter test test/da_liu_ren_test.dart
flutter test test/nine_zong_men_zei_ke_test.dart
```

Expected: PASS.

- [ ] **Step 3: Run broader tests if time allows**

Run:

```bash
flutter test
```

Expected: PASS or document unrelated pre-existing failures.

### Self-Review

Spec coverage:

- First-stage architecture foundation is covered by Task 1.
-客盘 slider bar is covered by Task 2 and Task 4.
- Planned roadmap state is covered by Task 3.
- Formal御定 fallback and no-recalc behavior are covered by Task 4.
- DevPage double-track verification is covered by Task 5.
- Data source completion is explicitly excluded.

Placeholder scan:

- No implementation placeholders are left in the task steps. Data source completion remains intentionally out of scope.

Type consistency:

- `SchoolCatalogEntry`, `SchoolAvailabilityStatus`, `SchoolSliderBar`, `PlannedSchoolRoadmapWidget`, and `SchoolExplanationPanel` names are used consistently.
