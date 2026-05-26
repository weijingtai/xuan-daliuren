import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daliuren/domain/schools/school_catalog.dart';
import 'package:daliuren/presentation/widgets/planned_school_roadmap_widget.dart';
import 'package:daliuren/presentation/widgets/school_explanation_panel.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('PlannedSchoolRoadmapWidget', () {
    testWidgets(
      'renders displayName, representativeBook, description, tags and 正在整理中 status',
      (tester) async {
        final bifa = SchoolCatalog.byId('bifa')!;
        await tester.pumpWidget(
          _wrap(PlannedSchoolRoadmapWidget(entry: bifa)),
        );

        expect(find.byKey(Key('planned_roadmap_${bifa.id}')), findsOneWidget);
        expect(find.text(bifa.displayName), findsOneWidget);
        expect(find.text(bifa.representativeBook), findsOneWidget);
        expect(find.text(bifa.description), findsOneWidget);
        expect(find.text('正在整理中'), findsOneWidget);
        // At least one tag should be rendered.
        expect(find.text(bifa.tags.first), findsOneWidget);
      },
    );

    testWidgets('exposes semantics label that includes 正在整理中',
        (tester) async {
      final bifa = SchoolCatalog.byId('bifa')!;
      await tester.pumpWidget(
        _wrap(PlannedSchoolRoadmapWidget(entry: bifa)),
      );

      final semanticsFinder = find.bySemanticsLabel(
        RegExp('${bifa.displayName}.*正在整理中'),
      );
      expect(semanticsFinder, findsWidgets);
    });
  });

  group('SchoolExplanationPanel', () {
    testWidgets(
      'planned school renders PlannedSchoolRoadmapWidget with roadmap content',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const SchoolExplanationPanel(selectedSchoolId: 'bifa'),
          ),
        );

        expect(find.byKey(const Key('school_explanation_panel')),
            findsOneWidget);
        expect(find.byKey(const Key('planned_roadmap_bifa')), findsOneWidget);
        expect(find.byType(PlannedSchoolRoadmapWidget), findsOneWidget);
        expect(find.text('毕法赋'), findsOneWidget);
        expect(find.text('正在整理中'), findsOneWidget);
      },
    );

    testWidgets(
      'switching from yuding to bifa shows roadmap and not the yuding mock',
      (tester) async {
        const yudingMock = SizedBox(key: Key('mock_yuding'));
        String selectedId = 'yuding';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      TextButton(
                        key: const Key('switch_to_bifa'),
                        onPressed: () =>
                            setState(() => selectedId = 'bifa'),
                        child: const Text('to bifa'),
                      ),
                      TextButton(
                        key: const Key('switch_to_yuding'),
                        onPressed: () =>
                            setState(() => selectedId = 'yuding'),
                        child: const Text('to yuding'),
                      ),
                      Expanded(
                        child: SchoolExplanationPanel(
                          selectedSchoolId: selectedId,
                          availableYudingBuilder: (_) => yudingMock,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Initial: yuding mock should be rendered.
        expect(find.byKey(const Key('mock_yuding')), findsOneWidget);
        expect(find.byType(PlannedSchoolRoadmapWidget), findsNothing);

        // Switch to bifa.
        await tester.tap(find.byKey(const Key('switch_to_bifa')));
        await tester.pumpAndSettle();

        expect(find.byType(PlannedSchoolRoadmapWidget), findsOneWidget);
        expect(find.byKey(const Key('planned_roadmap_bifa')), findsOneWidget);
        expect(find.byKey(const Key('mock_yuding')), findsNothing);

        // Switch back to yuding.
        await tester.tap(find.byKey(const Key('switch_to_yuding')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('mock_yuding')), findsOneWidget);
        expect(find.byType(PlannedSchoolRoadmapWidget), findsNothing);
      },
    );

    testWidgets(
      'yuding with availableYudingBuilder renders the builder widget',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            SchoolExplanationPanel(
              selectedSchoolId: 'yuding',
              availableYudingBuilder: (_) =>
                  const SizedBox(key: Key('mock_yuding')),
            ),
          ),
        );

        expect(find.byKey(const Key('mock_yuding')), findsOneWidget);
        expect(find.byType(PlannedSchoolRoadmapWidget), findsNothing);
      },
    );

    testWidgets('empty state renders 暂无匹配解释 with empty key', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SchoolExplanationPanel(
            selectedSchoolId: 'yuding',
            state: SchoolPanelStateOverride.empty,
          ),
        ),
      );

      expect(find.byKey(const Key('panel_empty')), findsOneWidget);
      expect(find.text('暂无匹配解释'), findsOneWidget);
      expect(find.text('数据不可用'), findsNothing);
    });

    testWidgets(
      'error state renders 数据不可用 with the schoolId in the panel',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const SchoolExplanationPanel(
              selectedSchoolId: 'bifa',
              state: SchoolPanelStateOverride.error,
            ),
          ),
        );

        expect(find.byKey(const Key('panel_error')), findsOneWidget);
        expect(find.text('数据不可用'), findsOneWidget);
        expect(find.text('暂无匹配解释'), findsNothing);
        // schoolId surfaced for diagnostics.
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data != null &&
                widget.data!.contains('bifa'),
          ),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'yuding without builder degrades to a non-roadmap fallback',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const SchoolExplanationPanel(selectedSchoolId: 'yuding'),
          ),
        );

        // No planned roadmap (yuding is available, not planned).
        expect(find.byType(PlannedSchoolRoadmapWidget), findsNothing);
        // Root panel still present.
        expect(find.byKey(const Key('school_explanation_panel')),
            findsOneWidget);
      },
    );
  });
}
