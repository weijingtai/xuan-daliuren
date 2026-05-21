import 'dart:convert';

import 'package:common/module.dart';
import 'package:daliuren/model/enum_nine_zong_men.dart';
import 'package:flutter/services.dart';

import '../entities/daliuren_lesson.dart';

/// 六十四课体数据服务
///
/// 负责加载和查询 keti_data.json 中的64个课体及其子课体数据。
/// 提供按名称、ID查找课体的能力，以及将计算器输出的 patternName 匹配到对应课体的能力。
class KetiDataService {
  static const String _assetPath = 'packages/daliuren/assets/da_liu_ren/keti_data.json';

  /// 古代避讳与异名映射字典
  /// 用于兼容不同的排盘数据源（如《御定大六壬》中的古称）
  static const Map<String, String> _aliasesMap = {
    '元胎': '玄胎',
    '孤辰': '孤寡',
    '寡宿': '孤寡',
    '进茹': '连珠',
    '退茹': '连珠',
    '连茹': '连珠',
    '间传': '连珠',
  };

  List<DaliurenLesson>? _lessons;
  Map<String, DaliurenLesson>? _byName;
  Map<int, DaliurenLesson>? _byId;

  /// 子课体名称 → 所属主课体的映射
  /// key 同时存储 "格" 和 "课" 两种后缀的名称以便匹配
  Map<String, _SubLessonMatch>? _subLessonMap;

  bool get isLoaded => _lessons != null;

  List<DaliurenLesson> get lessons => _lessons ?? const [];

