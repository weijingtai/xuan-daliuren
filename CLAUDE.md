# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **架构方向 · 盘面渲染统一到 `metaphysics-chart-ui`（Chart-UI）**
>
> 本模块的「排盘 / 盘面」渲染将迁移到共享的专用排盘包 `metaphysics-chart-ui`（4 个通用渲染器 + 自带 5 级优先级 token 主题系统），**替换当前模块内自有的盘面实现**。
> - 不要再扩展或重写模块自有的盘面 Canvas painter / 盘面级主题；新的盘面工作一律经 Chart-UI 的中性模型 + 渲染器 + 模块适配器接入。
> - 盘面样式**不走** `XuanThemeData.component()` / `ComponentStyle` 通用主题迁移；那条通路只负责非盘面的 card / 组件（这些组件不退役，照常迁移）。
> - 背景见 `openspec/changes/create-metaphysics-chart-ui-package`（QiZhengSiYu 为首个迁移消费者）。

## Module Overview

**Daliuren** (大六壬) is a Flutter module implementing the Da Liu Ren divination system, one of the ancient Chinese metaphysical arts. This module is part of the larger "xuan" (玄学) project containing multiple divination systems.

This is a **Flutter module**, not a standalone app. It requires integration with a host application or the parent xuan project to run.

## Module-Specific Architecture

### Core Components

- **Models** (`lib/model/`): 30+ data models representing divination concepts
  - `da_liu_ren_*.dart`: Core divination calculation models
  - `three_chuan_*.dart`: Three transmission (三传) logic models
  - `four_class.dart`: Four classes (四课) calculations
  - `enum_gui_ren.dart`: Noble people (贵人) positioning enums
  - All models use `@JsonSerializable()` with generated `.g.dart` files

- **Main Interface** (`lib/pages/my_home_page.dart`): ~3000-line divination UI
  - Complex state management for real-time calculations
  - Date/time picker integration with Chinese lunar calendar
  - Animation and feedback effects for divination results

- **Navigation** (`lib/navigator.dart`): Module routing
  - `/daliuren`: Main divination interface
  - `/daliuren/dev`: Development/debug page

### Divination Data Assets

- **Large JSON Datasets** (`assets/da_liu_ren/`):
  - `御定大六壬.json`: Imperial Da Liu Ren reference (~1.3MB)
  - `甲午庚牛羊_阳.json` & `甲午庚牛羊_阴.json`: Yang/Yin calculation data (~6MB total)
  - `ju_mapper.json`: Bureau mapping data

### Dependencies

**Key Module Dependencies:**
- `common`: Shared utilities, enums, and widgets from parent project
- `lunar: ^1.7.3`: Chinese calendar calculations
- `fpdart: ^2.0.0-dev.3`: Functional programming patterns
- `json_serializable/json_annotation`: Data model serialization
- UI libraries: `animated_custom_dropdown`, `flutter_shakemywidget`, `board_datetime_picker`

## Development Commands

### Module-Specific Workflow

```bash
# Navigate to module directory first
cd daliuren

# Install module dependencies
flutter pub get

# Generate code (critical for JSON models)
flutter packages pub run build_runner build

# Clean and regenerate (when models change)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run comprehensive tests (includes divination logic validation)
flutter test

# Code analysis
flutter analyze
```

### Code Generation Requirements

**Always regenerate code after modifying:**
- Any `@JsonSerializable()` annotated classes in `lib/model/`
- Enum definitions used in divination calculations
- Data models with `.g.dart` companions (12 generated files currently)

### Testing

The module includes extensive test coverage:
- `da_liu_ren_test.dart`: Core divination functionality
- `each_class_test.dart`: Four classes logic validation
- `nine_zong_men_*.dart`: Tests for "九宗门" (Nine Aspects) of Da Liu Ren
- Large JSON test datasets for comprehensive validation

## Domain-Specific Notes

### Da Liu Ren Implementation

**Core Concepts Implemented:**
- **Four Classes (四课)**: Primary divination calculation method
- **Three Transmissions (三传)**: Secondary prediction derivation
- **Noble People (贵人)**: Auspicious positioning calculations
- **Traditional Chinese Calendar**: Integration with lunar calendar for accurate timing

**Special Logic (see `READ_ME_NOTICE`):**
- Different bureau (局) orders produce different divination effects
- Uses "先孟仲法 后涉害法" (first Meng-Zhong method, then Interference-Harm method)
- Specific JiaZi day and bureau combinations require special handling
- Complex conditional logic for 25+ specific day-bureau combinations

### Data Validation

The divination calculations depend on precise astronomical and calendar data. Test files validate:
- Correct JiaZi (甲子) cycle calculations
- Proper DiZhi (地支) and TianGan (天干) relationships
- Noble people positioning accuracy
- Traditional bureau calculation methods

## Module Integration

This module integrates with the parent xuan project through:
- Shared `common` package for base models and utilities
- Navigation routes exposed to parent app router
- Asset paths accessible to host application
- Consistent with parent project's Provider-based state management

For parent project architecture and commands, see `../CLAUDE.md`.

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **xuan-daliuren** (4067 symbols, 8000 relationships, 274 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> Index stale? Run `node .gitnexus/run.cjs analyze` from the project root — it auto-selects an available runner. No `.gitnexus/run.cjs` yet? `npx gitnexus analyze` (npm 11 crash → `npm i -g gitnexus`; #1939).

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows. For regression review, compare against the default branch: `detect_changes({scope: "compare", base_ref: "main"})`.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `rename` which understands the call graph.
- NEVER commit changes without running `detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/xuan-daliuren/context` | Codebase overview, check index freshness |
| `gitnexus://repo/xuan-daliuren/clusters` | All functional areas |
| `gitnexus://repo/xuan-daliuren/processes` | All execution flows |
| `gitnexus://repo/xuan-daliuren/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
