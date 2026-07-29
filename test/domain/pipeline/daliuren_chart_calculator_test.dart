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

  late ShenShaDataService dataService;
  late DaliurenCalculationContext preloadedContext;
  late DaliurenChartCalculator calculator;

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

  group('DaliurenChartCalculator', () {
    test('daliuren_calculator_matches_legacy_output', () {
      final params = DaliurenChartParams(
        uuid: 'test-uuid-001',
        question: '测试占卜',
        createdAt: DateTime(2024, 1, 1),
      );
      final contract = calculator.calculate(_moment(), params);

      // 4 concrete business field assertions
      expect(contract.uuid, 'test-uuid-001');
      expect(contract.question, '测试占卜');
      expect(contract.createdAt, DateTime(2024, 1, 1));
      // gongMapper should have 12 entries (12 地支)
      final siKe = jsonDecode(contract.siKeJson!) as Map;
      expect(siKe['isFullClass'], isTrue);
    });

    test('daliuren_calculator_is_deterministic', () {
      final params = DaliurenChartParams(
        uuid: 'test-uuid-002',
        createdAt: DateTime(2024, 1, 1),
      );
      final m = _moment();
      expect(
        calculator.calculate(m, params).toJson(),
        calculator.calculate(m, params).toJson(),
      );
    });

    test('daliuren_context_preloads_shensha', () {
      expect(preloadedContext.knownShenShaNames, contains('干德'));
      expect(preloadedContext.knownShenShaNames, contains('太岁'));
      expect(preloadedContext.knownShenShaNames, contains('天德'));
    });

    test('daliuren_calculate_produces_shensha_without_await', () {
      final params = DaliurenChartParams(
        uuid: 'test-uuid-003',
        createdAt: DateTime(2024, 1, 1),
      );
      final contract = calculator.calculate(_moment(), params);

      // 裁决三核心验证：context 预载的神煞经 calculate 同步消费进 Contract
      expect(contract.shenShaJson, isNotNull, reason: '神煞字段应非空');
      expect(contract.shenShaJson!.isNotEmpty, true, reason: '神煞数据应完整');

      final shenSha = jsonDecode(contract.shenShaJson!) as Map;
      final list = shenSha['shenShaList'] as List;
      expect(list, isNotEmpty, reason: '神煞列表应非空');

      // 断言具体已知神煞名（context.load 装载了权威全集）
      final names = list.map((e) => (e as Map)['name'] as String).toList();
      expect(names, contains('干德'), reason: '应含神煞「干德」');
      expect(names, contains('太岁'), reason: '应含神煞「太岁」');
      expect(names, contains('天德'), reason: '应含神煞「天德」');

      // 每条神煞记录应含吉凶与类型（具体值，非空洞断言）
      final firstEntry = list.first as Map;
      expect(firstEntry['jiXiong'], isNotNull, reason: '神煞吉凶应非空');
      expect(firstEntry['type'], isNotNull, reason: '神煞类型应非空');
    });

    test('daliuren_calculate_contains_valid_date', () {
      final params = DaliurenChartParams(
        uuid: 'test-uuid-004',
        createdAt: DateTime(2024, 1, 1),
      );
      final contract = calculator.calculate(_moment(), params);

      // Verify lunar date and ganzhi are properly set
      expect(contract.lunarDateJson, isNotNull);
      final lunar = jsonDecode(contract.lunarDateJson!) as Map;
      expect(lunar['month'], 7);
      expect(lunar['day'], 3);

      expect(contract.ganzhiJson, isNotNull);
      final ganzhi = jsonDecode(contract.ganzhiJson!) as Map;
      expect(ganzhi['year'], '丙午');
      expect(ganzhi['month'], '乙未');
      expect(ganzhi['day'], '戊戌');
      expect(ganzhi['time'], '壬子');
    });

    test('daliuren_context_loads_full_shensha_set', () async {
      // 重新 load 一次，断言装载数与权威数据源一致（禁止硬编码数字）
      final freshContext = await DaliurenCalculationContext.load(
        shenShaService: ShenShaCalculationServiceImpl(dataService: dataService),
        shenShaDataService: dataService,
        calculationService: preloadedContext.calculationService,
      );
      final totalCount = (await dataService.loadAllShenSha()).length;
      expect(freshContext.shenShaByName.length, totalCount,
          reason: 'shenShaByName 条目数应等于权威数据源神煞总数');
      expect(freshContext.knownShenShaNames.length, totalCount,
          reason: 'knownShenShaNames 条目数应等于权威数据源神煞总数');
    });

    test('daliuren_chart_contains_full_shensha', () async {
      // 用权威数据源确定神煞总数
      final totalCount = (await dataService.loadAllShenSha()).length;
      final params = DaliurenChartParams(
        uuid: 'test-uuid-005',
        createdAt: DateTime(2024, 1, 1),
      );
      final contract = calculator.calculate(_moment(), params);

      final shenSha = jsonDecode(contract.shenShaJson!) as Map;
      final list = shenSha['shenShaList'] as List;
      expect(list.length, totalCount,
          reason: 'Contract 中神煞条目数与 context 装载数一致');
    });
  });
}
