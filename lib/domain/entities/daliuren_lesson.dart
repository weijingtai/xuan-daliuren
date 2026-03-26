import 'package:json_annotation/json_annotation.dart';

part 'daliuren_lesson.g.dart';

/// 大六壬六十四课体 - 主课体条目
///
/// 每个条目包含课体名称、卦象、课体诗、条件、释名、总论、详解、注意事项和子课体。
/// 共64个主课体，部分包含子课体（如涉害课包含见机格、察微格、缀瑕格）。
@JsonSerializable()
class DaliurenLesson {
  final int id;
  final String name;
  final String? guaXiang;
  final String? keTiShi;
  final List<String> conditions;
  final String? nameExplanation;
  final String? introduction;
  final List<String> notes;
  final String? explanation;

  @JsonKey(fromJson: _categoriesFromJson)
  final List<DaliurenLessonCategory> categories;

  @JsonKey(fromJson: _subLessonsFromJson)
  final List<DaliurenSubLesson> subLessons;

  DaliurenLesson({
    required this.id,
    required this.name,
    this.guaXiang,
    this.keTiShi,
    this.conditions = const [],
    this.nameExplanation,
    this.introduction,
    this.notes = const [],
    this.explanation,
    this.categories = const [],
    this.subLessons = const [],
  });

  factory DaliurenLesson.fromJson(Map<String, dynamic> json) =>
      _$DaliurenLessonFromJson(json);
  Map<String, dynamic> toJson() => _$DaliurenLessonToJson(this);

  static List<DaliurenLessonCategory> _categoriesFromJson(dynamic json) {
    if (json == null) return [];
    return (json as List<dynamic>)
        .map((e) => DaliurenLessonCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<DaliurenSubLesson> _subLessonsFromJson(dynamic json) {
    if (json == null) return [];
    return (json as List<dynamic>)
        .map((e) => DaliurenSubLesson.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// 子课体（如见机格、察微格、缀瑕格等）
@JsonSerializable()
class DaliurenSubLesson {
  final String name;
  final String? guaXiang;
  final String? keTiShi;
  final List<String> conditions;
  final String? nameExplanation;
  final String? introduction;
  final List<String> notes;
  final String? explanation;

  @JsonKey(fromJson: _categoriesFromJson)
  final List<DaliurenLessonCategory> categories;

  DaliurenSubLesson({
    required this.name,
    this.guaXiang,
    this.keTiShi,
    this.conditions = const [],
    this.nameExplanation,
    this.introduction,
    this.notes = const [],
    this.explanation,
    this.categories = const [],
  });

  factory DaliurenSubLesson.fromJson(Map<String, dynamic> json) =>
      _$DaliurenSubLessonFromJson(json);
  Map<String, dynamic> toJson() => _$DaliurenSubLessonToJson(this);

  static List<DaliurenLessonCategory> _categoriesFromJson(dynamic json) {
    if (json == null) return [];
    return (json as List<dynamic>)
        .map((e) => DaliurenLessonCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// 课体分类信息
@JsonSerializable()
class DaliurenLessonCategory {
  final String name;

  @JsonKey(fromJson: _descriptionFromJson)
  final List<String> description;

  DaliurenLessonCategory({
    required this.name,
    this.description = const [],
  });

  factory DaliurenLessonCategory.fromJson(Map<String, dynamic> json) =>
      _$DaliurenLessonCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$DaliurenLessonCategoryToJson(this);

  /// description 字段在 JSON 中可能是 String 或 `List<String>`
  static List<String> _descriptionFromJson(dynamic json) {
    if (json == null) return [];
    if (json is String) return [json];
    if (json is List) return List<String>.from(json);
    return [];
  }
}
