---
id: daliuren-story-7-refactor
title: 大六壬多流派架构重构需求分析与正向设计
type: design
status: stable
created: 2026-05-23
updated: 2026-05-25
author: gemini
story: 7
product: xuan-daliuren
---

# Story 7 大六壬多流派架构重构需求分析与正向设计

> ZenTao Story: #7 大六壬多流派架构重构  
> ZenTao Task: #28 Story#7 需求分析与正向架构设计  
> 产品: xuan-daliuren  
> 日期: 2026-05-23  
> 交付性质: 需求分析与架构设计文档，不包含代码实现

## 1. 结论摘要

Story #7 的真实目标不是一次性完成八个大六壬流派的全部数据与功能，而是把当前以“御定大六壬”为中心的实现，重构成可逐步扩展的多流派架构。

本 Story 的一期交付应聚焦三件事：

1. 保持御定派现有能力稳定，作为默认流派和回归基线。
2. 建立清晰的流派抽象、条目抽象、注册与加载机制。
3. 以毕法赋作为第一个新增流派的设计验证对象，但不把“整理完毕法赋全部 100 条可用数据”作为架构重构的硬性交付前置。

建议将 Story #7 定义为“架构重构 + 第一个扩展流派的接入准备”，后续再拆出“毕法赋数据生产”“课经派接入”“指南派接入”等独立 Story。

## 2. 当前需求原文

禅道 Story #7 当前描述：

```text
背景：
当前仅支持御定大六壬，需重构为可扩展架构。

调研结果：
8个流派：御定(已实现)、毕法赋(P0)、课经(P1)、指南(P1)、管辂(P2)、大全(P2)、粹言(P3)、壬归(P3)

技术方案：
1. 创建抽象接口 DaLiuRenSchool/SchoolEntry/SchoolRegistry
2. 重构御定为第一个实现
3. UI组件通用化

验收标准：
- 抽象接口创建完成
- 御定重构为第一个流派实现
- UI组件通用化
- 现有功能无回归
```

该描述方向正确，但粒度偏粗，需要补齐边界、非目标、迁移路径、数据契约、风险和测试门禁。

## 3. 已有上下文

### 3.1 已有调研文档

当前仓库已有三份直接相关文档：

- `docs/大六壬流派调研报告.md`
- `docs/多流派重构技术方案.md`
- `docs/毕法赋数据格式说明.md`

这些文档已经识别出八个主要流派，并提出接口抽象、注册表、统一数据格式、御定优先迁移、毕法赋优先扩展的方向。

### 3.2 已有代码草稿

当前工作区已经存在一批多流派相关文件：

- `lib/domain/interfaces/da_liu_ren_school.dart`
- `lib/domain/interfaces/school_entry.dart`
- `lib/domain/interfaces/school_registry.dart`
- `lib/data/schools/yuding_school.dart`
- `lib/di/school_initialization.dart`
- `lib/presentation/widgets/school_selector_widget.dart`
- `lib/presentation/widgets/school_entry_display_widget.dart`
- `lib/pages/school_demo_page.dart`

这些文件说明多流派方向已有初步草稿，但还不是完整产品级集成。Story #7 后续实现应先审查 these 草稿是否符合主应用架构，再决定保留、调整或合并。

### 3.3 现有耦合点

从当前代码看，御定相关能力仍分布在旧路径中：

- `lib/domain/entities/yuding_entry.dart`
- `lib/domain/services/yuding_keti_match_service.dart`
- `lib/data/repositories/da_liu_ren_repository_impl.dart`
- `lib/presentation/widgets/yu_ding_display_widget.dart`
- `lib/pages/my_home_page.dart`
- `lib/pages/new/new_home_page.dart`

其中 `DaLiuRenRepositoryImpl` 仍硬编码以下资产路径：

- `packages/daliuren/assets/da_liu_ren/御定大六壬.json`
- `packages/daliuren/assets/da_liu_ren/ju_mapper.json`
- `packages/daliuren/assets/da_liu_ren/甲午庚牛羊_阳.json`
- `packages/daliuren/assets/da_liu_ren/甲午庚牛羊_阴.json`

