---
id: 2026-05-25-story-7-ui-design-contract
type: ui-ux-design-contract
story: ZenTao Story #7
tasks: [ZenTao#36, ZenTao#37, ZenTao#38, ZenTao#39]
role: ui-ux-designer
required_skill_used: ui-ux-pro-max
date: 2026-05-25
---

# UI/UX Design Contract — Story #7 Multi-School (Stage 1)

## Source

- Task:
  - ZenTao #36 — `SchoolSliderBar` (`lib/presentation/widgets/school_slider_bar.dart`)
  - ZenTao #37 — `PlannedSchoolRoadmapWidget` + `SchoolExplanationPanel` (`lib/presentation/widgets/planned_school_roadmap_widget.dart`, `lib/presentation/widgets/school_explanation_panel.dart`)
  - ZenTao #38 — 客盘页集成 (`lib/presentation/views/widgets/divination_display_widget.dart`)
  - ZenTao #39 — DevPage 多流派调试入口 (`lib/pages/dev.dart`)
- Product type: 文化/术数移动应用 (Tool + Content hybrid; reference / scholarly reading surface)
- Platform / stack: Flutter (module `daliuren`), Material 3 Theme, Provider, MVVM/Repository。无新依赖。
- Target users: 大六壬学习者与术数研究者（识繁体中文，期望经典文风的版式与术语层级）。
- Target surface:
  1. 正式客盘结果页 (`DivinationDisplayWidget`) — 起盘后插入流派条带 + 解释区
  2. DevPage (`lib/pages/dev.dart`) — 调试入口，组件级双轨验证
- Authoritative refs:
  - 实施计划: `xuan-daliuren/docs/superpowers/plans/2026-05-23-story-7-multi-school-foundation.md`
  - 测试设计 §14: `xuan-daliuren/docs/superpowers/specs/2026-05-23-story-7-multi-school-test-design.md`
  - 流派目录数据源: `lib/domain/schools/school_catalog.dart` (按计划 Step 3 实现)
  - 现有展示参考: `lib/presentation/widgets/school_entry_display_widget.dart`, `lib/presentation/widgets/yu_ding_display_widget.dart`

## Required Skill

`ui-ux-pro-max` used: **yes**

调用记录与采纳：
- 调用了 Skill `ui-ux-pro-max`（args: `设计契约 大六壬流派切换 slider + planned 路线图 + 解释面板 + DevPage 验证段`），采用其 Quick Reference 中的以下规则集落到本契约：
  - §1 a11y: `color-contrast`、`focus-states`、`color-not-only`、`reduced-motion`、`dynamic-type`
  - §2 touch: `touch-target-size`、`touch-spacing`、`press-feedback`、`gesture-feedback`
  - §4 style: `style-match`、`consistency`、`state-clarity`、`primary-action`
  - §5 layout: `mobile-first`、`spacing-scale`、`horizontal-scroll`、`content-priority`
  - §7 motion: `duration-timing`、`transform-performance`、`motion-meaning`、`interruptible`
  - §9 nav: `nav-state-active`、`back-stack-integrity`、`empty-nav-state`、`navigation-consistency`
  - Common Rules: 8dp spacing rhythm、no-emoji-icons、token-driven theming
- ui-ux-pro-max 强调 Pre-Delivery Checklist：本契约的 Accessibility / Handoff 节落地了清单中可独立验证的条目。

## Design Direction

### Style

- 主基调: **Minimal + Content-first**，与现有 `SchoolEntryDisplayWidget` 的卡片风格保持一致 (consistency 规则)；不引入 glass/clay/brutalism 等装饰风格。
- 流派条带使用“**横向 Pill / Chip tab**”而非整张大卡片选择器，与现行的内容密度匹配（避免占用过多结果页纵向空间）。
- planned 状态不是 disabled 而是“可访问的次级形态”——通过 subtle 视觉差异表达（不锁定交互）。

### Color System

全部从 `Theme.of(context)` 解析；**不写死十六进制**（token-driven theming）。

| Token | Source | 用途 |
|---|---|---|
| `selectedBg` | `Theme.of(context).colorScheme.primary` | 选中 tab 背景 |
| `selectedFg` | `Theme.of(context).colorScheme.onPrimary` | 选中 tab 文字 |
| `availableUnselectedBg` | `Theme.of(context).colorScheme.surfaceContainerHighest`（或 `surfaceVariant` 兜底） | 未选中 available tab 背景 |
| `availableUnselectedFg` | `Theme.of(context).colorScheme.onSurface` | 未选中 available tab 文字 |
| `plannedBg` | `Colors.transparent` + 1.5px 描边 `colorScheme.outlineVariant` | planned tab 容器 |
| `plannedFg` | `Theme.of(context).colorScheme.onSurfaceVariant` | planned tab 文字 |
| `plannedDot` | `Theme.of(context).colorScheme.tertiary` (或 `secondary` 兜底) | planned 状态点 |
| `roadmapAccent` | `colorScheme.primary.withOpacity(0.08)` | RoadmapWidget 背景层 |
| `errorFg` | `Theme.of(context).colorScheme.error` | error 态文案 |

对比度要求（必须由 coder 验证）：
- 选中 tab 文字 / 选中 tab 底色 ≥ 4.5:1
- planned tab 文字 / 页面背景 ≥ 4.5:1（state 不允许仅靠描边表达——必须有“正在整理中”文字 + 状态点同时出现）

### Typography

沿用 `Theme.of(context).textTheme`，不引入新字体。

| 用途 | 规则 |
|---|---|
| Tab label | `bodyMedium` (fontSize 14)，选中态 `fontWeight: FontWeight.w600`；未选中 `w500` |
| RoadmapWidget 标题（流派 displayName） | `titleLarge` ≈ 22 / `w600` |
| RoadmapWidget 代表书籍 | `titleSmall` 14 / `w500` / italic 可选 |
| RoadmapWidget 简介 body | `bodyMedium` 14 / `height: 1.6`（贴合长文阅读） |
| Tag chip 文本 | `labelSmall` 11–12 / `w500` |
| 状态徽标 (“正在整理中”) | `labelMedium` 12 / `w600` |
| Empty / Error 主文案 | `bodyLarge` 16 / `w500` |

支持 Dynamic Type：所有上述字号通过 `MediaQuery.textScaleFactorOf(context)` 间接放大，最小不强制 clamp 到 ≤ 1.0；最长流派名（“大六壬大全”“管辂神书”）在 textScale=1.3 下不溢出 tab。

### Layout

- **结构 (DivinationDisplayWidget)**：
  ```
  ┌─ 已有：盘面 / 四课 / 三传 / 神煞 ───────────────┐  ← 完全不动
  │                                                  │
  ├─ NEW: 12dp 顶部留白                              │
  ├─ NEW: SchoolSliderBar (高 56dp)                  │
  ├─ NEW: 8dp 间隔                                   │
  ├─ NEW: SchoolExplanationPanel (自适应高度)         │
  └─ 24dp 底部留白                                   │
  ```
- **SchoolSliderBar**：
  - 容器高度 56dp（满足 `touch-target-size` ≥ 48dp + 上下 padding）
  - tab 高度 40dp，水平 padding 16dp，圆角 20dp（pill 风格）
  - tab 间距 8dp（`touch-spacing` 规则）
  - 横向 `SingleChildScrollView`(scrollDirection: Axis.horizontal) + `physics: BouncingScrollPhysics` 包裹 `Row`
  - 左右容器 padding 12dp；首尾使用 8dp 渐隐遮罩（可选，可下放到 coder 决定）暗示可滚动
- **SchoolExplanationPanel** (容器)：
  - 不附加 Card 外框（available 子内容 yuding 已有 Card 风格不重叠）；
  - 仅在 planned/empty/error 子组件内部使用 `Card` (`Card.elevation: 0`, `surfaceTintColor: Colors.transparent`, 1.5px outline)
- **PlannedSchoolRoadmapWidget**：
  - 内部 padding 20dp
  - 顶部：流派 displayName + 右上角 “正在整理中” 徽标 (Pill: tertiary 背景 with 0.16 opacity / tertiary 文字)
  - 第二行：代表书籍 (`representativeBook`) + era (灰度次级文本)
  - 第三行：description 段落
  - 第四行：tags `Wrap` (chip 12 字号、outline 风格)
  - 末行：辅助文案 “该流派正在整理中，后续版本将解锁完整解释。当前可继续在御定流派下查看本盘解释。”

### Component approach

- 所有 4 个文件均为新增/局部修改、**纯 widget**，无新增 Provider。
- 状态边界（critical）：
  - `DivinationDisplayWidget` 中 **不** 把整个组件转为 `StatefulWidget`；**仅**为流派切换包一个内联 `StatefulBuilder` 或最小 `StatefulWidget`（建议命名 `_SchoolSwitcherSection`），保存 `selectedSchoolId` 局部状态。
  - `selectedSchoolId` 默认值：`'yuding'`。
  - 切换 tab 仅触发该 stateful 子树 setState，**绝不**调用 ViewModel 的 `recalculate()` / `calculateDivination()`。
- DevPage 改造：在原有调试内容上方添加 `Segmented Control / ToggleButtons`（节段：`四课调试` / `多流派调试`）。多流派段使用 `SchoolSliderBar` + 已存在的 `SchoolEntryDisplayWidget` + (后续) 测试性内存条目；不接入正式导航 (`back-stack-integrity` 不变)。

## Interaction Requirements

### Navigation

- `SchoolSliderBar` 是**页面内 sub-navigation**，不是路由切换；不更改路由栈 (`back-stack-integrity` 规则)。
- planned tab 点击 = 局部状态切换 + Panel 重绘；**禁止**弹出对话框、Toast 或 Snackbar 提示（避免被误判为 error）。
- 默认选中 `yuding`（首次进入或重新起盘后），并且：
  - 切换到 planned tab 再切回 `yuding`：必须**恢复原 `YuDingDisplayWidget`**（不用 `SchoolEntryDisplayWidget` 替换），即 `available + yuding` 分支必须使用现有正式路径。
  - 这条规则在 `SchoolExplanationPanel` 内部以 `if (status == available && schoolId == 'yuding')` 优先匹配“正式 yuding 子树”；其它 available 流派（未来扩展）才用通用 `SchoolEntryDisplayWidget`。

### States

四态规范（必须分别可视化、可由 widget test 识别）：

| 状态 | 触发 | 视觉 | 文案（中文，可由 coder 微调） | 测试钩子 (Key 建议) |
|---|---|---|---|---|
| **available** (yuding) | catalog.status==available && id=='yuding' | 沿用现有 `YuDingDisplayWidget` | 现有逻辑；起盘前/无结果时由上游已隐藏 | `Key('school_panel_available_yuding')` |
| **available** (未来扩展) | catalog.status==available && id!='yuding' | `SchoolEntryDisplayWidget` 卡片 | 由 entry 字段决定 | `Key('school_panel_available_generic')` |
| **planned** | catalog.status==planned | `PlannedSchoolRoadmapWidget` | 标题 = displayName；副标题 = 代表书籍 + 朝代；body = description；徽标 = “正在整理中”；末段 = “该流派将在后续版本中开放，当前可继续使用御定流派查看解释。” | `Key('school_panel_planned_<id>')` |
| **empty** | available 但 `entries.isEmpty` | 居中图标 + 主文案 + 次文案 | 主：“暂无匹配解释”；次：“当前盘面在该流派下未找到匹配条目，可尝试切回御定。” | `Key('school_panel_empty')` |
| **error** | 加载失败 / 异常 | `colorScheme.error` 色徽标 + 错误主文案 + 可诊断信息 | 主：“数据不可用”；次：“流派数据加载失败：`<schoolId>` (`<reason>`)，请稍后重试或检查资产。” | `Key('school_panel_error')` |

四态文案必须可区分（不可让 planned 和 empty 共用同一段“暂无…”，参照 §15.3 BDD 逆向条目 8）。

### Forms

不适用（本契约无表单组件）。

### Motion

- Tab 切换：选中态背景颜色 + 文本颜色采用 `AnimatedContainer` / `AnimatedDefaultTextStyle`，**duration 180ms**，`Curves.easeOut` (`duration-timing` 150–300ms + ease-out 进入)。
- Panel 切换：使用 `AnimatedSwitcher` (duration **200ms**, `transitionBuilder` 采用 `FadeTransition`)；不做 slide/scale（保持稳定阅读，`motion-meaning` 规则）。
- 不动用 `transform` 之外的属性做动效（不动 width/height）；不超过 200ms（`transform-performance` + `duration-timing`）。
- **Reduced motion**：在 `MediaQuery.disableAnimationsOf(context)` 为 true 时，所有 `Duration` 替换为 `Duration.zero`（`reduced-motion` 规则 / `interruptible` 规则）。

### Responsiveness

- **窄屏 (< 360 dp)**：
  - 8 个流派 tab 一定**无法**全部横向显示；必须横向滚动（`horizontal-scroll` 规则的例外：本组件就是用于横向访问的 nav bar，可滚动是允许的，但页面其它内容不允许出现横向滚动）。
  - 起始位置：默认滚动到选中 tab；如选中是 `yuding`（首位），则停在最左。
  - 测试矩阵: 360 / 375 / 414 / 768 dp 宽度下，“大六壬大全”“管辂神书”这两个最长 tab 标签**不截断、不溢出**。
- **横屏**：在 RoadmapWidget 上限制 `body` 最大 720dp 宽，避免长行文本（`line-length-control` 35–60 中文字符）。
- **iPad / 大屏**：tab 维持 pill 高度 40dp 不放大；RoadmapWidget 居中并设 `maxWidth: 640dp`。

## Accessibility Requirements

### Contrast

- 选中 tab 文 / 底 ≥ 4.5:1（由 coder 通过 `colorScheme.primary` × `onPrimary` 保障——Material 3 默认满足；如自定义 theme 须在 review 时复核）。
- planned tab 文字 / 页面背景 ≥ 4.5:1（**不允许**仅以 outline + 灰文呈现 planned，必须叠加 “正在整理中” 文字标签 + 状态点；满足 `color-not-only` 规则）。
- Error 态使用 `colorScheme.error`，且必须搭配 `Icons.error_outline` 或文字“数据不可用”，不依赖颜色。

### Keyboard

- 流派 tab 必须使用 `InkWell` / `Material` + `Focus` 包裹，**保留 focus ring**（`focus-states` 规则）。
- Tab 间通过左右方向键可移动焦点 (`Focus` + `Shortcuts(<Arrow>)`)；或采用 Flutter `FocusTraversalGroup` 默认行为。
- 在桌面/Web 构建（如果存在 Web 构建路径）必须不抑制 outline。

### Screen reader / Semantics

- 每个 tab `Semantics(label: '<displayName>，<status 中文>')`：
  - available: `Semantics(label: '御定大六壬，当前可用，已选中')` / `Semantics(label: '御定大六壬，当前可用')`
  - planned: `Semantics(label: '毕法赋，规划中，可查看路线图')`
- `selected` 属性使用 `Semantics(selected: isSelected)`。
- RoadmapWidget 顶级 `Semantics(container: true, label: '流派路线图: <displayName>，正在整理中')`。
- Empty / Error 顶级 `Semantics(liveRegion: true, label: '<主文案>')`。

### Touch targets

- 单个 tab 可见高度 40dp，外加 hitSlop 8dp（垂直） → 实际 ≥ 48dp（`touch-target-size` 规则）。
- tab 间距 8dp + 各 tab 16dp 水平 padding，避免误触（`touch-spacing` 规则）。
- 任何状态徽标（“正在整理中”）**不**是可点击元素；不要给它 onTap。

### Reduced motion

- 检测 `MediaQuery.disableAnimationsOf(context)` 或 `MediaQuery.platformBrightness` 无关；动画 duration 全部短路为 0。
- Tab 切换在 reduced motion 下也必须有**即时**的视觉变化（背景/文本颜色不动效，但变更后视觉差异显著），不能因为关动效失去“选中态识别”。

## Anti-Patterns To Avoid

1. **不要** 把 planned tab 设为 disabled / `onTap: null`（违反需求 §14.1 第 6/7 条，并触发 `gesture-alternative` 反模式）。
2. **不要** 用 Snackbar / Dialog / Toast 提示 “该流派暂未开放”（应在 Panel 内联呈现）。
3. **不要** 把切换流派写成调用 ViewModel 重算（违反需求 §14.1 第 6 条与 §14.4 第 1/2/3 条）。
4. **不要** 用 Emoji（🎨/🚀/🔧 等）作为 planned/empty/error 状态图标；必须使用 `Icons.*` 矢量符号（`no-emoji-icons` 规则）。
5. **不要** 在 `available + yuding` 状态下用 `SchoolEntryDisplayWidget` 替换 `YuDingDisplayWidget`（违反计划 Task 4 Step 3 与需求 §14.4）。
6. **不要** 让流派 tab 同时占满整屏宽度（如 `Expanded`）；必须是 intrinsic width pill。
7. **不要** 用纯灰色 outline 表达 planned 而没有状态点/文字标签（`color-not-only` 反模式）。
8. **不要** 在 DevPage 把多流派调试段加入正式 BottomNavigation/Drawer（`back-stack-integrity` 反模式）。
9. **不要** 使用 `setState` 触发整个 `DivinationDisplayWidget` 重建（必须限定到内联 stateful 子树）。
10. **不要** 把 planned tab 文案缩成单个图标——必须有 displayName 文本（盲文 + 视障可读性）。
11. **不要** 让动效 > 250ms 或 < 100ms（前者迟钝，后者无意义；坚持 180–200ms）。
12. **不要** 在 ScrollView 外再嵌套水平 ScrollView（避免 nested scroll 冲突，`scroll-behavior` 反模式）。

## Handoff

### To Coder (subagent)

1. **状态边界（最重要）**：`DivinationDisplayWidget` 仅添加一个本地 `_SchoolSwitcherSection` (或 `StatefulBuilder`)；不要改 ViewModel、不要新增 Provider；选中 id 默认 `'yuding'`；切换 tab 仅 `setState`。
2. **available+yuding 必须复用 `YuDingDisplayWidget`**：`SchoolExplanationPanel` 内部以 `(status, schoolId)` 二级分派，**第一优先级匹配** `available && id=='yuding' → YuDingDisplayWidget(...)`；其它分支再走通用渲染。
3. **token-driven theming**：禁止任何 `Color(0xFFxxxxxx)` 出现在 4 个新文件中；全部从 `Theme.of(context).colorScheme` / `textTheme` 取。
4. 在 4 个组件 + `_SchoolSwitcherSection` 上添加稳定 `Key`（按本契约 States 表）以便 widget test 锚定。
5. 动画封装：抽一个内联 helper `_motionDuration(BuildContext c) => MediaQuery.disableAnimationsOf(c) ? Duration.zero : const Duration(milliseconds: 180);` — 复用到 tab 与 Panel 切换。
6. DevPage 改动**仅**在该文件内本地化，**不要**改 `lib/navigator.dart` 或 `lib/pages/my_home_page.dart`。
7. 不修改 `lib/presentation/widgets/school_selector_widget.dart`（旧选择器，保留以免回归）。

### To BDD Acceptance

应可由本契约直接生成的核心场景（建议补 `.feature` 时使用，便于 BDD 逆向通过 §15.3）：

- Given 用户已起盘 And 当前选中御定 When 点击毕法赋 tab Then 盘面/三传/四课不变 And 解释区显示路线图 And 显示文案“正在整理中” And **未触发 ViewModel 重算**
- Given 选中毕法赋 When 点击御定 tab Then 解释区恢复显示 `YuDingDisplayWidget` And 盘面不变
- Given 屏幕宽度 360dp When 横向滚动 slider Then 可访问最末位 “管辂神书” tab
- Given 系统 reduced motion 开启 When 切换 tab Then 切换无动效但选中态明显变化
- Given 流派加载失败 Then 解释区显示 error 状态并展示 `<schoolId>` 与错误原因

### To Tester / Reviewer

必跑的 Widget Test（建议命名清单，与 plan §Test 文件对齐）：

- `test/presentation/widgets/school_slider_bar_test.dart`
  - `renders all eight tabs in catalog order`
  - `selected tab uses primary color; unselected available uses surface variant`
  - `planned tab has outline + status dot + readable label`
  - `onChanged fires with correct id for planned tap`
  - `min tap target ≥ 48dp (vertical hit including hitSlop)`
- `test/presentation/widgets/school_explanation_panel_test.dart`
  - `available + yuding renders YuDingDisplayWidget` (用 mock entry)
  - `planned renders PlannedSchoolRoadmapWidget with displayName / book / description / tag / 正在整理中`
  - `empty state shows '暂无匹配解释'`
  - `error state shows '数据不可用' and includes schoolId`
- `test/presentation/views/widgets/divination_display_widget_school_switch_test.dart`（建议新增）
  - `default selected is yuding`
  - `switching to bifa does not invoke recalculate`
  - `switching back to yuding restores YuDingDisplayWidget`
- DevPage：手动 / smoke widget test 验证“多流派调试段”可见且不影响 `flutter test test/da_liu_ren_test.dart` 回归。

可视回归点（gStack QA / 手动验证，对应测试设计 §12 场景 1–4）：

- 360dp / 414dp 两种宽度的 slider 截图
- planned tab 选中 + RoadmapWidget 截图（毕法赋 / 管辂神书各一张）
- 切回 yuding 后正式 `YuDingDisplayWidget` 截图（应与重构前一致）
- DevPage 多流派调试段截图

### To QA Delivery Auditor

证据包必须包含：

1. 上述 widget test 全部通过的输出。
2. 至少 4 张 gStack/截图证据（slider 默认态、slider planned 选中态、切回 yuding 后 yuding 正式展示、DevPage 多流派调试段）。
3. 一份显式声明：未修改 `school_selector_widget.dart`、未修改 `navigator.dart`、未修改 `my_home_page.dart`、未新增 Provider、未触发 `recalculate()`。
4. 资产或加载失败的诊断截图（验证 error 态显示 schoolId 与原因）。

任何一项缺失即 fail close。
