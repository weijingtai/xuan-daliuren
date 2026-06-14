# D0 Baseline & Boundary Freeze

**Date:** 2026-06-13
**Branch:** feature/decouple-ui-mvvm-dpre
**Commit:** 6b63463 (feat(daliuren): DPRE-1~5 pre-migration for UI-MVVM decoupling)

---

## D0.2 Route List

Source: `lib/navigator.dart`

| Route        | Page Widget         | Page File                              |
|-------------|---------------------|----------------------------------------|
| /daliuren    | DaLiuRenView        | lib/presentation/views/da_liu_ren_view.dart |
| /daliuren/old| MyHomePage          | lib/pages/my_home_page.dart            |
| /daliuren/new| NewHomePage         | lib/pages/new/new_home_page.dart       |
| /daliuren/dev| DevMyWidget         | lib/pages/dev.dart                     |

All three main routes wrap the child in `MultiProvider(providers: DependencyInjection.getProviders(deps))`.

---

## D0.3 Dart Analyzer Baseline

**Command:** `dart analyze lib`

**Counts:**
- Error: 0
- Warning: 43
- Info: 207
- **Total: 250 issues**

<details>
<summary>Full analyzer output (43 warnings)</summary>

```
warning - data/repositories/da_liu_ren_repository_impl.dart:144:15 - The declaration '_checkPanJu' isn't referenced. Try removing the declaration of '_checkPanJu'. - unused_element
warning - domain/services/calculate_gui_ren_position_service.dart:102:7 - This default clause is covered by the previous cases. Try removing the default clause, or restructuring the preceding patterns. - unreachable_switch_default
warning - domain/services/calculate_month_general_service.dart:4:8 - Unused import: 'package:daliuren/domain/enums/gui_ren_type.dart'. Try removing the import directive. - unused_import
warning - domain/services/calculate_month_general_service.dart:77:11 - The value of the local variable 'currentJieQi' isn't used. Try removing the variable or using it. - unused_local_variable
warning - domain/services/calculate_raw_pan_service.dart:8:8 - Unused import: 'package:daliuren/model/da_liu_ren_ke_pan.dart'. Try removing the import directive. - unused_import
warning - domain/services/calculate_raw_pan_service.dart:32:40 - The value of the field '_guiRenPositionService' isn't used. Try removing the field, or using it. - unused_field
warning - domain/services/da_liu_ren_calculation_service.dart:1:8 - Unused import: 'package:metaphysics_core/enums.dart'. Try removing the import directive. - unused_import
warning - domain/services/da_liu_ren_calculation_service.dart:55:13 - The value of the local variable 'yearJiaZi' isn't used. Try removing the variable or using it. - unused_local_variable
warning - domain/services/da_liu_ren_calculation_service.dart:56:13 - The value of the local variable 'monthJiaZi' isn't used. Try removing the variable or using it. - unused_local_variable
warning - domain/services/da_liu_ren_calculation_service.dart:95:13 - The value of the local variable 'threeChuan' isn't used. Try removing the variable or using it. - unused_local_variable
warning - domain/services/da_liu_ren_calculation_service.dart:102:13 - The value of the local variable 'yinYangDun' isn't used. Try removing the variable or using it. - unused_local_variable
warning - domain/services/nine_zong_men_calculator_v1_2.dart:10:8 - Unused import: 'package:flutter/material.dart'. Try removing the import directive. - unused_import
warning - domain/services/nine_zong_men_calculator_v1_2.dart:103:7 - This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final: _ProcessedFourClassItem.zeiKeType, _ProcessedFourClassItem.isSkyKeDayGan, _ProcessedFourClassItem.isDayGanKeSky, _ProcessedFourClassItem.sheHaiTimes, _ProcessedFourClassItem.isSkySameYinYangWithDayGan - must_be_immutable
warning - domain/services/nine_zong_men_calculator_v1_2.dart:1513:8 - The declaration '_isJi' isn't referenced. Try removing the declaration of '_isJi'. - unused_element
warning - domain/services/nine_zong_men_calculator_v1_2.dart:1574:21 - The declaration '_resolveMaoXingOptimized' isn't referenced. Try removing the declaration of '_resolveMaoXingOptimized'. - unused_element
warning - domain/services/shen_sha_calculation_service_impl.dart:4:8 - Unused import: 'package:daliuren/data/services/shen_sha_data_service_impl.dart'. Try removing the import directive. - unused_import
warning - domain/services/three_chuan_calculator_v1.dart:87:7 - This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final: _ProcessedFourClassItem.zeiKeType, _ProcessedFourClassItem.isSkyKeDayGan, _ProcessedFourClassItem.isDayGanKeSky, _ProcessedFourClassItem.sheHaiTimes, _ProcessedFourClassItem.isSkySameYinYangWithDayGan - must_be_immutable
warning - domain/services/three_chuan_calculator_v1.dart:1376:8 - The declaration '_isJi' isn't referenced. Try removing the declaration of '_isJi'. - unused_element
warning - domain/services/three_chuan_calculator_v1.dart:1437:21 - The declaration '_resolveMaoXingOptimized' isn't referenced. Try removing the declaration of '_resolveMaoXingOptimized'. - unused_element
warning - model/da_liu_ren_ke_pan.dart:474:15 - The value of the local variable 'firstChuan' isn't used. Try removing the variable or using it. - unused_local_variable
warning - model/da_liu_ren_ke_pan.dart:1047:21 - The declaration '_handleMultipleZeiKe' isn't referenced. Try removing the declaration of '_handleMultipleZeiKe'. - unused_element
warning - model/da_liu_ren_ke_pan.dart:1563:9 - Dead code. Try removing the code, or fixing the code before it so that it can be reached. - dead_code
warning - model/da_liu_ren_ke_pan.dart:1685:9 - Dead code. Try removing the code, or fixing the code before it so that it can be reached. - dead_code
warning - model/four_class.dart:1:8 - Unused import: 'dart:convert'. Try removing the import directive. - unused_import
warning - model/four_class.dart:6:8 - Unused import: 'package:daliuren/model/enum_nine_zong_men.dart'. Try removing the import directive. - unused_import
warning - model/four_class.dart:8:8 - Unused import: 'package:tuple/tuple.dart'. Try removing the import directive. - unused_import
warning - model/four_class.dart:58:9 - The value of the local variable 'secondSky' isn't used. Try removing the variable or using it. - unused_local_variable
warning - model/four_class.dart:108:9 - The value of the local variable 'dayZhi' isn't used. Try removing the variable or using it. - unused_local_variable
warning - model/raw_pan_datamodel.dart:1:8 - Unused import: 'package:collection/collection.dart'. Try removing the import directive. - unused_import
warning - model/raw_pan_datamodel.dart:28:24 - The method doesn't override an inherited method. Try updating this class to match the superclass, or removing the override annotation. - override_on_non_overriding_member
warning - model/raw_pan_datamodel.dart:60:24 - The method doesn't override anherited method. Try updating this class to match the superclass, or removing the override annotation. - override_on_non_overriding_member
warning - model/raw_pan_datamodel.dart:107:24 - The method doesn't override an inherited method. Try updating this class to match the superclass, or removing the override annotation. - override_on_non_overriding_member
warning - model/raw_pan_datamodel.dart:127:24 - The method doesn't override an inherited method. Try updating this class to match the superclass, or removing the override annotation. - override_on_non_overriding_member
warning - pages/dev.dart:169:12 - The value of the local variable 'otherFontSize' isn't used. Try removing the variable or using it. - unused_local_variable
warning - pages/dev.dart:192:12 - The value of the local variable 'height' isn't used. Try removing the variable or using it. - unused_local_variable
warning - pages/my_home_page.dart:6:8 - Unused import: 'package:metaphysics_core/models/shen_sha.dart'. Try removing the import directive. - unused_import
warning - pages/my_home_page.dart:35:8 - Unused import: '../domain/services/keti_data_service.dart'. Try removing the import directive. - unused_import
warning - pages/my_home_page.dart:48:23 - The value of the field 'SMALL_PAN_SIZE' isn't used. Try removing the field, or using it. - unused_field
warning - pages/my_home_page.dart:99:10 - The value of the local variable 'panSize' isn't used. Try removing the variable or using it. - unused_local_variable
warning - pages/my_home_page.dart:100:10 - The value of the local variable 'gongSize' isn't used. Try removing the variable or using it. - unused_local_variable
warning - pages/my_home_page.dart:374:11 - The value of the local variable 'matchedKeTiNames' isn't used. Try removing the variable or using it. - unused_local_variable
warning - pages/my_home_page.dart:1835:5 - Dead code. Try removing the code, or fixing the code before it so that it can be reached. - dead_code
warning - pages/new/new_home_page.dart:6:8 - Unused import: 'package:metaphysics_core/models/shen_sha.dart'. Try removing the import directive. - unused_import
```

