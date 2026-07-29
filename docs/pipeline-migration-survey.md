# 大六壬管线迁移 M1 盘点调查报告

> 产出仓: `xuan-daliuren`
> 阶段: M1 (只读盘点，零代码改动)
> 参考样板: `xuan-qizhengsiyu/docs/pipeline-migration-survey.md`
> 参考架构: `docs/launch-plan/DIVINATION-PIPELINE-ARCHITECTURE.md`

---

## 1. 当前状态与 Git 清洁度

### 远程仓库

```
gitea  http://***@192.168.0.165:3000/xuan/xuan-daliuren.git (fetch)
gitea  http://***@192.168.0.165:3000/xuan/xuan-daliuren.git (push)
origin https://github.com/weijingtai/xuan-daliuren.git (fetch)
origin https://github.com/weijingtai/xuan-daliuren.git (push)
```

### 分支状态

```
## main...gitea/main
 M example/pubspec.yaml
?? .codegraph/daemon.pid
?? docs/pipeline-migration-survey.md
```

| 指标 | 值 |
|---|---|
| 当前分支 | `main` |
| 跟踪远端 | `gitea/main` |
| ahead/behind | 0 / 0 |
| 已修改跟踪文件 | `example/pubspec.yaml`（新增 `repository_interface_divination_pipeline` dependency_override，3 行） |
| 未跟踪文件 | `.codegraph/daemon.pid`（工具产物，不提交）、`docs/pipeline-migration-survey.md`（本报告） |

**注意**: `example/pubspec.yaml` 的改动是向前人已为管线迁移做的预埋（添加了 `repository_interface_divination_pipeline` override），不是意外修改。M2a 正式添加依赖时会用到，本轮保留不提交。

### 全分支 pipeline 扫描

所有分支（`main`、`chore/sdk-and-build-runner-bump-2026-07-14`、`feat/module-mounting-daliuren`、`gitea/main`、`gitea/codex-story7-gitea-actions`、`origin/main`）均无 `domain/pipeline/` 或 `chart_calculator` 文件。管线迁移尚未开始。

### 依赖版本核对

- `repository_interface_divination_pipeline` — **未声明直接依赖**（M2a 需新增）
- `repository_interface_daliuren` — git 依赖，`dependency_overrides` 指向 gitea main
- `metaphysics_core` — git 依赖 overridden
- `xuan-storage` (persistence_core/persistence_drift) — `dependency_overrides` 指向 gitea main

---

## 2. 时间输入字段与 JSON 编码

### 双排盘路径，两种时间模型

大六壬模块有**两条排盘计算路径**共存：

#### 路径 A（活跃主力）：`DaLiuRenCalculationService.calculate(DateTime, {String? question})`

- 入口：`DaLiuRenViewModel._calculateDivination()` (`lib/presentation/viewmodels/da_liu_ren_viewmodel.dart:139`)
- 输入：裸 `DateTime`（无时区、无经纬度、无口径概念）
- 内部通过 `LunarCalculator.calculateBaZi()` 用 `tyme` 库实时计算八字
- 输出：`DaLiuRenKePan`

#### 路径 B（已标记 deprecated，仍存在）：`CalculateRawPanService.calculate(DaLiuRenPanConfig, DivinationDatetimeModel)`

- 入口：`CalculateRawPanService.calculate()` (`lib/domain/services/calculate_raw_pan_service.dart:36`)
- 输入：`DivinationDatetimeModel`（来自 `xuan-metaphysics-core`，含 `datetime`、`observer`、四柱、节气等完整字段）
- 输出：`LiuRenPanModel`

#### 手动排盘入口

通过 `ManualJuParams` 走 `DaLiuRenRepositoryImpl.calculateManualDivination()`，直接查预存盘表，使用 `DateTime.now()` 作时间戳，不经过实时计算。

### JSON 编码

路径 A 的输出 `DaLiuRenKePan` 无 `toJson()`。路径 B 的输出 `LiuRenPanModel` 有 `toJson()`。持久化时通过 `DaliurenDivinationRecordContract` 以 JSON 字符串（`lunarDateJson`、`ganzhiJson` 等）存储。

---

## 3. 地点、时区与坐标来源

**当前模块排盘不依赖地理信息。** 两条路径均不接受经纬度、时区、地点参数：

