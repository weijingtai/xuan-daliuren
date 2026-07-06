import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme/theme.dart';
import 'package:xuan_common_ui/xuan_common_ui.dart';
import 'package:daliuren/domain/interfaces/school_entry.dart';
import 'package:daliuren/presentation/widgets/school_entry_display_widget.dart';

class MockSchoolEntry implements SchoolEntry {
  @override
  String get title => 'Mock Title';
  @override
  String get dayJiaZi => '甲子';
  @override
  String get juName => '子';
  @override
  int get juNumber => 1;
  @override
  List<String> get keTiNames => ['伏吟'];
  @override
  String get meaning => 'Mock Meaning';
  @override
  String get explanation => 'Mock Explanation';
  @override
  String get prediction => 'Mock Prediction';
  @override
  Map<String, String> get details => {'财运': '吉'};
  @override
  Map<String, String> get bookReferences => {'毕法赋': '引用文本'};
  @override
  String get schoolId => 'yuding';
}

void main() {
  group('daliuren facade theme tests', () {
    testWidgets('SchoolEntryDisplayWidget uses theme token for Card and Divider', (tester) async {
      const testCardBg = Color(0xFF123456);
      const testDividerBg = Color(0xFF654321);

      final themeData = XuanThemeData(
        components: {
          'xuan-common-ui.card': const ComponentStyle(
            background: testCardBg,
            radius: 12.0,
          ),
          'xuan-common-ui.divider': const ComponentStyle(
            background: testDividerBg,
            minHeight: 2.0,
          ),
        },
      );

      final entry = MockSchoolEntry();

      await tester.pumpWidget(
        XuanThemeScope(
          themeData: themeData,
          child: MaterialApp(
            home: Scaffold(
              body: SchoolEntryDisplayWidget(entry: entry),
            ),
          ),
        ),
      );

      // Verify Card background is overridden
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);
      final cardWidget = tester.widget<Card>(cardFinder);
      expect(cardWidget.color, testCardBg);

      // Verify Divider color is overridden (XuanDivider produces a Divider under the hood)
      final dividerFinder = find.byType(Divider);
      expect(dividerFinder, findsOneWidget);
      final dividerWidget = tester.widget<Divider>(dividerFinder);
      expect(dividerWidget.color, testDividerBg);
    });

    testWidgets('XuanAppBar uses background and foreground from default theme Set', (tester) async {
      await tester.pumpWidget(
        XuanThemeScope(
          themeData: DefaultXuanThemeData.themeSet.light,
          child: const MaterialApp(
            home: Scaffold(
              appBar: XuanAppBar(
                title: Text('Test Title'),
              ),
            ),
          ),
        ),
      );

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);
      final appBarWidget = tester.widget<AppBar>(appBarFinder);
      
      // Default light theme appbar background is Color(0xFFF5F5F5)
      expect(appBarWidget.backgroundColor, const Color(0xFFF5F5F5));
      expect(appBarWidget.foregroundColor, const Color(0xFF000000));
    });
  });
}
