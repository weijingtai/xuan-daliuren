import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

/// 架构边界测试
///
/// 验证 Presentation 层（pages, views, widgets）不直接依赖：
/// - domain/services/**（含 calculators）
/// - domain/repositories/**
/// - data/repositories/**
/// - data/services/**
/// - package:repository_interface_daliuren
/// - serviceLocator, ReadDataUtils
/// NOTE: loadYuDingData is now a ViewModel method — pages may call it.

void main() {
  // 被扫描的目录（Presentation 层）
  final presentationDirs = [
    'lib/pages',
    'lib/presentation/views',
    'lib/presentation/widgets',
  ];

  // 禁止的导入模式
  // NOTE: loadYuDingData is now a ViewModel method (delegates to UseCase),
  // so pages calling viewModel.loadYuDingData() is the correct MVVM pattern.
  final forbiddenPatterns = [
    'repository_interface_daliuren',
    'DaLiuRenOfficialDataRepository',
    'DaLiuRenRepository',
    'domain/repositories',
    'data/repositories',
    'data/services',
    'domain/services',
    'serviceLocator',
    'ReadDataUtils',
  ];

  group('Import boundary test', () {
    for (final dir in presentationDirs) {
      test('$dir should not import restricted types', () {
        final directory = Directory(dir);
        if (!directory.existsSync()) {
          // 目录不存在时跳过
          return;
        }

        final violations = <String>[];

        for (final file in directory.listSync(recursive: true).whereType<File>()) {
          if (!file.path.endsWith('.dart')) continue;

          final content = file.readAsStringSync();
          final lines = content.split('\n');

          for (var i = 0; i < lines.length; i++) {
            final line = lines[i];
            // 跳过注释行
            if (line.trimLeft().startsWith('//')) continue;

            for (final pattern in forbiddenPatterns) {
              if (line.contains(pattern)) {
                violations.add(
                  '${file.path}:${i + 1}: contains forbidden pattern "$pattern"\n  -> ${line.trim()}',
                );
              }
            }
          }
        }

        if (violations.isNotEmpty) {
          fail(
            'Found ${violations.length} boundary violation(s) in $dir:\n'
            '${violations.join('\n')}',
          );
        }
      });
    }
  });
}