- 路径 A：仅接受 `DateTime`，依赖 Dart 的本地时区隐式携带
- 路径 B：`DivinationDatetimeModel` 包含 `observer` 字段（含 `timezoneStr`、`coordinate`、`location` 等），但路径 B 当前已标记 deprecated，实际排盘不使用这些字段

**结论**：大六壬排盘本身不需要经纬度/时区（与七政的天文计算不同），但管线要求明确的 IANA 时区（`DivinationMoment`），M2 需要从 `ResolvedMoment` 获取时区信息。

---

## 4. 历法换算路径与 `EnumDatetimeType` 用法

**大六壬模块当前不使用 `EnumDatetimeType` 口径体系。** 没有真太阳时/平太阳时/北京时的切换逻辑。

- 路径 A：`LunarCalculator` 通过 `tyme` 库（`SolarTime`、`SolarDay`）计算八字和节气，所有计算基于 `DateTime` 的本地墙钟时间
- 路径 B：`DivinationDatetimeModel.observer.type` 字段存在但值为 `"标准时间"`（硬编码），实际计算不依赖此字段

**与七政的关键差异**：七政有 `EnumDatetimeType` 五档口径，奇门/梅花/六壬均无。大六壬的八字计算完全交给 `tyme` 库，不需要外部口径切换。

---

## 5. 计算入口点与纯度风险

### 核心问题：能否被同步 `calculate()` 包起来？

**答案：可以，核心计算链是同步纯函数。但需要区分两条路径。**

### 路径 A（活跃）：`DaLiuRenCalculationService.calculate(DateTime, {String? question})`

```dart
// lib/domain/services/da_liu_ren_calculation_service.dart:49
DaLiuRenKePan calculate(DateTime dateTime, {String? question}) {
```

**同步纯函数**。内部调用链：
- `LunarCalculator.calculateBaZi()` — 同步，通过 `tyme` 库计算
- `LunarCalculator.calculateMonthGeneral()` — 同步
- `TianDiPanCalculator` — 同步
- `GuiRenCalculator` — 同步
- `FourClassCalculator` — 同步
- `ThreeChuanCalculator` — 同步

### 路径 B（deprecated）：`CalculateRawPanService.calculate(DaLiuRenPanConfig, DivinationDatetimeModel)`

```dart
// lib/domain/services/calculate_raw_pan_service.dart:36
LiuRenPanModel calculate(DaLiuRenPanConfig config, DivinationDatetimeModel divinationDatetimeModel) {
```

**同步纯函数**。接口签名已接近管线 `ChartCalculator.calculate(moment, params)` 模式。

### 非纯元素清单

| 位置 | 行号 | 操作 | 影响 |
|---|---|---|---|
| `da_liu_ren_viewmodel.dart` | 52 | `_selectedDateTime` 初始值 `DateTime.now()` | UI 默认值，非计算 |
| `da_liu_ren_viewmodel.dart` | 187 | `resetToNow()` | UI 交互，非计算 |
| `da_liu_ren_viewmodel.dart` | 354 | `_saveCurrentDivination()` 的 `createdAt` | 持久化时间戳，非计算 |
| `da_liu_ren_repository_impl.dart` | 102 | `calculateManualDivination()` 的 `panDateTime: DateTime.now()` | 手排模式时间戳，非排盘计算 |
| `keti_data_service.dart` | 40-55 | 课体 JSON 数据加载 | 异步，算前数据准备 |
| `shen_sha_calculation_service_impl.dart` | 全文件 | 9 种神煞数据异步加载 | 异步，算前数据准备 |
| `da_liu_ren_repository_impl.dart` | 29-43 | 御定/YuDing/JuMapper/Pan 数据加载 | 异步，算前数据准备 |

### 关键矛盾

**神煞计算的 async 链**：`ShenShaCalculationServiceImpl` 全部方法是 `Future`（需要等数据加载），而管线 `calculate()` 是同步签名。这是 M2 需要解决的核心矛盾——要么将神煞数据加载前置到 `CalculationContext.load()` 中，要么把神煞计算拆出管线。

### 结论

**大六壬的核心排盘计算（路径 A 的 `DaLiuRenCalculationService` 和路径 B 的 `CalculateRawPanService`）可以被同步 `calculate()` 包起来。** 但神煞计算（`ShenShaCalculationServiceImpl`）的异步加载需要前置处理。

---

## 6. 持久化路径与 Record Codec

### Contract

`DaliurenDivinationRecordContract` 位于 `repository-interface-daliuren/lib/src/contracts/daliuren_divination_record_contract.dart`：