这说明“新增接口文件”并不等于重构完成。真正的验收点必须包括调用链是否开始使用流派抽象，以及旧御定路径是否有明确迁移/兼容策略。

## 4. 需求边界

### 4.1 范围内

Story #7 应包含：

1. 多流派领域模型设计。
2. 御定派作为默认流派的迁移设计。
3. 毕法赋作为首个新增流派的接入设计。
4. 通用流派选择与条目展示的 UI 设计。
5. 数据契约与资源组织设计。
6. Repository、初始化、页面展示之间的数据流设计。
7. 回归和验收标准定义。

### 4.2 范围外

Story #7 不应包含：

1. 一次性生产全部八个流派的数据。
2. 一次性完成毕法赋 100 条法则的人工校勘。
3. 重写排盘核心算法。
4. 大规模重做旧 UI。
5. 把所有旧页面同时迁移到新架构。
6. 建立完整在线内容管理系统。

这些内容应拆成后续 Story，否则当前 Story 会失控。

## 5. 用户价值

### 5.1 对普通用户

用户可以从默认的御定解释开始使用，并逐步获得毕法赋、课经、指南等不同传统体系的解释视角。后续可以在同一盘面下比较不同流派的判断依据。

### 5.2 对研究型用户

多流派架构允许保留经典文本、条目来源、分类标签和书籍引用。用户不只是看到一个结论，还能知道这个结论来自哪一派、哪一本书、哪类规则。

### 5.3 对开发团队

新增流派不再需要在 Repository、页面、展示组件、数据加载路径中四处硬编码。开发者可以用统一接口接入新流派，并通过统一测试契约验证质量。

## 6. 设计选项

### 6.1 方案 A：仅抽象展示层

做法：

- 保持 Repository 与数据加载现状。
- 只新增流派选择器和通用条目卡片。
- 御定数据仍走旧路径，毕法赋数据单独写页面逻辑。

优点：

- 实现最快。
- 对现有业务逻辑冲击小。

缺点：

- 只是 UI 表面多流派，领域层仍旧耦合。
- 后续接入课经、指南时会继续复制逻辑。
- 不符合 Story #7 的“架构重构”目标。

结论：不推荐作为主方案。

### 6.2 方案 B：抽象领域流派，但保留排盘核心

做法：

- 排盘核心仍由现有 `DaLiuRenCalculationService`、`DaLiuRenKePan`、三传/四课算法承担。
- 流派层只负责“解释体系”：数据加载、条目匹配、规则展示、书籍引用。
- 御定派迁移为 `YudingSchool`。
- 毕法赋派以规则库形式接入，不强行伪装成御定的日干支+局索引。

优点：

- 风险可控。
- 不破坏现有排盘算法。
- 符合多流派扩展目标。
- 可以用御定回归测试做安全网。

缺点：

- 需要处理不同流派的索引差异。
- `SchoolEntry` 如果只按御定字段设计，会对毕法赋不够自然。

结论：推荐作为 Story #7 主方案。

### 6.3 方案 C：完整重构为插件式流派引擎

做法：

- 每个流派都拥有独立的排盘、匹配、解释、展示能力。
- 将计算、匹配、解释都放入流派插件。

优点：

- 理论上最灵活。

缺点：

- 当前需求过度设计。
- 会影响现有核心算法稳定性。
- 测试成本高，容易把架构重构做成大爆炸改造。

结论：不推荐在 Story #7 实施。

## 7. 推荐设计

采用方案 B：“排盘核心稳定 + 流派解释层抽象”。

核心思想：

```text
用户输入时间/问题
  -> 现有排盘核心生成 DaLiuRenKePan / DaLiuRenPanModel
  -> 当前选中流派根据盘面或索引匹配解释条目
  -> UI 用通用组件展示流派、条目、规则、出处
```