</details>

---

## D0.4 Test Baseline

**Command:** `flutter test`

**Result:**
- **Passed: 50**
- **Failed: 1** (expected — import_boundary_test catches existing baseline violations)
- **Total: 51 tests**

The 1 failing test is `test/architecture/import_boundary_test.dart: lib/pages should not import restricted types` — this is the DPRE-5 negative boundary test that intentionally fails because `lib/pages/my_home_page.dart` and `lib/pages/new/new_home_page.dart` have forbidden imports. These violations are recorded as baseline allow-list entries below.

---

## D0.5 Boundary Scans

### Scan 1: UI deny-list (lib/pages + lib/presentation/views + lib/presentation/widgets)

**Patterns searched:** `domain/services|domain/repositories|data/repositories|data/services|repository_interface_daliuren|DaLiuRenOfficialDataRepository|DaLiuRenRepository[^I]|loadYuDingData|serviceLocator|ReadDataUtils`

**Result: 9 matches in 2 files**

```
lib/pages/my_home_page.dart:13:import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
lib/pages/my_home_page.dart:35:import '../domain/services/keti_data_service.dart';
lib/pages/my_home_page.dart:515:loadBy(pan.dayJiaZi, pan.fourClass.first.sky, context.read<DaLiuRenOfficialDataRepository>()),
lib/pages/my_home_page.dart:715:pan.dayJiaZi, pan.fourClass.first.sky, context.read<DaLiuRenOfficialDataRepository>()),
lib/pages/my_home_page.dart:1461:DaLiuRenOfficialDataRepository officialData) async {
lib/pages/my_home_page.dart:1463:final List<dynamic> res = await officialData.loadYuDingData();
lib/pages/new/new_home_page.dart:11:import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
lib/pages/new/new_home_page.dart:751:final officialData = context.read<DaLiuRenOfficialDataRepository>();
lib/pages/new/new_home_page.dart:752:final List<dynamic> res = await officialData.loadYuDingData();
```

