import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme/theme.dart';
import 'package:daliuren/presentation/widgets/semantic_chip.dart';
import 'package:daliuren/presentation/widgets/collapsible_section.dart';

void main() {
  group('SemanticChip theme token behavior', () {
    testWidgets('with theme scope, reads background from token variant', (tester) async {
      const tokenBg = Color(0xFFAABBCC);
      const tokenBorder = Color(0xFFDDEEFF);
      final themeData = XuanThemeData(components: {
        'daliuren_semantic_chip': ComponentStyle(
          radius: 4,
          variants: {
            'auspicious': const ComponentStyle(
              background: tokenBg,
              border: BorderSide(color: tokenBorder, width: 1),
            ),
          },
        ),
      });

      await tester.pumpWidget(
        XuanThemeScope(
          themeData: themeData,
          child: MaterialApp(
            home: Scaffold(
              body: SemanticChip(label: '吉', semantic: ChipSemantic.auspicious),
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final decoration = containers.first.decoration as BoxDecoration?;
      expect(decoration?.color, tokenBg);
    });

    testWidgets('without theme scope, renders without crash', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SemanticChip(label: '吉', semantic: ChipSemantic.auspicious),
          ),
        ),
      );

      expect(find.text('吉'), findsOneWidget);
    });

    testWidgets('ComponentStyle.empty falls back to DaliurenColors defaults', (tester) async {
      final themeData = XuanThemeData(components: {
        'daliuren_semantic_chip': ComponentStyle.empty,
      });

      await tester.pumpWidget(
        XuanThemeScope(
          themeData: themeData,
          child: MaterialApp(
            home: Scaffold(
              body: SemanticChip(label: '凶', semantic: ChipSemantic.inauspicious),
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final decoration = containers.first.decoration as BoxDecoration?;
      // Should be non-null (DaliurenColors fallback, not transparent)
      expect(decoration?.color, isNotNull);
    });
  });

  group('CollapsibleSection theme token behavior', () {
    testWidgets('with theme scope, accent bar uses border color from token', (tester) async {
      const tokenAccent = Color(0xFF990011);
      final themeData = XuanThemeData(components: {
        'daliuren_collapsible_section': const ComponentStyle(
          border: BorderSide(color: tokenAccent),
        ),
      });

      await tester.pumpWidget(
        XuanThemeScope(
          themeData: themeData,
          child: MaterialApp(
            home: Scaffold(
              body: CollapsibleSection(
                title: '测试',
                initiallyExpanded: true,
                child: const Text('content'),
              ),
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final accentContainer = containers.where((c) {
        final deco = c.decoration as BoxDecoration?;
        return deco?.color == tokenAccent;
      });
      expect(accentContainer, isNotEmpty);
    });

    testWidgets('without theme scope, falls back and renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CollapsibleSection(
              title: '测试',
              child: const Text('content'),
            ),
          ),
        ),
      );

      expect(find.text('测试'), findsOneWidget);
    });
  });
}
