import 'package:flutter_test/flutter_test.dart';
import 'package:daliuren/domain/schools/school_catalog.dart';

void main() {
  group('SchoolCatalog', () {
    test('uses fixed user-preference order for all eight schools', () {
      expect(
        SchoolCatalog.all.map((entry) => entry.id).toList(),
        [
          'yuding',
          'bifa',
          'zhinan',
          'kejing',
          'daliuren_daquan',
          'rengui',
          'liuren_cuiyan',
          'guanlu_shenshu',
        ],
      );
    });

    test('only yuding is available in first stage', () {
      final available = SchoolCatalog.all
          .where((entry) => entry.status == SchoolAvailabilityStatus.available)
          .map((entry) => entry.id)
          .toList();

      expect(available, ['yuding']);
      expect(SchoolCatalog.byId('bifa')!.status, SchoolAvailabilityStatus.planned);
    });

    test('planned schools expose roadmap metadata', () {
      final bifa = SchoolCatalog.byId('bifa')!;

      expect(bifa.displayName, '毕法赋');
      expect(bifa.representativeBook, '《毕法赋》');
      expect(bifa.description, isNotEmpty);
      expect(bifa.tags, contains('法则'));
    });
  });
}