### Scan 2: ViewModel deny-list (lib/presentation/viewmodels)

**Patterns searched:** `data/repositories|data/services|data/models|data/schools|package:daliuren/data/`

**Result: 0 matches** — Clean. No violations.

### Scan 3: UseCase deny-list (lib/domain/usecases)

**Patterns searched:** `data/repositories|data/services|data/models|data/schools|package:daliuren/data/|package:flutter|package:provider`

**Result: 0 matches** — Clean. No violations.

### Scan 4: Repository reverse dep (lib/data + lib/domain/repositories + lib/domain/services)

**Patterns searched:** `package:flutter|package:provider|presentation/`

**Result: 1 match in 1 file**

```
lib/domain/services/nine_zong_men_calculator_v1_2.dart:10:import 'package:flutter/material.dart';
```

---

## D0.6 Baseline Allow-List (Existing Violations Only)

These are the ONLY violations allowed to exist at baseline. All must be resolved by end of migration.

### UI Layer Violations (9 total)

| # | File | Line | Pattern | Description |
|---|------|------|---------|-------------|
| 1 | lib/pages/my_home_page.dart | 13 | `repository_interface_daliuren` | Direct import of repository interface package |
| 2 | lib/pages/my_home_page.dart | 35 | `domain/services` | Direct import of keti_data_service |
| 3 | lib/pages/my_home_page.dart | 515 | `DaLiuRenOfficialDataRepository` | Direct `context.read<>()` of repository |
| 4 | lib/pages/my_home_page.dart | 715 | `DaLiuRenOfficialDataRepository` | Direct `context.read<>()` of repository |
| 5 | lib/pages/my_home_page.dart | 1461 | `DaLiuRenOfficialDataRepository` | Direct type parameter in function signature |
| 6 | lib/pages/my_home_page.dart | 1463 | `loadYuDingData` | Direct call to repository method |
| 7 | lib/pages/new/new_home_page.dart | 11 | `repository_interface_daliuren` | Direct import of repository interface package |
| 8 | lib/pages/new/new_home_page.dart | 751 | `DaLiuRenOfficialDataRepository` | Direct `context.read<>()` of repository |
| 9 | lib/pages/new/new_home_page.dart | 752 | `loadYuDingData` | Direct call to repository method |

### Domain Service Violations (1 total)

| # | File | Line | Pattern | Description |
|---|------|------|---------|-------------|
| 1 | lib/domain/services/nine_zong_men_calculator_v1_2.dart | 10 | `package:flutter/material.dart` | Flutter framework import in domain service |

### ViewModel Violations: 0
### UseCase Violations: 0

**Total baseline violations: 10**

---

## D0.7 Golden Fixture Inventory

See: `test/golden/fixtures/daliuren_decoupling_cases.json`
See: `test/golden/expected/daliuren_decoupling_expected.json` (stub — to be populated during migration)

---

## D0.8 Negative Dependency Test Verification

**File:** `test/architecture/import_boundary_test.dart`
**Status:** EXISTS and actively enforcing boundaries.

The test scans `lib/pages`, `lib/presentation/views`, `lib/presentation/widgets` for forbidden patterns. Currently FAILS on `lib/pages` (9 violations found), PASSES on `lib/presentation/views` and `lib/presentation/widgets`. This is the expected baseline state.

---

## D0.9 Tasks.md Status

D0 items marked as complete. See `tasks.md`.