御定派继续作为默认流派。毕法赋不应被硬塞进“日干支 + 局名”模型，而应允许以规则编号、分类、标签、盘面特征等方式匹配。

## 8. 领域对象设计

### 8.1 `DaLiuRenSchool`

职责：

- 描述一个流派的元信息。
- 加载该流派数据。
- 提供条目匹配能力。
- 暴露数据加载状态和条目数量。

当前接口已有：

- `id`
- `displayName`
- `description`
- `representativeBook`
- `tags`
- `era`
- `loadData()`
- `isLoaded`
- `matchEntries(dayJiaZi, juName)`
- `getEntriesByDay(dayJiaZi)`
- `entryCount`
- `supportedDays`

设计建议：

1. 保留这些字段作为一期接口。
2. 后续增加更通用的匹配入口，例如 `matchByPan` 或 `matchByContext`，避免毕法赋只能返回空。
3. 对无法按日干支匹配的流派，`supportedDays` 可以返回空列表，但必须在文档中明确这不是错误。

### 8.2 `SchoolEntry`

职责：

- 作为 UI 展示和 Repository 返回的统一条目契约。

当前字段偏御定：

- `dayJiaZi`
- `juName`
- `juNumber`
- `keTiNames`
- `meaning`
- `explanation`
- `prediction`
- `details`
- `bookReferences`

风险：

毕法赋是“100 条法则”，主要索引是编号、标题、分类和歌诀内容，不是“某日某局”。如果强制所有字段都必填，会产生大量空字段。

设计建议：

1. 一期保留 `SchoolEntry`，但允许非御定流派用空字符串/0 表示不适用字段。
2. 在后续实现计划中评估拆分：
   - `SchoolEntry`：通用展示字段。
   - `PanIndexedSchoolEntry`：按日干支/局索引的条目。
   - `RuleSchoolEntry`：按规则编号/分类索引的条目。
3. UI 组件必须根据字段是否为空进行分区显示，不应把“课义/解曰/断曰”硬编码为所有流派必有。

### 8.3 `SchoolRegistry`

职责：

- 管理流派注册、默认流派、查找、清空测试状态。

当前实现方向合理，但需要补充测试契约：

- 第一个注册流派自动成为默认流派。
- `setDefault` 对未知 ID 返回 `false`。
- `unregister` 默认流派后应选择新的默认流派或清空默认。
- `clear` 只用于测试，不应在生产流程里随意调用。

### 8.4 `YudingSchool`

职责：

- 作为御定派适配器，把 `御定大六壬.json` 暴露为 `SchoolEntry` 列表。

当前草稿问题：

1. `YudingEntry` 在 `lib/data/schools/yuding_school.dart` 中重新定义，与 `lib/domain/entities/yuding_entry.dart` 的旧类并存，命名容易混淆。
2. `loadData` catch 后把 `_isLoaded` 设为 true 且 `_rawData` 为空，UI 会看起来像“加载成功但无数据”，不利于定位资源路径错误。
3. 与 `DaLiuRenRepositoryImpl.getYuDingData()` 的旧加载路径并存，容易形成双数据源。

设计建议：

- 短期允许并存，但必须在实现计划中明确迁移顺序。
- 中期统一为一个御定条目模型或清晰命名，例如 `YudingSchoolEntry`。
- 加载失败应保留错误状态或至少记录可测试的失败结果。

### 8.5 `BifaSchool`

职责：

- 以《毕法赋》100 条法则作为规则库流派。

设计原则：

- 不强制依赖日干支和局名。
- 支持按编号、分类、标签和盘面特征检索。
- 数据未完全校勘前，可以先以 schema、样例数据和 UI 适配证明架构成立。

一期建议 API：

```text
getRuleById(ruleId)
matchByCategory(category)
searchByTag(tag)
matchEntries(dayJiaZi, juName) -> 可返回空列表或基于规则条件返回候选
```

如果接口暂时不能增加这些方法，可以先在 `BifaSchool` 内部实现，并在后续计划中升级 `DaLiuRenSchool` 接口。

