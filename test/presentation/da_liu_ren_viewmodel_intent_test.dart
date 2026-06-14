import 'package:flutter_test/flutter_test.dart';
import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:daliuren/domain/usecases/calculate_divination_usecase.dart';
import 'package:daliuren/domain/usecases/load_divination_data_usecase.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';
import 'package:daliuren/presentation/models/da_liu_ren_input_state.dart';
import 'package:daliuren/presentation/viewmodels/da_liu_ren_viewmodel.dart';
import 'package:metaphysics_core/enums.dart';

/// 简单的 DaLiuRenRepository Fake
class FakeDaLiuRenRepository implements DaLiuRenRepository {
  @override
  Future<DaLiuRenKePan> calculateDivination(DateTime dateTime,
      {String? question}) async {
    throw const DivinationFailure('Fake: 不支持计算');
  }

  @override
  Future<DaLiuRenKePan> calculateManualDivination({
    required JiaZi dayJiaZi,
    required YinYang yinYangDun,
    required MonthGeneral monthGeneral,
    DiZhi? timeZhi,
    int? juNumber,
    required JiaZi yearJiaZi,
    required JiaZi monthJiaZi,
  }) async {
    throw const DivinationFailure('Fake: 不支持手动计算');
  }

  @override
  Future<void> loadDivinationData() async {
    // 无操作
  }

  @override
  Future<List<dynamic>> getYuDingData() async => [];

  @override
  Future<Map<String, dynamic>> getJuMapperData() async => {};
}

