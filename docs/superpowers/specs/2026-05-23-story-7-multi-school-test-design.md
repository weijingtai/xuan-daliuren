# Story 7 大六壬多流派架构重构测试工程与验收设计

> ZenTao Story: #7 大六壬多流派架构重构  
> ZenTao Task: #29 Story#7 测试工程介入与验收设计  
> 产品: xuan-daliuren  
> 日期: 2026-05-23  
> 交付性质: 测试需求分析与验收设计文档，不包含代码实现

## 1. 测试结论摘要

Story #7 的测试策略不能停留在“单元测试全部通过”。它涉及传统术数数据、排盘解释、流派抽象、UI 展示和数据资产迁移，必须从需求阶段建立可验证边界。

测试工程的核心目标：

1. 证明御定派在重构前后无回归。
2. 证明流派注册、加载、选择、展示的基础机制可靠。
3. 证明毕法赋这类“规则型流派”不会被御定派数据模型错误约束。
4. 通过黄金测试向量保证玄学计算和解释匹配有可重复证据。
5. 通过 gStack 或等价证据留存 UI 验收结果，并回填禅道。

## 2. 测试对象

### 2.1 领域接口

- `DaLiuRenSchool`
- `SchoolEntry`
- `SchoolRegistry`

### 2.2 流派实现

- `YudingSchool`
- 后续 `BifaSchool`

### 2.3 数据资产

- `assets/da_liu_ren/御定大六壬.json`
- `assets/da_liu_ren/ju_mapper.json`
- `assets/da_liu_ren/甲午庚牛羊_阳.json`
- `assets/da_liu_ren/甲午庚牛羊_阴.json`
- 后续 `assets/da_liu_ren/schools/bifa/data.json`

### 2.4 UI

- `SchoolSelectorWidget`
- `SchoolEntryDisplayWidget`
- `SchoolDemoPage`
- 后续正式入口页

### 2.5 旧路径兼容

- `DaLiuRenRepositoryImpl`
- `YuDingDisplayWidget`
- `my_home_page.dart`
- `new_home_page.dart`

## 3. 测试范围

### 3.1 范围内

1. 流派注册表行为测试。
2. 御定派数据加载和映射测试。
3. 毕法赋数据结构和契约测试。
4. UI 选择、展示、空状态、错误状态测试。
5. 现有排盘和三传/四课计算回归测试。
6. 资产路径与加载失败测试。
7. 黄金向量定义和最小样例落地。

### 3.2 范围外

1. 人工校勘八个流派全部数据。
2. 证明所有古籍解释绝对正确。
3. 重写或全面验证所有排盘算法。
4. 生产环境性能压测。
5. 自动化覆盖所有 UI 视觉细节。

## 4. 测试分层

### 4.1 单元测试

目标：

- 验证纯逻辑行为。

覆盖：

- `SchoolRegistry`
- `YudingSchool` 数据映射
- `BifaSchool` 数据 schema
- `SchoolEntry` 字段转换
- 数据加载异常处理

### 4.2 数据契约测试

目标：

- 验证 JSON 结构符合流派契约。

覆盖：

- 顶层字段完整。
- 条目数量符合预期。
- 必填字段非空。
- 编号唯一。
- 引用字段类型正确。
- 不同索引类型字段规则不同。

### 4.3 集成测试

目标：

- 验证 Repository、初始化、流派注册和 UI 数据源之间的连接。

覆盖：

- `SchoolInitialization.initialize()`
- 默认流派注册后可查询。
- 御定数据可从流派接口获取。
- 主页面或演示页能读取注册表。

### 4.4 Widget 测试

目标：

- 验证 UI 对状态的响应。

覆盖：

- 空注册表。
- 一个流派。
- 多个流派。
- 当前选中流派。
- 点击切换回调。
- 条目字段完整。
- 条目字段为空。
- 规则型条目。

### 4.5 回归测试

目标：

- 保证重构不改变已有核心行为。

覆盖：

