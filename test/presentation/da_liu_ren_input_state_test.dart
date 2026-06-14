import 'package:flutter_test/flutter_test.dart';
import 'package:daliuren/presentation/models/da_liu_ren_input_state.dart';

void main() {
  group('DaLiuRenInputState', () {
    group('copyWith', () {
      test('should create copy with updated yearJiaZi', () {
        const state = DaLiuRenInputState.empty;
        final updated = state.copyWith(yearJiaZi: '甲子');

        expect(updated.yearJiaZi, '甲子');
        expect(updated.monthJiaZi, isNull);
        expect(updated.dayJiaZi, isNull);
        // 原对象不可变
        expect(state.yearJiaZi, isNull);
      });

      test('should create copy preserving existing fields', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
        );
        final updated = state.copyWith(timeJiaZi: '丁卯');

        expect(updated.yearJiaZi, '甲子');
        expect(updated.monthJiaZi, '乙丑');
        expect(updated.dayJiaZi, '丙寅');
        expect(updated.timeJiaZi, '丁卯');
      });

      test('should clear timeJiaZi with clearTimeJiaZi flag', () {
        const state = DaLiuRenInputState(
          timeJiaZi: '甲子',
          juNumber: 3,
        );
        final updated = state.copyWith(clearTimeJiaZi: true);

        expect(updated.timeJiaZi, isNull);
        expect(updated.juNumber, 3); // juNumber 保持不变
      });

      test('should clear juNumber with clearJuNumber flag', () {
        const state = DaLiuRenInputState(
          timeJiaZi: '甲子',
          juNumber: 3,
        );
        final updated = state.copyWith(clearJuNumber: true);

        expect(updated.timeJiaZi, '甲子');
        expect(updated.juNumber, isNull);
      });

      test('should clear question with clearQuestion flag', () {
        const state = DaLiuRenInputState(question: '测试问题');
        final updated = state.copyWith(clearQuestion: true);

        expect(updated.question, isNull);
      });

      test('should copy all fields at once', () {
        final updated = DaLiuRenInputState.empty.copyWith(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          timeJiaZi: '丁卯',
          monthGeneral: '登明',
          isYinDun: true,
          juNumber: 5,
          question: '测试',
        );

        expect(updated.yearJiaZi, '甲子');
        expect(updated.monthJiaZi, '乙丑');
        expect(updated.dayJiaZi, '丙寅');
        expect(updated.timeJiaZi, '丁卯');
        expect(updated.monthGeneral, '登明');
        expect(updated.isYinDun, true);
        expect(updated.juNumber, 5);
        expect(updated.question, '测试');
      });
    });

    group('validationErrors', () {
      test('should return all errors for empty state', () {
        const state = DaLiuRenInputState.empty;
        final errors = state.validationErrors;

        expect(errors, contains('yearJiaZi'));
        expect(errors, contains('monthJiaZi'));
        expect(errors, contains('dayJiaZi'));
        expect(errors, contains('isYinDun'));
        expect(errors, contains('monthGeneral'));
        expect(errors, contains('timeOrJu'));
        expect(errors.length, 6);
      });

      test('should return error when only timeJiaZi is missing', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          isYinDun: true,
          monthGeneral: '登明',
          // timeJiaZi 和 juNumber 都为空
        );
        final errors = state.validationErrors;

        expect(errors, isNot(contains('yearJiaZi')));
        expect(errors, isNot(contains('monthJiaZi')));
        expect(errors, isNot(contains('dayJiaZi')));
        expect(errors, isNot(contains('isYinDun')));
        expect(errors, isNot(contains('monthGeneral')));
        expect(errors, contains('timeOrJu'));
        expect(errors.length, 1);
      });

      test('should return no errors when timeJiaZi is provided', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          timeJiaZi: '丁卯',
          isYinDun: true,
          monthGeneral: '登明',
        );
        final errors = state.validationErrors;

        expect(errors, isEmpty);
      });

      test('should return no errors when juNumber is provided', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          isYinDun: false,
          monthGeneral: '登明',
          juNumber: 5,
        );
        final errors = state.validationErrors;

        expect(errors, isEmpty);
      });

      test('should treat empty string same as null', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '',
          monthJiaZi: '',
          dayJiaZi: '',
          monthGeneral: '',
        );
        final errors = state.validationErrors;

        expect(errors, contains('yearJiaZi'));
        expect(errors, contains('monthJiaZi'));
        expect(errors, contains('dayJiaZi'));
        expect(errors, contains('monthGeneral'));
      });
    });

    group('isReadyToSubmit', () {
      test('should be false for empty state', () {
        const state = DaLiuRenInputState.empty;
        expect(state.isReadyToSubmit, isFalse);
      });

      test('should be false when required fields are missing', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          // 其他必填字段缺失
        );
        expect(state.isReadyToSubmit, isFalse);
      });

      test('should be true with timeJiaZi and all required fields', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          timeJiaZi: '丁卯',
          isYinDun: true,
          monthGeneral: '登明',
        );
        expect(state.isReadyToSubmit, isTrue);
      });

      test('should be true with juNumber instead of timeJiaZi', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          isYinDun: false,
          monthGeneral: '登明',
          juNumber: 3,
        );
        expect(state.isReadyToSubmit, isTrue);
      });

      test('should be true with both timeJiaZi and juNumber', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          timeJiaZi: '丁卯',
          isYinDun: true,
          monthGeneral: '登明',
          juNumber: 5,
        );
        expect(state.isReadyToSubmit, isTrue);
      });

      test('should be false without timeOrJu even if other fields present', () {
        const state = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
          dayJiaZi: '丙寅',
          isYinDun: true,
          monthGeneral: '登明',
          // 缺少 timeJiaZi 和 juNumber
        );
        expect(state.isReadyToSubmit, isFalse);
      });
    });

    group('equality', () {
      test('should be equal for same values', () {
        const state1 = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
        );
        const state2 = DaLiuRenInputState(
          yearJiaZi: '甲子',
          monthJiaZi: '乙丑',
        );

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal for different values', () {
        const state1 = DaLiuRenInputState(yearJiaZi: '甲子');
        const state2 = DaLiuRenInputState(yearJiaZi: '乙丑');

        expect(state1, isNot(equals(state2)));
      });
    });

    group('empty', () {
      test('should have all fields null', () {
        const state = DaLiuRenInputState.empty;

        expect(state.yearJiaZi, isNull);
        expect(state.monthJiaZi, isNull);
        expect(state.dayJiaZi, isNull);
        expect(state.timeJiaZi, isNull);
        expect(state.monthGeneral, isNull);
        expect(state.isYinDun, isNull);
        expect(state.juNumber, isNull);
        expect(state.question, isNull);
      });
    });
  });
}
