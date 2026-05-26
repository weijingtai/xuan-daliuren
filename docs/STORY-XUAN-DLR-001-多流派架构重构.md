# Story: 大六壬多流派架构重构

## 基本信息

| 字段 | 值 |
|------|-----|
| **Story ID** | XUAN-DLR-001 |
| **标题** | 大六壬多流派架构重构 |
| **状态** | Draft |
| **优先级** | P1 |
| **预估工时** | 5天 |
| **创建日期** | 2026-05-23 |

---

## 背景

当前 xuan-daliuren 项目仅支持"御定大六壬"这一流派，代码中存在大量硬编码耦合：
- `yuding_entry.dart` - 御定专用实体类
- `yuding_keti_match_service.dart` - 御定匹配服务
- `da_liu_ren_repository_impl.dart` - 硬编码御定路径

大六壬历史悠久，流派众多，需要重构为可扩展架构以支持后续添加其他流派。

---

## 调研结果

### 已识别的大六壬主要流派

| 序号 | 流派名称 | 代表书籍 | 年代 | 特点 | 优先级 |
|------|----------|----------|------|------|--------|
| 1 | 御定六壬派 | 《御定大六壬直指》 | 清代 | 官方规范，720课 | ✅ 已实现 |
| 2 | 毕法赋派 | 《毕法赋》 | 宋代 | 100条法则，歌诀形式 | P0 |
| 3 | 课经派 | 《大六壬课经》 | 明代 | 64课体分类 | P1 |
| 4 | 指南派 | 《大六壬指南》 | 明代 | 案例实证 | P1 |
| 5 | 管辂神书派 | 《管辂神书》 | 三国 | 古法派 | P2 |
| 6 | 大六壬大全派 | 《大六壬大全》 | 明代 | 集大成 | P2 |
| 7 | 六壬粹言派 | 《六壬粹言》 | 清代 | 精要派 | P3 |
| 8 | 壬归派 | 《壬归》 | 清代 | 按事项分类 | P3 |

### 各流派核心差异

| 维度 | 御定六壬 | 毕法赋 | 课经派 | 指南派 |
|------|----------|--------|--------|--------|
| 理论基础 | 官方规范 | 歌诀法则 | 课体分类 | 案例实证 |
| 课体数量 | 720课 | 100法则 | 64课格 | 不限 |
| 占断重点 | 综合分析 | 类神取用 | 课格定性 | 活法变通 |
| 学习难度 | 中等 | 较易 | 中等 | 较难 |

---

## 需求描述

### 1. 抽象流派接口

创建统一的流派抽象接口 `DaLiuRenSchool`，包含：
- `id` - 流派唯一标识
- `displayName` - 显示名称
- `description` - 描述
- `loadData()` - 加载数据
- `matchEntries()` - 匹配条目
- `entryCount` - 条目数量

### 2. 统一条目基类

创建 `SchoolEntry` 基类，包含：
- `title` - 标题
- `dayJiaZi` - 日干支
- `juName` - 局名
- `keTiNames` - 课体名称
- `meaning` - 课义
- `explanation` - 解释
- `prediction` - 断语
- `details` - 杂占
- `bookReferences` - 经典引用

### 3. 流派注册机制

实现 `SchoolRegistry` 注册表：
- `register(school)` - 注册流派
- `get(id)` - 获取流派
- `all` - 所有流派
- `defaultSchool` - 默认流派

### 4. 重构现有代码

将御定六壬重构为第一个流派实现：
- 创建 `YudingSchool` 实现 `DaLiuRenSchool`
- 将 `YuDingEntry` 改为实现 `SchoolEntry`
- 修改 Repository 使用注册表

### 5. UI 组件

创建通用 UI 组件：
- `SchoolSelectorWidget` - 流派选择器
- `SchoolEntryDisplayWidget` - 通用条目显示

---

## 技术方案

### 目录结构

```
lib/
├── domain/interfaces/
│   ├── school_entry.dart          # 条目接口
│   ├── da_liu_ren_school.dart     # 流派接口
│   └── school_registry.dart       # 注册表
├── data/schools/
│   ├── yuding_school.dart         # 御定实现
│   ├── bifa_school.dart           # 毕法赋实现（新增）
│   └── ...
├── presentation/widgets/
│   ├── school_selector_widget.dart
│   └── school_entry_display_widget.dart
└── assets/da_liu_ren/schools/
    ├── yuding/data.json
    ├── bifa/data.json
    └── ...
```

### 数据格式规范

```json
{
  "school_id": "yuding",
  "school_name": "御定大六壬",
  "entries": [
    {
      "dayJiaZi": "甲子",
      "juName": "寅",
      "juNumber": 1,
      "body": ["伏吟", "元胎"],
      "meaning": "...",
      "explain": "...",
      "predication": "...",
      "details": {...},
      "books": {...}
    }
  ]
}
```

---

## 验收标准

### AC1: 接口抽象
- [ ] 创建 `DaLiuRenSchool` 接口
- [ ] 创建 `SchoolEntry` 基类
- [ ] 创建 `SchoolRegistry` 注册表
- [ ] 接口文档完整

### AC2: 御定重构
- [ ] `YudingSchool` 实现 `DaLiuRenSchool`
- [ ] 现有功能不受影响
- [ ] 单元测试通过

### AC3: UI 组件
- [ ] 流派选择器可正常显示
- [ ] 条目显示组件通用化
- [ ] 演示页面可运行

### AC4: 文档完善
- [ ] 调研报告完成
- [ ] 技术方案文档完成
- [ ] 数据格式规范完成

---

## 实施计划

### Phase 1: 接口层（1天）
- 创建抽象接口
- 创建注册机制
- 编写接口文档

### Phase 2: 重构御定（1天）
- 实现 YudingSchool
- 迁移现有代码
- 回归测试

### Phase 3: UI 组件（1天）
- 流派选择器
- 通用条目显示
- 演示页面

### Phase 4: 数据准备（2天）
- 收集毕法赋数据
- 整理成统一格式
- 实现 BifaSchool

---

## 相关文档

- [大六壬流派调研报告](./docs/大六壬流派调研报告.md)
- [多流派重构技术方案](./docs/多流派重构技术方案.md)
- [毕法赋数据格式说明](./docs/毕法赋数据格式说明.md)

---

## 变更记录

| 日期 | 版本 | 变更内容 |
|------|------|----------|
| 2026-05-23 | v1.0 | 初始版本，完成调研和架构设计 |
