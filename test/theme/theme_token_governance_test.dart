import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

bool containsForbiddenImport(String source) {
  return RegExp(r'''import\s+['"]package:xuan_config/''').hasMatch(source);
}

List<File> filesWithForbiddenImport(Directory dir) {
  final offenders = <File>[];
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      if (containsForbiddenImport(content)) {
        offenders.add(entity);
      }
    }
  }
  return offenders;
}

void main() {
  group('Theme token governance', () {
    test('production widgets do not import xuan_config', () {
      final libDir = Directory(
        '${Directory.current.path}/lib/presentation/widgets',
      );

      expect(libDir.existsSync(), isTrue);
      final dartFiles = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
      expect(dartFiles, isNotEmpty);

      // RED predicate proof
      expect(
        containsForbiddenImport("import 'package:xuan_config/foo.dart';"),
        isTrue,
      );

      // Actual governance check
      final offenders = filesWithForbiddenImport(libDir);
      expect(offenders, isEmpty,
          reason: 'No production widget may import package:xuan_config. '
              'Offenders: ${offenders.map((f) => f.path).join(', ')}');
    });

    test('scan path self-proves RED via temp dir with offender', () {
      final tmpDir = Directory.systemTemp.createTempSync('governance_red_');
      try {
        File('${tmpDir.path}/offender.dart').writeAsStringSync(
          "import 'package:xuan_config/xuan_config.dart';\nvoid main() {}\n",
        );
        final offenders = filesWithForbiddenImport(tmpDir);
        expect(offenders, hasLength(1));
        expect(offenders.first.path, contains('offender.dart'));
      } finally {
        tmpDir.deleteSync(recursive: true);
      }
    });

    test('migrated component ids present in source', () {
      final checks = <String, String>{
        'lib/presentation/widgets/ke_pan_info_card.dart': "component('daliuren_ke_pan_card')",
        'lib/presentation/widgets/semantic_chip.dart': "component('daliuren_semantic_chip')",
        'lib/presentation/widgets/collapsible_section.dart': "component('daliuren_collapsible_section')",
        'lib/presentation/widgets/ancient_text_card.dart': "component('daliuren_ancient_text_card')",
        'lib/presentation/widgets/four_class_card.dart': "component('daliuren_four_class_card')",
        'lib/presentation/widgets/three_chuan_card.dart': "component('daliuren_three_chuan_card')",
      };

      for (final entry in checks.entries) {
        final source = File(entry.key).readAsStringSync();
        expect(source, contains(entry.value),
            reason: '${entry.key} must contain ${entry.value}');
      }
    });
  });
}