## 9. 数据设计

### 9.1 资源目录

当前 `pubspec.yaml` 已包含：

```yaml
assets:
  - assets/da_liu_ren/
```

因此新增子目录通常可以被 Flutter 资产系统包含，但实现前仍需验证打包行为。

推荐目录：

```text
assets/da_liu_ren/
  schools/
    yuding/
      data.json
      manifest.json
    bifa/
      data.json
      manifest.json
  common/
    ju_mapper.json
    keti_data.json
  legacy/
    御定大六壬.json
```

迁移策略：

1. 不在第一步移动旧 JSON，先保留旧路径，降低回归风险。
2. 新增 `schools/yuding/data.json` 时，先保证内容与旧 JSON 等价。
3. 等 Repository、YudingSchool、测试全部稳定后，再考虑去除旧路径。

### 9.2 Manifest

每个流派应有 manifest：

```json
{
  "school_id": "yuding",
  "display_name": "御定大六壬",
  "representative_book": "御定大六壬直指",
  "era": "清代",
  "entry_index_type": "pan",
  "data_version": "2026-05-23",
  "source_note": "迁移自现有 assets/da_liu_ren/御定大六壬.json"
}
```

毕法赋：

```json
{
  "school_id": "bifa",
  "display_name": "毕法赋",
  "representative_book": "毕法赋",
  "era": "宋代",
  "entry_index_type": "rule",
  "expected_entry_count": 100,
  "data_version": "2026-05-23",
  "source_note": "待校勘数据，需记录版本来源"
}
```

`entry_index_type` 是关键字段，用来告诉 UI 和测试该流派的主索引方式：

- `pan`：按日干支/局/盘面索引。
- `rule`：按规则编号/分类/标签索引。
- `case`：按案例索引。
- `topic`：按占事主题索引。

## 10. UI 设计

### 10.1 流派选择器

`SchoolSelectorWidget` 已有草稿，方向正确，但需要产品化约束：

1. 空注册表不能只 `SizedBox.shrink`，正式页面应有可诊断状态。
2. 当前卡片宽度 150、高度 120，中文长标题可能截断，需在视觉验收中检查。
3. 选择变化应触发数据重载和错误状态清理。

### 10.2 条目展示组件

`SchoolEntryDisplayWidget` 已有草稿，适合御定条目，但对毕法赋需要扩展：

1. 对空字段不显示对应 section。
2. 对规则型流派显示“编号、分类、歌诀、解释、例证、相关规则”。
3. 经典引用应继续保留，作为传统文本可追溯的关键能力。

### 10.3 主页面集成

一期不要把所有旧页面一起迁移。建议先选一个稳定入口：

1. 新版 `DaLiuRenView` 或演示页中接入流派选择器。
2. 保留旧 `my_home_page.dart` 和 `new_home_page.dart` 的御定展示，直到新路径通过回归。
3. 新旧入口并行一段时间，测试通过后再统一入口。

## 11. 数据流设计

推荐目标数据流：

```text
SchoolInitialization.initialize()
  -> register YudingSchool
  -> register BifaSchool

DaLiuRenViewModel / UseCase
  -> calculateDivination()
  -> get current pan
  -> selected school id
  -> SchoolRegistry.get(id)
  -> school.matchEntries(...) or school-specific rule lookup
  -> SchoolEntry list
  -> SchoolEntryDisplayWidget
```

关键边界：

- 排盘计算仍属于现有计算服务。
- 流派层负责解释条目匹配。
- UI 不直接读取 JSON。
- Repository 不应永久保留 `getYuDingData()` 作为唯一解释数据出口。

## 12. 错误处理设计

必须定义以下状态：

1. 没有注册任何流派。
2. 默认流派不存在。
3. 某流派数据加载失败。
4. 某流派加载成功但没有匹配条目。
5. 某流派数据 schema 不合法。
6. 资产路径不存在。

建议行为：

