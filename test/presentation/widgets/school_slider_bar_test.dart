import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daliuren/domain/schools/school_catalog.dart';
import 'package:daliuren/presentation/widgets/school_slider_bar.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: Scaffold(body: child),
  );
}

void main() {
  group('SchoolSliderBar', () {
    testWidgets('renders all school tabs in catalog order', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('御定'), findsOneWidget);
      expect(find.text('毕法赋'), findsOneWidget);
      expect(find.text('指南'), findsOneWidget);
      expect(find.text('课经'), findsOneWidget);
    });

    testWidgets('calls onChanged when a planned school is tapped',
        (tester) async {
      String? selected;

      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (id) => selected = id,
          ),
        ),
      );

      await tester.ensureVisible(find.text('毕法赋'));
      await tester.tap(find.text('毕法赋'));
      await tester.pump();

      expect(selected, 'bifa');
    });

    testWidgets(
        'displays all eight short names in catalog order through horizontal scroll',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (_) {},
          ),
        ),
      );

      final expectedNames = SchoolCatalog.all.map((e) => e.shortName).toList();
      expect(expectedNames.length, 8);

      // Verify scroll view exists and each short name finds exactly one widget.
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      for (final name in expectedNames) {
        expect(find.text(name), findsOneWidget);
      }

      // Verify ordering by reading x-coordinates from the rendered chips.
      final positions = <double>[];
      for (final name in expectedNames) {
        await tester.ensureVisible(find.text(name));
        final rect = tester.getRect(find.text(name));
        positions.add(rect.left);
      }
      final sorted = List<double>.from(positions)..sort();
      expect(positions, equals(sorted));
    });

    testWidgets('yuding chip is rendered with the selected key when default',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (_) {},
          ),
        ),
      );

      // Stable Key per design contract.
      final yudingFinder = find.byKey(const Key('school_slider_chip_yuding'));
      expect(yudingFinder, findsOneWidget);

      // The selected chip's semantics must declare selected: true.
      final semantics = tester.getSemantics(yudingFinder);
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isTrue); // ignore: deprecated_member_use
    });

    testWidgets('planned chip exposes "正在整理中" via semantics label',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (_) {},
          ),
        ),
      );

      final bifaFinder = find.byKey(const Key('school_slider_chip_bifa'));
      expect(bifaFinder, findsOneWidget);

      final semantics = tester.getSemantics(bifaFinder);
      expect(semantics.label, contains('正在整理中'));
    });

    testWidgets('planned chip is NOT disabled and fires onChanged when tapped',
        (tester) async {
      final tapped = <String>[];

      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: tapped.add,
          ),
        ),
      );

      // Tap every planned chip and assert each id flows back through onChanged.
      final plannedIds = SchoolCatalog.all
          .where((e) => e.status == SchoolAvailabilityStatus.planned)
          .map((e) => e.id)
          .toList();

      expect(plannedIds.length, 7);

      for (final id in plannedIds) {
        final finder = find.byKey(Key('school_slider_chip_$id'));
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pump();
      }

      expect(tapped, equals(plannedIds));
    });

    testWidgets('chip touch target is at least 48 logical pixels tall',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (_) {},
          ),
        ),
      );

      final inkFinder = find.descendant(
        of: find.byKey(const Key('school_slider_chip_yuding')),
        matching: find.byType(InkWell),
      );
      expect(inkFinder, findsOneWidget);

      final size = tester.getSize(inkFinder);
      expect(size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('available unselected chip uses surface variant background',
        (tester) async {
      final theme = ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo);
      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'bifa', // Force yuding to unselected.
            onChanged: (_) {},
          ),
          theme: theme,
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byKey(const Key('school_slider_chip_yuding')),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      // Material 3 prefers surfaceContainerHighest; widget falls back to
      // surfaceVariant on older themes. Either is acceptable per contract.
      final allowed = <Color>{
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.surfaceVariant, // ignore: deprecated_member_use
      };
      expect(allowed.contains(decoration.color), isTrue);
    });

    testWidgets('selected chip uses primary as background', (tester) async {
      final theme = ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo);
      await tester.pumpWidget(
        _wrap(
          SchoolSliderBar(
            schools: SchoolCatalog.all,
            selectedSchoolId: 'yuding',
            onChanged: (_) {},
          ),
          theme: theme,
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byKey(const Key('school_slider_chip_yuding')),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, theme.colorScheme.primary);
    });
  });
}
