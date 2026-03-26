// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daliuren_lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaliurenLesson _$DaliurenLessonFromJson(Map<String, dynamic> json) =>
    DaliurenLesson(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      guaXiang: json['guaXiang'] as String?,
      keTiShi: json['keTiShi'] as String?,
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nameExplanation: json['nameExplanation'] as String?,
      introduction: json['introduction'] as String?,
      notes:
          (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      explanation: json['explanation'] as String?,
      categories: json['categories'] == null
          ? const []
          : DaliurenLesson._categoriesFromJson(json['categories']),
      subLessons: json['subLessons'] == null
          ? const []
          : DaliurenLesson._subLessonsFromJson(json['subLessons']),
    );

Map<String, dynamic> _$DaliurenLessonToJson(DaliurenLesson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'guaXiang': instance.guaXiang,
      'keTiShi': instance.keTiShi,
      'conditions': instance.conditions,
      'nameExplanation': instance.nameExplanation,
      'introduction': instance.introduction,
      'notes': instance.notes,
      'explanation': instance.explanation,
      'categories': instance.categories,
      'subLessons': instance.subLessons,
    };

DaliurenSubLesson _$DaliurenSubLessonFromJson(Map<String, dynamic> json) =>
    DaliurenSubLesson(
      name: json['name'] as String,
      guaXiang: json['guaXiang'] as String?,
      keTiShi: json['keTiShi'] as String?,
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nameExplanation: json['nameExplanation'] as String?,
      introduction: json['introduction'] as String?,
      notes:
          (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      explanation: json['explanation'] as String?,
      categories: json['categories'] == null
          ? const []
          : DaliurenSubLesson._categoriesFromJson(json['categories']),
    );

Map<String, dynamic> _$DaliurenSubLessonToJson(DaliurenSubLesson instance) =>
    <String, dynamic>{
      'name': instance.name,
      'guaXiang': instance.guaXiang,
      'keTiShi': instance.keTiShi,
      'conditions': instance.conditions,
      'nameExplanation': instance.nameExplanation,
      'introduction': instance.introduction,
      'notes': instance.notes,
      'explanation': instance.explanation,
      'categories': instance.categories,
    };

DaliurenLessonCategory _$DaliurenLessonCategoryFromJson(
        Map<String, dynamic> json) =>
    DaliurenLessonCategory(
      name: json['name'] as String,
      description: json['description'] == null
          ? const []
          : DaliurenLessonCategory._descriptionFromJson(json['description']),
    );

Map<String, dynamic> _$DaliurenLessonCategoryToJson(
        DaliurenLessonCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