- 开发/测试环境中暴露明确错误。
- 用户界面上显示“暂无匹配解释”或“流派数据暂不可用”，不能崩溃。
- 日志中保留流派 ID、资产路径、异常类型。

## 13. 分阶段交付

### Phase 0：确认基线

目标：

- 固化当前御定派行为。
- 明确现有多流派草稿文件哪些可保留。

输出：

- 御定派数据加载样例。
- 当前 UI 展示样例。
- 现有测试清单。

### Phase 1：流派抽象整理

目标：

- 确定 `DaLiuRenSchool`、`SchoolEntry`、`SchoolRegistry` 的最终一期接口。
- 清理命名冲突。

输出：

- 接口文档。
- 注册表行为说明。
- 流派初始化规则。

### Phase 2：御定派适配

目标：

- `YudingSchool` 成为御定解释数据的标准适配器。
- 旧 Repository 路径与新 School 路径有清晰兼容关系。

输出：

- 御定条目从旧数据到 `SchoolEntry` 的映射说明。
- 旧路径兼容说明。

### Phase 3：通用 UI 接入

目标：

- 流派选择器可用。
- 通用条目展示对御定派可用。
- 对非御定字段为空时不出现奇怪空 section。

输出：

- 主入口或演示入口集成说明。
- UI 验收标准。

### Phase 4：毕法赋接入准备

目标：

- 明确毕法赋数据结构。
- 创建样例数据或完整数据的校验规范。
- 证明规则型流派可被展示。

输出：

- `BifaSchool` 设计说明。
- 数据 schema。
- 后续数据生产 Story 建议。

## 14. 验收标准重写建议

建议将 Story #7 验收标准改为：

1. 御定大六壬仍为默认流派，现有排盘和解释展示无回归。
2. `DaLiuRenSchool`、`SchoolEntry`、`SchoolRegistry` 的行为有明确测试覆盖。
3. 御定数据可通过 `YudingSchool` 加载并转换为 `SchoolEntry`。
4. UI 层可展示已注册流派，并能选择流派。
5. 通用条目展示组件能展示御定条目，并对空字段安全。
6. 毕法赋的规则型数据结构和接入方式已明确，不再强行套用御定索引。
7. 资产路径、加载失败、无匹配条目都有可诊断行为。
8. 文档明确后续流派扩展流程：准备数据、实现 School、注册、测试、接入 UI。

## 15. 风险

| 风险 | 影响 | 缓解 |
| --- | --- | --- |
| 把八个流派都塞入当前 Story | 需求失控 | 当前 Story 只做架构和首个扩展流派准备 |
| `SchoolEntry` 过度御定化 | 毕法赋、壬归等不自然 | 允许索引类型差异，后续拆分 RuleEntry |
| 新旧御定模型并存 | 命名混乱，数据不一致 | 设计迁移阶段，避免双源长期存在 |
| 资产移动造成回归 | 线上数据加载失败 | 先兼容旧路径，再迁移 |
| UI 只服务御定字段 | 新流派空白或展示怪异 | 条件渲染与规则型展示 |
| 缺少黄金样例 | 无法证明玄学计算未回归 | 测试任务中定义黄金向量 |

## 16. 后续拆单建议

Story #7 完成设计后，建议拆出：

1. Task：整理并定稿流派接口。
2. Task：御定派适配器产品化。
3. Task：注册表与初始化测试。
4. Task：通用流派 UI 接入。
5. Task：毕法赋 schema 与样例数据。
6. Story：毕法赋 100 条数据校勘与完整接入。
7. Story：课经派 64 课体接入。
8. Story：指南派案例库接入。

## 17. 本任务完成定义

Task #28 完成条件：

- 已明确 Story #7 的需求边界。
- 已给出推荐架构方案。
- 已标出当前代码草稿与旧代码耦合点。
- 已定义分阶段交付、风险和验收标准。
- 未进行生产代码修改。

本文件满足以上条件，可作为 Task #28 的交付文档。

## 18. 需求讨论补充：第一阶段实施共识