- 现有 `test/da_liu_ren_test.dart`
- 现有九宗门测试：
  - 贼克
  - 比用
  - 涉害
  - 遥克
  - 昴星
  - 伏吟
  - 返吟
  - 别责
  - 八专
- 神煞相关测试。

### 4.6 gStack / 浏览器 QA

目标：

- 对用户可见行为留证。

覆盖：

- 流派选择器可见。
- 御定派默认选中。
- 切换到毕法赋后页面不崩溃。
- 空结果显示清晰。
- 加载失败状态可见。

## 5. 黄金测试向量策略

玄学计算的正确性不能靠“看起来合理”判断，必须建立黄金向量。

### 5.1 黄金向量定义

一个黄金向量至少包含：

```json
{
  "id": "yuding-jiazi-ju-1",
  "school_id": "yuding",
  "input": {
    "day_jia_zi": "甲子",
    "ju_name": "子",
    "ju_number": 1
  },
  "expected": {
    "entry_count": 1,
    "ke_ti_names": ["伏吟", "元胎"],
    "title_contains": "甲子",
    "source": "御定大六壬.json"
  },
  "source_note": "来自现有御定数据，重构前后必须一致"
}
```

毕法赋向量：

```json
{
  "id": "bifa-rule-001",
  "school_id": "bifa",
  "input": {
    "rule_id": 1
  },
  "expected": {
    "title": "前后引从升迁吉",
    "category": "三传",
    "has_explanation": true
  },
  "source_note": "来自毕法赋数据格式说明中的首条规则样例"
}
```

### 5.2 黄金向量分类

1. 御定条目匹配向量。
2. 御定日干支查询向量。
3. 排盘/三传/四课计算向量。
4. 毕法赋规则编号向量。
5. 毕法赋分类检索向量。
6. UI 状态向量。

### 5.3 最小向量集

Story #7 一期至少需要：

| 类型 | 数量 | 用途 |
| --- | --- | --- |
| 御定按日局匹配 | 3 | 防止 YudingSchool 映射错 |
| 御定按日查询 | 2 | 防止 supportedDays / getEntriesByDay 错 |
| 注册表行为 | 6 | 防止默认流派、清空、重复注册错 |
| 毕法赋规则样例 | 3 | 证明规则型流派可表达 |
| UI 状态 | 5 | 防止空状态、切换、展示崩溃 |

## 6. 详细测试矩阵

### 6.1 `SchoolRegistry`

| 用例 | 前置 | 操作 | 期望 |
| --- | --- | --- | --- |
| 空注册表 | `clear()` | 读取 `all` | 返回空列表 |
| 注册第一个流派 | 空注册表 | 注册 yuding | `defaultSchool.id == yuding` |
| 注册多个流派 | yuding 已注册 | 注册 bifa | `count == 2` |
| 设置默认流派成功 | yuding/bifa 已注册 | `setDefault(bifa)` | 返回 true |
| 设置未知默认流派 | yuding 已注册 | `setDefault(unknown)` | 返回 false，默认不变 |
| 注销默认流派 | yuding/bifa 已注册且默认 yuding | `unregister(yuding)` | 默认切到剩余流派 |
| 清空注册表 | 有流派 | `clear()` | `count == 0` 且默认为空 |

### 6.2 `YudingSchool`

| 用例 | 输入 | 期望 |
| --- | --- | --- |
| 加载御定数据 | 调用 `loadData()` | `isLoaded == true`，`entryCount > 0` |
| 重复加载 | 连续调用 `loadData()` | 不重复解析，不抛错 |
| 按日干支查询 | `getEntriesByDay(甲子)` | 返回非空或与黄金向量一致 |
| 按日局匹配 | `matchEntries(甲子, 子)` | 返回与旧数据一致的条目 |
| 未知日干支 | `getEntriesByDay(不存在)` | 返回空列表 |
| 资产路径错误 | 模拟加载失败 | 明确失败状态或空数据，并有日志 |

### 6.3 `BifaSchool`

