import 'dart:convert';

import 'package:enumeration/enums.dart' show EnumDatetimeType;
import 'package:flutter_test/flutter_test.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:metaphysics_core/models/eight_chars.dart';
import 'package:metaphysics_core/models/jie_qi_info.dart';
import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_calculator.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_params.dart';
import 'package:daliuren/domain/pipeline/daliuren_calculation_context.dart';
import 'package:daliuren/domain/pipeline/daliuren_pipeline_executor.dart';
import 'package:daliuren/domain/services/calculators/lunar_calculator.dart';
import 'package:daliuren/domain/services/calculators/tian_di_pan_calculator.dart';
import 'package:daliuren/domain/services/calculators/gui_ren_calculator.dart';
import 'package:daliuren/domain/services/calculators/four_class_calculator.dart';
import 'package:daliuren/domain/services/calculators/three_chuan_calculator.dart';
import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service_impl.dart';
import 'package:daliuren/data/services/shen_sha_data_service_impl.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';

class _FakeShenShaData implements DaLiuRenShenShaDataRepository {
  @override
  Future<List<dynamic>> loadGanShenShaRaw() async => [
        {
          'name': '干德',
          'jiXiong': '吉',
          'descriptionList': ['主转凶为吉'],
          'type': '干煞',
          'locationMapper': {
            '甲': '寅', '己': '寅', '乙': '申', '庚': '申',
            '丙': '巳', '辛': '巳', '丁': '亥', '壬': '亥',
            '戊': '巳', '癸': '巳',
          },
          'locationDescriptionList': ['甲己见寅，乙庚见申，丙辛戊癸见巳，丁壬见亥'],
        },
      ];

  @override
  Future<List<dynamic>> loadYearShenShaRaw() async => [
        {
          'name': '太岁',
          'jiXiong': '吉',
          'descriptionList': ['天子，元首，主一年吉凶'],
          'type': '年煞',
          'locationMapper': {
            '寅': '寅', '卯': '卯', '辰': '辰', '巳': '巳',
            '午': '午', '未': '未', '申': '申', '酉': '酉',
            '戌': '戌', '亥': '亥', '子': '子', '丑': '丑',
          },
          'locationDescriptionList': ['年支本身'],
        },
      ];

  @override
  Future<List<dynamic>> loadMonthShenShaRaw() async => [
        {
          'name': '天德',
          'jiXiong': '吉',
          'descriptionList': ['主化凶为吉'],
          'type': '月煞',
          'locationMapper': {
            '子': '巽', '丑': '庚', '寅': '丁', '卯': '坤',
            '辰': '壬', '巳': '辛', '午': '乾', '未': '甲',
            '申': '癸', '酉': '艮', '戌': '丙', '亥': '乙',
          },
          'locationDescriptionList': [],
        },
      ];

  @override
  Future<List<dynamic>> loadZhiShenShaRaw() async => [];
  @override
  Future<List<dynamic>> loadJiShenShaRaw() async => [];
  @override
  Future<List<dynamic>> loadXunShenShaRaw() async => [];
  @override
  Future<List<dynamic>> loadYearGanShenShaRaw() async => [];
  @override
  Future<List<dynamic>> loadMonthGanShenShaRaw() async => [];
  @override
  Future<List<dynamic>> loadMonthZhiGanShenShaRaw() async => [];
}

final _fixtureUtc = DateTime(2024, 8, 6, 0, 22).toUtc();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ShenShaDataService dataService;
  late DaliurenCalculationContext preloadedContext;
  late DaliurenChartCalculator calculator;
  late DaliurenPipelineExecutor executor;

  setUpAll(() async {
    dataService = ShenShaDataServiceImpl(
      shenShaData: _FakeShenShaData(),
    );
    final shenShaService = ShenShaCalculationServiceImpl(
      dataService: dataService,
    );
    final calcService = DaLiuRenCalculationService(
      lunarCalculator: LunarCalculator(),
      tianDiPanCalculator: TianDiPanCalculator(),
      guiRenCalculator: GuiRenCalculator(),
      fourClassCalculator: FourClassCalculator(),
      threeChuanCalculator: ThreeChuanCalculator(),
    );
    preloadedContext = await DaliurenCalculationContext.load(
      shenShaService: shenShaService,
      shenShaDataService: dataService,
      calculationService: calcService,
    );
    calculator = DaliurenChartCalculator(context: preloadedContext);
    executor = DaliurenPipelineExecutor(
      shenShaService: shenShaService,
      shenShaDataService: dataService,
      calculationService: calcService,
    );
  });

  ResolvedMoment _moment() => ResolvedMoment(
        source: DivinationMoment(
          instantUtc: _fixtureUtc,
          place: const GeoPoint(latitude: 39.9, longitude: 116.4),
          reckoning: EnumDatetimeType.standard,
        ),
        nominalTime: _fixtureUtc,
        eightChars: EightChars(
          year: JiaZi.getFromGanZhiValue('丙午')!,
          month: JiaZi.getFromGanZhiValue('乙未')!,
          day: JiaZi.getFromGanZhiValue('戊戌')!,
          time: JiaZi.getFromGanZhiValue('壬子')!,
        ),
        lunar: const LunarDate(month: 7, day: 3, isLeapMonth: false),
        jieQi: JieQiInfo(
          jieQi: TwentyFourJieQi.LI_QIU,
          startAt: DateTime(2024, 8, 7, 8, 0),
          endAt: DateTime(2024, 8, 22, 22, 0),
        ),
      );

  group('DaliurenPipelineExecutor', () {
    test('daliuren_executor_produces_contract', () async {
      final params = DaliurenChartParams(
        uuid: 'test-uuid-exec-001',
        question: '测试占卜',
        createdAt: DateTime(2024, 1, 1),
      );
      final result = await executor.execute(moment: _moment(), params: params);

      // At least 4 concrete business field values
      expect(result.contract.uuid, 'test-uuid-exec-001');
      expect(result.contract.question, '测试占卜');
      expect(result.contract.createdAt, DateTime(2024, 1, 1));
      expect(result.contract.schoolId, 'default');

      // shenShaJson should be non-empty (loaded by context)
      final shenSha = jsonDecode(result.contract.shenShaJson!) as Map;
      final list = shenSha['shenShaList'] as List;
      expect(list, isNotEmpty);
    });

    test('daliuren_executor_matches_direct_calculator_call', () async {
      final params = DaliurenChartParams(
        uuid: 'test-uuid-exec-002',
        createdAt: DateTime(2024, 1, 1),
      );
      final moment = _moment();

      final executorResult = await executor.execute(moment: moment, params: params);
      final calculatorResult = calculator.calculate(moment, params);

      expect(
        executorResult.contract.toJson(),
        calculatorResult.toJson(),
      );
    });

    test('daliuren_executor_is_deterministic', () async {
      final params = DaliurenChartParams(
        uuid: 'test-uuid-exec-003',
        createdAt: DateTime(2024, 1, 1),
      );
      final moment = _moment();

      final first = await executor.execute(moment: moment, params: params);
      final second = await executor.execute(moment: moment, params: params);

      expect(
        first.contract.toJson(),
        second.contract.toJson(),
      );
    });
  });
}