2026-05-23 与 xuan 继续澄清后，Story #7 第一阶段实施边界更新如下。

### 18.1 第一阶段目标

第一阶段采用“架构底座优先”。完整数据源整理稍后进行；除数据源完整整理之外，其余支撑多流派入口、状态展示、调试验证的能力应同步开始。

第一阶段必须启动：

1. `SchoolCatalog`：定义所有规划流派的元信息、状态、用户偏好排序。
2. `SchoolRegistry`：继续承担已实现流派 provider 注册。
3. 客盘页流派切换栏：在起盘结果页展示所有规划流派。
4. planned 空状态：未接入流派可点击，并展示路线图提示。
5. DevPage 调试入口：用统一解释组件验证御定数据和后续样例流派。
6. 御定双轨验证：正式客盘页继续沿用现有御定展示，DevPage 验证新统一组件。

第一阶段暂不做：

1. 毕法赋 100 条完整录入和校勘。
2. 八流派全部真实实现。
3. 用户自定义流派排序。
4. 记忆最近使用流派。
5. 重写起盘核心算法。

### 18.2 流派不是起盘参数

流派选择不出现在起盘前。用户不需要先选择流派才能起盘。

正确交互是：

```text
用户完成起盘
  -> 客盘页显示盘面
  -> 客盘页显示横向可滑动流派 tab/slider bar
  -> 用户点击流派
  -> 只切换解释区，不重新起盘
```

因此，`DaLiuRenSchool` 更准确的职责不是“参与排盘”，而是“基于已生成盘面提供解释视角”。后续接口应逐步从 `matchEntries(String dayJiaZi, String juName)` 演进到接受盘面上下文，例如 `SchoolMatchContext`。

### 18.3 客盘页 UI

客盘页分为两个稳定区域：

```text
[盘面区：天地盘 / 四课 / 三传 / 神煞等]
[流派解释区：横向可滑动 tab/slider bar + 当前流派解释内容]
```

点击 tab 只刷新流派解释区，不影响盘面区。

### 18.4 八个流派全部展示

第一阶段客盘页展示全部八个流派，而不是只展示已实现流派。使用横向可滑动 slider bar 承载，避免移动端拥挤。

固定默认排序按用户偏好，而不是开发优先级：

```text
御定 / 毕法赋 / 指南 / 课经 / 大六壬大全 / 壬归 / 六壬粹言 / 管辂神书
```

排序依据：

1. 经典权威感。
2. 用户可读性和实用感。
3. 学习和占断中的常用程度。

第一阶段不做用户自定义排序，也不记忆最近使用。

### 18.5 planned 流派空状态

未接入流派不是禁用状态，而是可点击的路线图状态。用户点击后，内容区展示：

1. 流派名称。
2. 代表书籍。
3. 简短简介。
4. 当前状态：正在整理中。
5. 标签，例如“法则”“案例”“课体”“事项分类”。

内容区状态必须区分：

- `available`：流派已接入，展示真实解释内容。
- `planned`：流派规划中，展示路线图提示。
- `empty`：流派已接入，但当前盘无匹配解释。
- `error`：流派已接入，但数据加载失败。

### 18.6 正式页与 DevPage 双轨验证

第一阶段采用双轨验证：

正式客盘页：

1. 展示八流派 slider bar。
2. 默认选中御定。
3. 御定内容沿用现有正式展示样式，降低回归风险。
4. 未接入流派展示路线图提示。

DevPage：

1. 增加多流派调试入口。
2. 使用新的统一解释组件验证御定真实数据。
3. 后续可接毕法赋样例数据。
4. 不进入正式导航，不影响普通用户路径。

### 18.7 SchoolCatalog 放置

`SchoolCatalog` 第一阶段放在 domain 层，例如：

```text
lib/domain/schools/school_catalog.dart
```

原因：有哪些流派、显示顺序、接入状态、代表书籍、简介，是产品业务事实，不只是 UI 配置，也不应过早绑定 data 层数据来源。