| 用例 | 输入 | 期望 |
| --- | --- | --- |
| 数据数量 | 加载毕法赋数据 | 完整数据应为 100 条 |
| 编号唯一 | entries | 1-100 不重复 |
| 标题非空 | 每条规则 | title 不为空 |
| 分类合法 | 每条规则 | 分类属于约定集合 |
| 相关规则存在 | related_rules | 指向有效编号 |
| 按编号查询 | `getRuleById(1)` | 返回第一条规则 |
| 按分类查询 | `matchByCategory(三传)` | 返回三传类规则 |
| 盘索引查询 | `matchEntries(day, ju)` | 可返回空，但不能抛错 |

### 6.4 `SchoolEntryDisplayWidget`

| 用例 | 输入 | 期望 |
| --- | --- | --- |
| 御定完整条目 | 所有字段完整 | 显示标题、课体、课义、解曰、断曰、杂占、经典 |
| 空字段条目 | meaning/explanation 为空 | 不显示空 section，不留奇怪空白 |
| 无经典引用 | bookReferences 为空 | 不显示经典引用区 |
| 规则型条目 | 毕法赋字段映射 | 显示标题、分类/标签、原文/解释 |
| 长文本 | 大段解释 | 不溢出，不遮挡后续内容 |

### 6.5 `SchoolSelectorWidget`

| 用例 | 前置 | 期望 |
| --- | --- | --- |
| 无流派 | 注册表为空 | 显示可诊断空状态或至少不崩溃 |
| 单流派 | 仅 yuding | 默认选中御定 |
| 多流派 | yuding + bifa | 两个流派均可见 |
| 点击切换 | 点击 bifa | 回调 schoolId 为 bifa |
| 长标题 | 大六壬大全派等 | 文本不溢出卡片 |

## 7. 回归测试要求

### 7.1 必跑命令

实现完成后至少运行：

```bash
flutter test
```

如果测试时间过长，至少拆分运行：

```bash
flutter test test/da_liu_ren_test.dart
flutter test test/nine_zong_men_zei_ke_test.dart
flutter test test/domain/services/shen_sha_calculation_test.dart
```

### 7.2 不能接受的回归

以下任一情况发生，即 Story #7 不应进入 Done：

1. 现有九宗门测试失败。
2. 御定 JSON 加载失败但 UI 静默显示“暂无数据”。
3. 默认流派为空。
4. 流派切换导致页面崩溃。
5. 毕法赋规则型数据必须伪造日干支才能展示。
6. 资产路径在 Web/移动端不一致且未测试。

## 8. 数据契约

### 8.1 御定数据契约

御定条目至少需要：

- `dayJiaZi`
- `juName`
- `juNumber`
- `body`
- `meaning`
- `explain`
- `predication`
- `details`
- `books`

映射到 `SchoolEntry`：

| JSON 字段 | SchoolEntry 字段 |
| --- | --- |
| `dayJiaZi` | `dayJiaZi` |
| `juName` | `juName` |
| `juNumber` | `juNumber` |
| `body` | `keTiNames` |
| `meaning` | `meaning` |
| `explain` | `explanation` |
| `predication` | `prediction` |
| `details` | `details` |
| `books` | `bookReferences` |

### 8.2 毕法赋数据契约

毕法赋条目至少需要：

- `id`
- `title`
- `category`
- `content`
- `explanation`
- `examples`
- `related_rules`
- `tags`

建议增加：

- `source`
- `source_version`
- `normalized_text`
- `notes`

### 8.3 数据失败处理

加载失败不能与“加载成功但无数据”混淆。测试应区分：

1. 文件不存在。
2. JSON 语法错误。
3. JSON 顶层类型错误。
4. 条目字段缺失。
5. 数据为空。
6. 查询无匹配。

## 9. 验收门禁

### 9.1 需求门禁

进入实现前必须确认：

- Story #7 不要求一次性完成八流派。
- 毕法赋接入目标是验证扩展架构，不是立即完成全部人工校勘。
- 御定派是默认流派和回归基线。

### 9.2 开发门禁

开发提交前必须确认：

- 没有删除旧御定路径，除非已有等价测试证明。
- 新增流派不会影响现有排盘算法。
- 注册表测试通过。
- 数据加载失败可诊断。