```dart
final class DaliurenDivinationRecordContract extends Equatable {
  // uuid, question, lunarDateJson, ganzhiJson, juNumber, juName,
  // schoolId, yueJiangJson, riYueJson, sanChuanJson, siKeJson,
  // twelveTianJinJson, paramsJson, createdAt, updatedAt, deletedAt
}
```

- 当前使用 `extends Equatable`，**未实现 `Chart` 接口**
- 无 `toJson()` 方法
- 所有盘面数据以 JSON 字符串存储（双编码模式）

### Codec

`DaliurenRecordCodec` 位于 `xuan-storage/drift/lib/daliuren/daliuren_record_codec.dart`，实现了 `RecordModuleCodec<DaliurenDivinationRecordContract>`：
- `module` = `'daliuren'`
- `category` = `'divination'`
- `divinationType` = `'da_liu_ren'`

公共列填列状态：全部为 `null`（`occurredAtUtc`、`reckoningType`、`timezoneStr`、`latitude`、`longitude`、`locationName`、`spacetimeJson`）。

### 接口包中其他类型

`repository-interface-daliuren` 除记录契约外还有 `SchoolEntryContract`（流派条目），本轮只记录其存在，不动。

---

## 7. 既有测试与既有失败

### 测试基线（实跑结果）

```
flutter pub get: EXIT=0
flutter test --no-pub: 105 tests passed, EXIT=0
```

**全部 105 个测试通过，0 个失败。** 改动前无红灯。

### 测试文件清单（22 个文件）

| 文件 | 类型 |
|---|---|
| `test/da_liu_ren_test.dart` | 盘面计算特征 |
| `test/each_class_test.dart` | 数据模型 |
| `test/nine_zong_men_zei_ke_test.dart` | 九宗门-贼克法 |
| `test/nine_zong_men_yao_ke_test.dart` | 九宗门-遥克法 |
| `test/nine_zong_men_mao_xing_test.dart` | 九宗门-昴星法 |
| `test/nine_zong_men_bie_ze.dart` | 九宗门-别责法 |
| `test/nine_zong_men_ba_zhuan.dart` | 九宗门-八专法 |
| `test/nine_zong_men_fu_yin.dart` | 九宗门-伏吟法 |
| `test/nine_zong_men_fan_yin.dart` | 九宗门-反吟法 |
| `test/nine_zong_men_she_hai.dart` | 九宗门-涉害法 |
| `test/storage_ports_fake_test.dart` | 存储适配器 |
| `test/only_dart_generat_from_json.dart` | JSON 生成验证 |
| `test/domain/services/shen_sha_calculation_test.dart` | 神煞计算 |
| `test/domain/schools/school_catalog_test.dart` | 流派目录 |
| `test/presentation/da_liu_ren_input_state_test.dart` | 输入状态 |
| `test/presentation/da_liu_ren_viewmodel_intent_test.dart` | ViewModel Intent |
| `test/presentation/widgets/school_slider_bar_test.dart` | 流派滑块 |
| `test/presentation/widgets/school_explanation_panel_test.dart` | 流派说明面板 |
| `test/theme/daliuren_token_test.dart` | Token |
| `test/theme/daliuren_facade_theme_test.dart` | Facade 主题 |
| `test/theme/theme_token_governance_test.dart` | Token 治理 |
| `test/architecture/import_boundary_test.dart` | 导入边界 |

---

## 8. M2 / M3 / M4 的 SCOPE.WRITE 提案

### M2a — 契约先行（接口包改动，需审批）

| 操作 | 文件 | 说明 |
|---|---|---|
| 修改 | `repository-interface-daliuren/pubspec.yaml` | 新增 `repository_interface_divination_pipeline` 依赖（无 `ref:`） |
| 修改 | `repository-interface-daliuren/lib/src/contracts/daliuren_divination_record_contract.dart` | 添加 `implements Chart` + `toJson()` |

### M2 — Calculator + Context + Params

| 操作 | 文件 | 说明 |
|---|---|---|
| 新建 | `xuan-daliuren/lib/domain/pipeline/daliuren_calculation_context.dart` | `DaliurenCalculationContext`（含 `static Future<...> load()`） |
| 新建 | `xuan-daliuren/lib/domain/pipeline/daliuren_chart_params.dart` | `DaliurenChartParams implements ModuleParams`（封装 `DaLiuRenPanConfig` 的四个字段） |
| 新建 | `xuan-daliuren/lib/domain/pipeline/daliuren_chart_calculator.dart` | `DaliurenChartCalculator implements ChartCalculator<DaliurenChartParams, DaliurenDivinationRecordContract>` |
| 修改 | `xuan-daliuren/pubspec.yaml` | 新增 `repository_interface_divination_pipeline` 依赖 |

