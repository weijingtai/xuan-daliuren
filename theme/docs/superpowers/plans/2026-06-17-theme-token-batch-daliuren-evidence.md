# Theme Token Migration Evidence: xuan-daliuren

- **Date**: 2026-06-17
- **Package**: `xuan-daliuren`
- **Component IDs**: `daliuren_ke_pan_card`, `daliuren_semantic_chip`, `daliuren_collapsible_section`, `daliuren_ancient_text_card`, `daliuren_four_class_card`, `daliuren_three_chuan_card`
- **Template**: `openspec/specs/theme-token-agent-migration-template.md`
- **Verification**: 8 new theme tests + 95 existing tests = 103 all passing

## Line-by-Line Mapping

| File:Line | Pre-migration | Post-migration | Rationale |
|---|---|---|---|
| `ke_pan_info_card.dart:1` | `import 'package:theme/const_resources_mapper.dart';` | `import 'package:theme/theme.dart';` | Barrel import for XuanThemeData |
| `ke_pan_info_card.dart:29-31` | `static const _inkColor`, `_bgColor` | Mutable `_ink`, `_bg`, `_sealRedBase` fields | StatelessWidget + context pattern |
| `ke_pan_info_card.dart:40-42` | No token resolution | `XuanThemeData.maybeOf(context)?.component('daliuren_ke_pan_card')` → assign `_ink`, `_bg`, `_sealRedBase` | Token-driven theme colors |
| `ke_pan_info_card.dart:17` | `const KePanInfoCard` | `KePanInfoCard` | Mutable fields require dropping `const` |
| `ke_pan_info_card.dart:55,120-475` | `_inkColor`, `_bgColor`, `Color.fromRGBO(176,31,36,α)` | `_ink`, `_bg`, `_sealRedBase.withValues(α)` | 17 sealRed/dark ink usages from token |
| `semantic_chip.dart:2` | No theme import | `import 'package:theme/theme.dart';` | Token API access |
| `semantic_chip.dart:49-56` | Direct `_bgColor`/`_textColor` | `XuanThemeData.maybeOf(context)?.component('daliuren_semantic_chip')` with variant resolution | 4 variants (auspicious/inauspicious/neutral/highlight) |
| `semantic_chip.dart:56` | `DaliurenSpacing.xs * scale` | `style?.radius ?? DaliurenSpacing.xs * scale` | Token-driven radius |
| `collapsible_section.dart:2` | No theme import | `import 'package:theme/theme.dart';` | Token API access |
| `collapsible_section.dart:43-46` | `DaliurenColors.sealRed.withValues`, `DaliurenColors.textHint`, `DaliurenColors.dividerGradient` | Token fallback for accent bar, icon, divider | All 3 visual props from token |
| `ancient_text_card.dart:2` | No theme import | `import 'package:theme/theme.dart';` | Token API access |
| `ancient_text_card.dart:21-40` | `DaliurenColors.paper`, `DaliurenColors.ink.withValues` | `component('daliuren_ancient_text_card')` with bg/border/radius/shadow | 5 ComponentStyle fields consumed |
| `ancient_text_card.dart:82-130` | `DaliurenColors.sealRed.withValues` | Token-derived `labelColor`/`highlightColor`/`sealBg` passed as params | Highlight + label colors |
| `four_class_card.dart:1-3` | `const_resources_mapper` + `const_ui_resources_mapper` | `import 'package:theme/theme.dart';` | Barrel import |
| `four_class_card.dart:25-45` | `Colors.white`, `Colors.blueGrey`, `12` | Token fallback bg/titleColor/radius | Card decoration from token |
| `four_class_card.dart:73` | `const Color.fromRGBO(68,68,60,1)` | `textColor` from token | Text color from token |
| `three_chuan_card.dart:1-3` | `const_resources_mapper` + `const_ui_resources_mapper` | `import 'package:theme/theme.dart';` | Barrel import |
| `three_chuan_card.dart:24-44` | `Colors.white`, `Colors.blueGrey`, `12` | Token fallback bg/titleColor/radius | Card decoration from token |
| `three_chuan_card.dart:60-62` | `const Color.fromRGBO(68,68,60,1)` | `textColor` from token | Text color from token |

## Deferred Colors

| File | Colors | Rationale |
|---|---|---|
| `four_class_card.dart` / `three_chuan_card.dart` | `ConstResourcesMapper.zodiacGanColors` / `zodiacZhiColors` | Business logic: zodiac → color mapping is semantic, not visual token |
| `ke_pan_info_card.dart` | `ConstResourcesMapper.chineseNumberMapper` | Logic mapping, not visual |
| `ke_pan_info_card.dart` | `constUIResourcesMapperTianGanStyle()` / `constUIResourcesMapperDiZhiStyle()` | Font style factories, not color tokens |
| `keti_detail_widget.dart` | `Colors.green.shade100/50/800/200` | Sub-lesson highlight colors — deferred (redundant with semantic_chip pattern) |
| `divination_display_widget.dart` | No hardcoded colors | Uses Theme.of(context) only — already clean |

## Test Results

```
flutter test test/theme/
  ✓ Theme token governance: production widgets do not import xuan_config
  ✓ Theme token governance: scan path self-proves RED via temp dir
  ✓ Theme token governance: migrated component ids present in source (6 components)
  ✓ SemanticChip: with theme scope, reads background from variant
  ✓ SemanticChip: without theme scope, renders without crash
  ✓ SemanticChip: ComponentStyle.empty falls back
  ✓ CollapsibleSection: accent bar uses border color from token
  ✓ CollapsibleSection: falls back and renders
  8/8 passed

flutter test (full suite)
  103/103 passed
```