### 9.3 测试门禁

测试通过条件：

- `flutter test` 或批准的拆分测试通过。
- 新增流派相关单元测试通过。
- UI 状态测试通过。
- 至少有一个 gStack/浏览器 QA 证据用于流派选择器和条目展示。

### 9.4 禅道门禁

禅道流转建议：

- Task 完成：Codex 可完成。
- Story Done：AI 可建议。
- Story Closed：保留给 xuan 人工确认。

## 10. 缺陷记录规则

如果测试发现问题：

1. 优先在禅道 `xuan-daliuren` 产品下创建 Bug。
2. Bug 标题包含模块和症状，例如：
   - `SchoolRegistry 默认流派注销后为空状态未处理`
   - `YudingSchool 加载失败被误判为空数据`
3. 如果属于已知问题，追加评论，不重复建 Bug。
4. Bug 修复后必须写入 `S:P:DaLiuRen`，遵守项目 Hindsight 模板。

## 11. 测试数据准备

### 11.1 御定测试数据

从现有 `御定大六壬.json` 中抽取：

1. 甲子日样例。
2. 不同局号样例。
3. 带 `details` 和 `books` 的样例。

### 11.2 毕法赋测试数据

先准备 3-5 条样例即可：

1. 三传类一条。
2. 四课类一条。
3. 天将类一条。
4. 带 related_rules 的一条。
5. 带 examples 的一条。

完整 100 条可作为后续 Story。

### 11.3 UI 测试数据

构造：

1. 完整御定条目。
2. 最小御定条目。
3. 毕法赋规则条目。
4. 空详情条目。
5. 长文本条目。

## 12. gStack QA 场景

### 场景 1：默认流派

步骤：

1. 打开大六壬页面或流派演示页。
2. 观察默认流派。
3. 截图。

期望：

- 默认显示御定大六壬。
- 页面不崩溃。
- 有条目或明确空状态。

### 场景 2：切换流派

步骤：

1. 点击毕法赋。
2. 等待内容刷新。
3. 截图。

期望：

- 选中态切换。
- 内容区刷新。
- 没有旧御定条目残留。

### 场景 3：无匹配结果

步骤：

1. 选择某个无匹配输入。
2. 查看内容区。

期望：

- 显示“暂无匹配解释”一类状态。
- 不显示技术异常堆栈。

### 场景 4：加载失败

步骤：

1. 在测试环境模拟资产缺失。
2. 打开页面。

期望：

- 显示流派数据不可用。
- 日志有具体流派 ID 与路径。

## 13. 任务完成定义

Task #29 完成条件：

- 已定义测试范围。
- 已定义单元、数据契约、集成、Widget、回归、QA 分层。
- 已给出黄金向量策略。
- 已给出验收门禁。
- 已说明缺陷记录和 Hindsight 写入规则。
- 未进行生产代码修改。

本文件满足以上条件，可作为 Task #29 的交付文档。

## 14. 需求讨论补充后的测试调整

2026-05-23 继续需求讨论后，Story #7 第一阶段确认采用“客盘页全流派 slider bar + planned 路线图状态 + DevPage 双轨验证”。测试设计同步调整如下。

### 14.1 新增 UI 验收点

客盘页必须验证：

1. 起盘前不要求选择流派。
2. 起盘后出现横向可滑动流派 tab/slider bar。
3. 八个流派全部出现。
4. 默认选中“御定”。
5. tab 顺序为：御定、毕法赋、指南、课经、大六壬大全、壬归、六壬粹言、管辂神书。
6. 点击未接入流派不重新起盘。
7. 点击未接入流派显示路线图提示，不显示错误。
8. 切回御定后，正式御定展示仍可用。

### 14.2 新增状态测试

`SchoolCatalog` 和解释区状态至少覆盖：

| 状态 | 测试输入 | 期望 |
| --- | --- | --- |
| available | 御定 | 展示正式御定内容 |
| planned | 毕法赋等未接入流派 | 展示流派名称、代表书籍、简介、正在整理中 |
| empty | 已接入但无匹配 | 展示暂无匹配解释 |
| error | 已接入但加载失败 | 展示数据不可用，并可诊断 |

