import 'package:flutter/material.dart';
import 'package:daliuren/domain/entities/daliuren_lesson.dart';

/// 课体详情展示组件
///
/// 展示匹配到的六十四课体详细信息，包括课体诗、条件、释名、总论、详解、注意事项和子课体。
class KetiDetailWidget extends StatelessWidget {
  final List<DaliurenLesson> lessons;

  const KetiDetailWidget({Key? key, required this.lessons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '课体',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...lessons.map((lesson) => _LessonCard(lesson: lesson)),
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  final DaliurenLesson lesson;

  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              lesson.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (lesson.guaXiang != null) ...[
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  lesson.guaXiang!,
                  style: const TextStyle(fontSize: 12),
                ),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ],
        ),
        subtitle: lesson.keTiShi != null
            ? Text(
                lesson.keTiShi!,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lesson.conditions.isNotEmpty)
                  _Section(title: '条件', items: lesson.conditions),
                if (lesson.nameExplanation != null)
                  _TextSection(title: '释名', text: lesson.nameExplanation!),
                if (lesson.introduction != null)
                  _TextSection(title: '总论', text: lesson.introduction!),
                if (lesson.explanation != null)
                  _TextSection(title: '详解', text: lesson.explanation!),
                if (lesson.notes.isNotEmpty)
                  _Section(title: '注意', items: lesson.notes),
                if (lesson.subLessons.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    '子课体',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  ...lesson.subLessons
                      .map((sub) => _SubLessonTile(subLesson: sub)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubLessonTile extends StatelessWidget {
  final DaliurenSubLesson subLesson;

  const _SubLessonTile({required this.subLesson});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        subLesson.name,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: subLesson.keTiShi != null
          ? Text(subLesson.keTiShi!, style: const TextStyle(fontSize: 12))
          : null,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subLesson.conditions.isNotEmpty)
                _Section(title: '条件', items: subLesson.conditions),
              if (subLesson.nameExplanation != null)
                _TextSection(title: '释名', text: subLesson.nameExplanation!),
              if (subLesson.introduction != null)
                _TextSection(title: '总论', text: subLesson.introduction!),
              if (subLesson.explanation != null)
                _TextSection(title: '详解', text: subLesson.explanation!),
              if (subLesson.notes.isNotEmpty)
                _Section(title: '注意', items: subLesson.notes),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 2),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text(item, style: const TextStyle(fontSize: 13)),
              )),
        ],
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  final String title;
  final String text;

  const _TextSection({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(text, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