  /// 加载并解析 keti_data.json
  Future<void> loadData() async {
    if (_lessons != null) return;
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      _lessons = decoded
          .map((e) => DaliurenLesson.fromJson(e as Map<String, dynamic>))
          .toList();
      _buildLookupMaps();
    } catch (e) {
      logger.e('[KetiDataService] Failed to load keti data: $e');
      _lessons = [];
      _byName = {};
      _byId = {};
      _subLessonMap = {};
    }
  }

  void _buildLookupMaps() {
    _byName = {};
    _byId = {};
    _subLessonMap = {};

    for (final lesson in _lessons!) {
      _byName![lesson.name] = lesson;
      _byId![lesson.id] = lesson;

      final bareName = lesson.name.replaceAll('课', '');
      _byName![bareName] = lesson;

      for (final sub in lesson.subLessons) {
        // 存储原始名称（如 "见机格"）
        _subLessonMap![sub.name] = _SubLessonMatch(
          parent: lesson,
          subLesson: sub,
        );
        
        // 存储去后缀名称（如 "见机"），精准匹配御定数据集
        final bareSubName = sub.name.replaceAll('格', '').replaceAll('课', '');
        _subLessonMap![bareSubName] = _SubLessonMatch(
          parent: lesson,
          subLesson: sub,
        );
        // 也存储将 "格" 替换为 "课" 的版本（如 "见机课"），方便从 patternName 匹配
        if (sub.name.endsWith('格')) {
          final altName = '${sub.name.substring(0, sub.name.length - 1)}课';
          _subLessonMap![altName] = _SubLessonMatch(
            parent: lesson,
            subLesson: sub,
          );
        }
      }
    }
  }

  /// 按名称精确查找主课体
  DaliurenLesson? findByName(String name) {
    return _byName?[name];
  }

  /// 按 ID 查找主课体
  DaliurenLesson? findById(int id) {
    return _byId?[id];
  }

  /// 从计算器输出的 patternName 匹配课体
  ///
  /// patternName 格式示例：
  /// - "元首课" → 直接匹配
  /// - "知一课 (比用)" → 去掉括号后缀匹配
  /// - "见机课 (涉害)" → 去掉后缀后查子课体表
  /// - "虎视转蓬 (昴星)" → 去掉后缀后查子课体表
  /// - "杜传格 (伏吟有克)" → 去掉后缀后查子课体表
  KetiMatchResult? findByPatternName(String patternName) {
    // 0. 解析同义词（处理古代避讳或异名，如元胎->玄胎）
    String resolvedName = _aliasesMap[patternName] ?? patternName;

    // 1. 先尝试直接匹配
    final directMatch = _byName?[resolvedName];
    if (directMatch != null) {
      return KetiMatchResult(lesson: directMatch);
    }

    // 2. 去掉括号后缀再匹配
    String stripped = _stripSuffix(resolvedName);
    stripped = _aliasesMap[stripped] ?? stripped;

    // 2a. 匹配主课体
    final strippedMatch = _byName?[stripped];
    if (strippedMatch != null) {
      return KetiMatchResult(lesson: strippedMatch);
    }

    // 2b. 匹配子课体
    final subMatch = _subLessonMap?[stripped];
    if (subMatch != null) {
      return KetiMatchResult(
        lesson: subMatch.parent,
        matchedSubLesson: subMatch.subLesson,
      );
    }

    // 3. 尝试模糊匹配主课体（名称包含关系）
    if (_byName != null) {
      for (final entry in _byName!.entries) {
        if (stripped.contains(entry.key.replaceAll('课', '')) &&
            entry.key.length >= 2) {
          return KetiMatchResult(lesson: entry.value);
        }
      }
    }
    
    // 4. 尝试模糊匹配子课体
    if (_subLessonMap != null) {
      for (final entry in _subLessonMap!.entries) {
        if (stripped.contains(entry.key.replaceAll('格', '').replaceAll('课', '')) &&
            entry.key.length >= 2) {
          return KetiMatchResult(
            lesson: entry.value.parent,
            matchedSubLesson: entry.value.subLesson,
          );
        }
      }
    }

    return null;
  }

  /// 从多个名称列表（如御定 body 字段）批量匹配课体
  List<KetiMatchResult> findByNames(List<String> names) {
    final results = <KetiMatchResult>[];
    final seenLessons = <String>{};
    for (final name in names) {
      final result = findByPatternName(name);
      if (result != null) {
        if (!seenLessons.contains(result.lesson.name)) {
          seenLessons.add(result.lesson.name);
          results.add(result);
        } else if (result.matchedSubLesson != null) {
          results.add(result);
        }
      }
    }
    return results;
  }

  /// 从 NineZongMen 枚举匹配对应课体
  ///
  /// NineZongMen 的名称（如"涉害"）加 "课" 后缀可匹配大部分课体条目。
  ///
  /// 匹配对应关系：
  /// - "涉害" → "涉害课" ✓
  /// - "遥克" → "遥克课" ✓
  /// - "昴星" → "昴星课" ✓
  /// - "别责" → "别责课" ✓
  /// - "八专" → "八专课" ✓
  /// - "伏吟" → "伏吟课" ✓
  /// - "反吟" → "反吟课" ✓
  /// - "贼克" → 无直接对应课体，返回 null
  /// - "比用" → 无直接对应课体，返回 null
  ///
  /// "贼克" 和 "比用" 是特殊的计算模式，不对应具体的"课体"概念，而是四课关系的描述。
  /// 在古籍中，"比用课" 有时也称为 "知一课"，但这是通过具体的四课模式识别而非NineZongMen值。
  KetiMatchResult? findByNineZongMen(NineZongMen nineZongMen) {
    // NineZongMen.name 如 "涉害" → 查 "涉害课"
    final name = '${nineZongMen.name}课';
    logger.d('[KetiDataService] findByNineZongMen: Looking for "$name"');

    final match = _byName?[name];
    if (match != null) {
      logger.d('[KetiDataService] findByNineZongMen: Found match for $name');
      return KetiMatchResult(lesson: match);
    }

    logger.d('[KetiDataService] findByNineZongMen: No match found for $name (this is expected for 贼克, 比用, etc.)');
    return null;
  }

  /// 去掉 patternName 中的括号后缀
  /// "知一课 (比用)" → "知一课"
  /// "杜传格 (伏吟有克)" → "杜传格"
  String _stripSuffix(String name) {
    final parenIndex = name.indexOf(' (');
    if (parenIndex > 0) {
      return name.substring(0, parenIndex);
    }
    final parenIndex2 = name.indexOf('(');
    if (parenIndex2 > 0) {
      return name.substring(0, parenIndex2).trim();
    }
    return name;
  }
}

/// 子课体匹配的内部数据结构
class _SubLessonMatch {
  final DaliurenLesson parent;
  final DaliurenSubLesson subLesson;

  _SubLessonMatch({required this.parent, required this.subLesson});
}

/// 课体匹配结果
class KetiMatchResult {
  /// 匹配到的主课体
  final DaliurenLesson lesson;

  /// 如果匹配到的是子课体，则此字段非空
  final DaliurenSubLesson? matchedSubLesson;

  KetiMatchResult({required this.lesson, this.matchedSubLesson});
}