### M3 — 管线接契约

| 操作 | 文件 | 说明 |
|---|---|---|
| 新建 | `xuan-daliuren/lib/domain/pipeline/daliuren_pipeline_executor.dart` | `DaliurenPipelineExecutor`，对接 `ChartRequest` → `Calculator` |
| 修改 | `xuan-daliuren/lib/presentation/viewmodels/da_liu_ren_viewmodel.dart` | 去掉排盘逻辑，改为调用 Pipeline |

### M4 — Codec 适配

| 操作 | 文件 | 说明 |
|---|---|---|
| 修改 | `xuan-storage/drift/lib/daliuren/daliuren_record_codec.dart` | 填公共列（`occurredAtUtc`、`reckoningType` 等） |

---

## 9. 开工前的停手条件

以下条件触发即停，不得擅自编码：

1. **双排盘路径选择未裁决** — 路径 A（`DaLiuRenCalculationService` + `tyme`）vs 路径 B（`CalculateRawPanService` + `DivinationDatetimeModel`），Calculator 以谁为基准？路径 A 是当前活跃使用路径，路径 B 接口更接近管线模式。需要人类裁决。

2. **神煞 async 计算链** — `ShenShaCalculationServiceImpl` 全部方法是 async，与 `calculate()` 同步签名冲突。方案：将神煞数据加载前置到 `DaliurenCalculationContext.load()` 中，还是把神煞计算拆出管线？需要人类裁决。

3. **手排模式（ManualJuParams）的管线适配方案未定** — 手排直接查预存盘表，不经过实时计算。管线 `ChartRequest` 假设所有输入来自 `DivinationMoment` + `ModuleParams`，手动模式如何适配？

4. **`DaliurenDivinationRecordContract` 未实现 `Chart`** — M2 的 Calculator 泛型上界依赖 `C extends Chart`，需 M2a 先行。

5. **`tyme` 库 vs `ResolvedMoment` 四柱冲突** — 如果 Calculator 用 `tyme` 自行计算八字，可能出现与 `ResolvedMoment` 中预计算的 `eightChars` 不一致的情况（不同历法库的节气边界判断可能差几分钟）。

6. **无 `MomentResolver` 实现** — 全工作区没有 `MomentResolver` 的实现类。M3 无法接管线。

7. **`example/pubspec.yaml` 已预埋改动** — 该文件已有 `repository_interface_divination_pipeline` dependency_override，是前人为 M2a 做的准备。M2a 正式添加依赖时如何处理此预埋？

---

## 附录：关键代码位置索引

| 符号 | 文件 | 行号 |
|---|---|---|
| `DaLiuRenViewModel._calculateDivination` | `lib/presentation/viewmodels/da_liu_ren_viewmodel.dart` | 139 |
| `DaLiuRenCalculationService.calculate` | `lib/domain/services/da_liu_ren_calculation_service.dart` | 49 |
| `CalculateRawPanService.calculate` | `lib/domain/services/calculate_raw_pan_service.dart` | 36 |
| `LunarCalculator` | `lib/domain/services/calculators/lunar_calculator.dart` | 8 |
| `DaLiuRenPanConfig` | `lib/model/pan_config.dart` | 8 |
| `DaLiuRenKePan` | `lib/model/da_liu_ren_ke_pan.dart` | 19 |
| `LiuRenPanModel` | `lib/domain/entities/liu_ren_pan_model.dart` | — |
| `ShenShaCalculationServiceImpl` | `lib/domain/services/shen_sha_calculation_service_impl.dart` | — |
| `DaliurenDivinationRecordContract` | `repository-interface-daliuren/lib/src/contracts/daliuren_divination_record_contract.dart` | 3 |
| `DaliurenRecordCodec` | `xuan-storage/drift/lib/daliuren/daliuren_record_codec.dart` | 5 |
| `SchoolEntryContract` | `repository-interface-daliuren/lib/src/contracts/school_entry_contract.dart` | — |

---

> **M1 盘点完成时间**: 2026-07-29
> **报告产出**: `docs/pipeline-migration-survey.md`
> **约束遵守**: 只读调查，未触碰任何生产代码