### 14.3 DevPage 验收点

DevPage 必须验证：

1. 有多流派调试入口。
2. 可使用统一解释组件展示御定数据。
3. 不影响正式导航。
4. 可作为后续毕法赋样例验证入口。

### 14.4 回归保护

正式客盘页第一阶段仍沿用现有御定展示样式。测试应重点确认：

1. 御定正式解释展示未因 slider bar 接入而回归。
2. 盘面区不受流派 tab 切换影响。
3. 切换 planned 流派后再切回御定，盘面和御定解释仍一致。

## 15. BDD 逆向测试设计

BDD 逆向测试不是普通负向测试。普通负向测试验证系统面对异常输入时是否稳定；BDD 逆向测试用于反向审查 BDD 文档本身，确认用户行为场景没有遗漏、歧义或错误诱导。

Story #7 的 BDD 逆向测试应在 UI/UX Design 和 BDD Design 完成后执行，作为进入实现前的测试工程门禁。

### 15.1 测试对象

BDD 逆向测试的对象包括：

1. UI/UX Design 文档。
2. BDD Design 文档。
3. Story #7 需求描述。
4. 项目结构 Plan。
5. Test Plan Design 本文档。

### 15.2 逆向审查目标

逆向审查必须回答：

1. BDD 是否会让开发误以为“流派”是起盘前参数。
2. BDD 是否明确流派切换发生在客盘结果页。
3. BDD 是否明确切换流派不重新起盘。
4. BDD 是否覆盖八个流派全部可见。
5. BDD 是否覆盖横向 slider/tab bar 的滚动访问。
6. BDD 是否覆盖默认选中御定。
7. BDD 是否覆盖 planned 流派的路线图状态。
8. BDD 是否覆盖 available、planned、empty、error 四类状态。
9. BDD 是否覆盖切换 planned 流派后再切回御定。
10. BDD 是否区分正式客盘页和 DevPage。

### 15.3 逆向测试矩阵

| 逆向问题 | 失败表现 | 必须补充的 BDD 场景 |
| --- | --- | --- |
| 把流派当成起盘参数 | 起盘前出现必选流派 | Given 用户尚未起盘，Then 页面不要求选择流派 |
| 切换流派导致重新起盘 | 盘面、时间、四课三传被刷新 | Given 用户已起盘，When 切换流派，Then 盘面保持不变 |
| 只覆盖已实现流派 | 未实现流派没有入口 | Given 用户进入客盘页，Then 八个流派 tab 均可访问 |
| 忽略窄屏滚动 | 后几个流派不可见或不可点 | Given 屏幕宽度不足，When 横向滚动，Then 可访问管辂神书 |
| planned 状态被当成错误 | 未接入流派显示异常或空白 | When 点击毕法赋，Then 显示路线图提示而不是错误 |
| 御定回归未覆盖 | 切回御定后解释缺失 | When 从 planned 流派切回御定，Then 御定解释恢复且盘面不变 |
| DevPage 与正式页混淆 | DevPage 的统一组件行为被误当正式验收 | Given 在 DevPage，Then 验收目标是组件验证而非正式客盘样式 |
| 状态分类不完整 | empty 与 error 被同一文案掩盖 | Then empty 显示暂无匹配，error 显示数据不可用 |

### 15.4 逆向测试输出

BDD 逆向测试完成后必须输出：

1. BDD 场景遗漏清单。
2. BDD 场景歧义清单。
3. UI Design 与 BDD 不一致清单。
4. 可直接转化为 Widget、Integration、gStack QA 的场景清单。
5. 是否允许进入实现的结论。

### 15.5 禅道任务建议

在 UI/UX Design 和 BDD Design 两个任务完成后，新增并执行：

- `Story#7 BDD 逆向测试与验收场景审查`

该任务不编写生产代码，产物是逆向测试报告和修订后的 BDD 场景清单。
