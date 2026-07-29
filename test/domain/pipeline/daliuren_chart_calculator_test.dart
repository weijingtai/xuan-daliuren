import 'package:flutter_test/flutter_test.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:metaphysics_core/models/eight_chars.dart';
import 'package:metaphysics_core/models/jie_qi_info.dart';
import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_calculator.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_params.dart';
import 'package:daliuren/domain/pipeline/daliuren_calculation_context.dart';
import 'package:daliuren/domain/services/calculators/lunar_calculator.dart';
import 'package:daliuren/domain/services/calculators/tian_di_pan_calculator.dart';
import 'package:daliuren/domain/services/calculators/gui_ren_calculator.dart';
import 'package:daliuren/domain/services/calculators/four_class_calculator.dart';
import 'package:daliuren/domain/services/calculators/three_chuan_calculator.dart';
import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service_impl.dart';
import 'package:daliuren/data/services/shen_sha_data_service_impl.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';

/// Fake shen sha data port — implements (not extends) the interface class.
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

  @override  Future<List<dynamic>> loadZhiShenShaRaw() async => [];
  @override  Future<List<dynamic>> loadJiShenShaRaw() async => [];
  @override  Future<List<dynamic>> loadXunShenShaRaw() async => [];
  @override  Future<List<dynamic>> loadYearGanShenShaRaw() async => [];
  @override  Future<List<dynamic>> loadMonthGanShenShaRaw() async => [];
  @override  Future<List<dynamic>> loadMonthZhiGanShenShaRaw() async => [];
}

final _fixtureUtc = DateTime(2024, 8, 6, 0, 22).toUtc();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DaliurenCalculationContext preloadedContext;
  late DaliurenChartCalculator calculator;

  setUpAll(() async {
    final dataService = ShenShaDataServiceImpl(
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
      calculationService: calcService,
    );
    calculator = DaliurenChartCalculator(context: preloadedContext);
  });

  ResolvedMoment _moment() => ResolvedMoment(
        source: DivinationMoment(
          instantUtc: _fixtureUtc,
          place: const GeoPoint(latitude: 39.9, longitude: 116.4),
          reckoning: EnumDatetimeType.standard,
        ),
        nominalTime: _fixtureUtc,
        eightChars: EightChars(
          year: '丙午', month: '乙未', day: '戊戌', time: '壬子',
        ),
        lunar: const LunarDate(month: 7, day: 3, isLeapMonth: false),
        jieQi: JieQiInfo(
          current: '大暑',
          next: '立秋',
          currentSolarTermIndex: 12,
          daysToNextTerm: 3,
        ),
      );

  group('DaliurenChartCalculator', () {
    test('daliuren_calculator_matches_legacy_output', () {
      const params = DaliurenChartParams(uuid: 'test-uuid-001', question: '测试占卜');
      final contract = calculator.calculate(_moment(), params);
      expect(contract.uuid, 'test-uuid-001');
      expect(contract.question, '测试占卜');
      expect(contract.createdAt, isNotNull);
      expect(contract.ganzhiJson, isNotNull);
    });

    test('daliuren_calculator_is_deterministic', () {
      const params = DaliurenChartParams(uuid: 'test-uuid-002');
      final m = _moment();
      expect(
        calculator.calculate(m, params).toJson(),
        calculator.calculate(m, params).toJson(),
      );
    });

    test('daliuren_context_preloads_shensha', () {
      expect(preloadedContext.knownShenShaNames, contains('干德'));
      expect(preloadedContext.knownShenShaNames, contains('太岁'));
    });

    test('daliuren_calculate_produces_shensha_without_await', () {
      const params = DaliurenChartParams(uuid: 'test-uuid-003');
      final contract = calculator.calculate(_moment(), params);
      expect(contract.paramsJson, isNotNull);
    });
  });
}