void main() {
  group('DaLiuRenViewModel Input Intents', () {
    late DaLiuRenViewModel viewModel;

    setUp(() {
      final fakeRepo = FakeDaLiuRenRepository();
      viewModel = DaLiuRenViewModel(
        calculateDivinationUseCase: CalculateDivinationUseCase(fakeRepo),
        loadDivinationDataUseCase: LoadDivinationDataUseCase(fakeRepo),
      );
    });

    group('input state update methods', () {
      test('updateYearJiaZi should update inputState', () {
        expect(viewModel.inputState.yearJiaZi, isNull);

        viewModel.updateYearJiaZi('甲子');
        expect(viewModel.inputState.yearJiaZi, '甲子');

        viewModel.updateYearJiaZi('乙丑');
        expect(viewModel.inputState.yearJiaZi, '乙丑');
      });

      test('updateMonthJiaZi should update inputState', () {
        viewModel.updateMonthJiaZi('丙寅');
        expect(viewModel.inputState.monthJiaZi, '丙寅');
      });

      test('updateDayJiaZi should update inputState', () {
        viewModel.updateDayJiaZi('丁卯');
        expect(viewModel.inputState.dayJiaZi, '丁卯');
      });

      test('updateTimeJiaZi should update inputState', () {
        viewModel.updateTimeJiaZi('戊辰');
        expect(viewModel.inputState.timeJiaZi, '戊辰');
      });

      test('updateTimeJiaZi with null should clear field', () {
        viewModel.updateTimeJiaZi('戊辰');
        expect(viewModel.inputState.timeJiaZi, '戊辰');

        viewModel.updateTimeJiaZi(null);
        expect(viewModel.inputState.timeJiaZi, isNull);
      });

      test('updateTimeJiaZi with empty string should clear field', () {
        viewModel.updateTimeJiaZi('戊辰');
        viewModel.updateTimeJiaZi('');
        expect(viewModel.inputState.timeJiaZi, isNull);
      });

      test('updateMonthGeneral should update inputState', () {
        viewModel.updateMonthGeneral('登明');
        expect(viewModel.inputState.monthGeneral, '登明');
      });

      test('updateYinYangDun should update inputState', () {
        viewModel.updateYinYangDun(true);
        expect(viewModel.inputState.isYinDun, true);

        viewModel.updateYinYangDun(false);
        expect(viewModel.inputState.isYinDun, false);
      });

      test('updateJuNumber should update inputState', () {
        viewModel.updateJuNumber(5);
        expect(viewModel.inputState.juNumber, 5);
      });

      test('updateJuNumber with null should clear field', () {
        viewModel.updateJuNumber(5);
        viewModel.updateJuNumber(null);
        expect(viewModel.inputState.juNumber, isNull);
      });

      test('updateInputQuestion should update inputState and question', () {
        viewModel.updateInputQuestion('测试问题');
        expect(viewModel.inputState.question, '测试问题');
        expect(viewModel.question, '测试问题');
      });

      test('updateInputQuestion with null should clear fields', () {
        viewModel.updateInputQuestion('测试问题');
        viewModel.updateInputQuestion(null);
        expect(viewModel.inputState.question, isNull);
        expect(viewModel.question, isNull);
      });
    });

    group('submitManualDivination', () {
      test('should return false when input is incomplete', () async {
        // 不设置任何字段
        final result = await viewModel.submitManualDivination();

        expect(result, isFalse);
        expect(viewModel.isError, isTrue);
      });

      test('should return false when only partial fields set', () async {
        viewModel.updateYearJiaZi('甲子');
        viewModel.updateMonthJiaZi('乙丑');
        // 缺少 dayJiaZi, isYinDun, monthGeneral, timeOrJu

        final result = await viewModel.submitManualDivination();

        expect(result, isFalse);
        expect(viewModel.isError, isTrue);
      });

      test('should return false when timeOrJu is missing', () async {
        viewModel.updateYearJiaZi('甲子');
        viewModel.updateMonthJiaZi('乙丑');
        viewModel.updateDayJiaZi('丙寅');
        viewModel.updateYinYangDun(true);
        viewModel.updateMonthGeneral('登明');
        // 缺少 timeJiaZi 和 juNumber

        final result = await viewModel.submitManualDivination();

        expect(result, isFalse);
        expect(viewModel.isError, isTrue);
      });

      test('should attempt calculation with valid timeJiaZi inputs', () async {
        viewModel.updateYearJiaZi('甲子');
        viewModel.updateMonthJiaZi('乙丑');
        viewModel.updateDayJiaZi('丙寅');
        viewModel.updateTimeJiaZi('丁卯');
        viewModel.updateYinYangDun(true);
        viewModel.updateMonthGeneral('登明');

        // FakeRepository 会抛出异常，所以 result 为 false
        // 但关键是我们验证了验证通过后进入了计算流程
        final result = await viewModel.submitManualDivination();

        // Fake 抛出异常，所以返回 false
        expect(result, isFalse);
        expect(viewModel.inputState.isReadyToSubmit, isTrue);
      });

      test('should attempt calculation with valid juNumber inputs', () async {
        viewModel.updateYearJiaZi('甲子');
        viewModel.updateMonthJiaZi('乙丑');
        viewModel.updateDayJiaZi('丙寅');
        viewModel.updateYinYangDun(false);
        viewModel.updateMonthGeneral('登明');
        viewModel.updateJuNumber(5);

        final result = await viewModel.submitManualDivination();

        expect(result, isFalse); // Fake 抛出异常
        expect(viewModel.inputState.isReadyToSubmit, isTrue);
      });
    });

    group('submitDateTimeDivination', () {
      test('should set selectedDateTime', () async {
        final target = DateTime(2024, 6, 15, 10, 30);
        await viewModel.submitDateTimeDivination(target);

        expect(viewModel.selectedDateTime, target);
      });
    });

    group('clearInput', () {
      test('should reset inputState to empty', () {
        viewModel.updateYearJiaZi('甲子');
        viewModel.updateMonthJiaZi('乙丑');
        viewModel.updateDayJiaZi('丙寅');
        viewModel.updateTimeJiaZi('丁卯');
        viewModel.updateYinYangDun(true);
        viewModel.updateMonthGeneral('登明');
        viewModel.updateJuNumber(5);
        viewModel.updateInputQuestion('测试问题');

        viewModel.clearInput();

        expect(viewModel.inputState, equals(DaLiuRenInputState.empty));
        expect(viewModel.question, isNull);
      });

      test('should notify listeners on clearInput', () {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        viewModel.clearInput();
        expect(notified, isTrue);
      });
    });

    group('listener notifications', () {
      test('each input update should notify listeners', () {
        var count = 0;
        viewModel.addListener(() {
          count++;
        });

        viewModel.updateYearJiaZi('甲子');
        viewModel.updateMonthJiaZi('乙丑');
        viewModel.updateDayJiaZi('丙寅');
        viewModel.updateTimeJiaZi('丁卯');
        viewModel.updateYinYangDun(true);
        viewModel.updateMonthGeneral('登明');
        viewModel.updateJuNumber(5);
        viewModel.updateInputQuestion('测试');

        expect(count, 8);
      });
    });
  });
}
