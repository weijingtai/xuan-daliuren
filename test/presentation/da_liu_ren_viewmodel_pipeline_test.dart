import 'package:enumeration/enums.dart' show EnumDatetimeType;
import 'package:flutter_test/flutter_test.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:metaphysics_core/models/eight_chars.dart';
import 'package:metaphysics_core/models/jie_qi_info.dart';
import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_params.dart';
import 'package:daliuren/domain/pipeline/daliuren_pipeline_executor.dart';
import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:daliuren/domain/usecases/calculate_divination_usecase.dart';
import 'package:daliuren/domain/usecases/load_divination_data_usecase.dart';
import 'package:daliuren/domain/services/calculators/lunar_calculator.dart';
import 'package:daliuren/domain/services/calculators/tian_di_pan_calculator.dart';
import 'package:daliuren/domain/services/calculators/gui_ren_calculator.dart';
import 'package:daliuren/domain/services/calculators/four_class_calculator.dart';
import 'package:daliuren/domain/services/calculators/three_chuan_calculator.dart';
import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service_impl.dart';
import 'package:daliuren/data/services/shen_sha_data_service_impl.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';
import 'package:daliuren/presentation/viewmodels/da_liu_ren_viewmodel.dart';

/// 最小可用的 DaLiuRenRepository Fake：让老路径产出盘面。
class _FakeDaLiuRenRepository implements DaLiuRenRepository {
  @override
  Future<DaLiuRenKePan> calculateDivination(DateTime dateTime,
      {String? question}) async {
    return DaLiuRenKePan(
      panDateTime: dateTime,
      question: question,
      eightChatStr: '丙午 乙未 戊戌 壬子',
      monthGeneral: MonthGeneral.SHEN_CHUAN_SONG,
    );
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
    return DaLiuRenKePan(
      panDateTime: DateTime.now(),
      eightChatStr: '丙午 乙未 戊戌 壬子',
      monthGeneral: monthGeneral,
    );
  }

  @override
  Future<void> loadDivinationData() async {}

  @override
  Future<List<dynamic>> getYuDingData() async => [];

  @override
  Future<Map<String, dynamic>> getJuMapperData() async => {};
}

/// 内存 DaliurenRecordRepository。
class _InMemoryDaliurenRecordRepository implements DaliurenRecordRepository {
  final List<DaliurenDivinationRecordContract> _records = [];

  @override
  Future<String> saveRecord(DaliurenDivinationRecordContract record) async {
    _records.add(record);
    return record.uuid;
  }

  @override
  Future<List<DaliurenDivinationRecordContract>> getAllRecords() async {
    return List.of(_records);
  }

  @override
  Future<DaliurenDivinationRecordContract?> getRecordByUuid(String uuid) async {
    for (final r in _records) {
      if (r.uuid == uuid) return r;
    }
    return null;
  }

  @override
  Future<bool> softDeleteRecord(String uuid) async {
    _records.removeWhere((r) => r.uuid == uuid);
    return true;
  }

  @override
  Stream<List<DaliurenDivinationRecordContract>> watchAllRecords() async* {
    yield List.of(_records);
  }
}

/// 固定 ResolvedMoment，隔离真实历法计算。
class _FixedMomentResolver implements MomentResolver {
  const _FixedMomentResolver();

  @override
  ResolvedMoment resolve(DivinationMoment moment) => ResolvedMoment(
        source: moment,
        nominalTime: DateTime(2026, 5, 23, 8, 25),
        eightChars: EightChars(
          year: JiaZi.getFromGanZhiValue('丙午')!,
          month: JiaZi.getFromGanZhiValue('乙未')!,
          day: JiaZi.getFromGanZhiValue('戊戌')!,
          time: JiaZi.getFromGanZhiValue('壬子')!,
        ),
        lunar: const LunarDate(month: 4, day: 26, isLeapMonth: false),
        jieQi: JieQiInfo(
          jieQi: TwentyFourJieQi.XIAO_MAN,
          startAt: DateTime(2026, 5, 21),
          endAt: DateTime(2026, 6, 5),
        ),
      );

  @override
  List<ResolvedMoment> resolveCandidates(
    DivinationMoment moment,
    CandidateSpec spec,
  ) => [];
}

/// 模拟新路径失败，验证回退。
class _ThrowingMomentResolver implements MomentResolver {
  const _ThrowingMomentResolver();

  @override
  ResolvedMoment resolve(DivinationMoment moment) {
    throw StateError('模拟新路径失败');
  }

  @override
  List<ResolvedMoment> resolveCandidates(
    DivinationMoment moment,
    CandidateSpec spec,
  ) => [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _InMemoryDaliurenRecordRepository recordRepo;
  late DaLiuRenViewModel viewModel;

  DaLiuRenViewModel _buildViewModel({
    DaliurenPipelineExecutor? pipelineExecutor,
  }) {
    final fakeRepo = _FakeDaLiuRenRepository();
    return DaLiuRenViewModel(
      calculateDivinationUseCase: CalculateDivinationUseCase(fakeRepo),
      loadDivinationDataUseCase: LoadDivinationDataUseCase(fakeRepo),
      recordRepository: recordRepo,
      pipelineExecutor: pipelineExecutor,
    );
  }

  setUp(() {
    recordRepo = _InMemoryDaliurenRecordRepository();
  });

  group('DaLiuRenViewModel pipeline 接线', () {
    test('A: 注入 executor 后计算真实执行 Pipeline，落库走 Record，产出与直接调用 executor 逐字段一致', () async {
      final executor = DaliurenPipelineExecutor(
        shenShaService: _shenShaService(),
        shenShaDataService: _shenShaDataService(),
        calculationService: _calcService(),
        momentResolver: const _FixedMomentResolver(),
      );
      viewModel = _buildViewModel(pipelineExecutor: executor);
      await viewModel.initializeData();
      viewModel.updateQuestion('测试问题');
      await viewModel.recalculate();

      // 老路径照常产出盘面
      expect(viewModel.currentDivination, isNotNull);
      expect(viewModel.isError, isFalse);

      // executor 真的被执行到
      final request = viewModel.lastPipelineRequest;
      expect(request, isNotNull);
      expect(request!.params.uuid, isNotEmpty);
      expect(request.params.question, '测试问题');

      final pipelineRecord = viewModel.lastPipelineRecord;
      expect(pipelineRecord, isNotNull);
      expect(pipelineRecord!.uuid, request.params.uuid);
      expect(pipelineRecord.question, '测试问题');

      // 落库走 Record：内存 recordRepo 收到 1 条
      final saved = await recordRepo.getAllRecords();
      expect(saved, hasLength(1));
      expect(saved.single.uuid, pipelineRecord.uuid);

      // ── 执行证据：executor 真实执行 + 落库 uuid 同源 ──
      final evidence = viewModel.lastPipelineEvidence;
      expect(evidence, isNotNull, reason: 'pipeline 路径必须产出执行证据');
      expect(evidence!.callCount, 1, reason: 'executor 恰好执行一次');
      expect(evidence.requestId, pipelineRecord.uuid,
          reason: 'requestId 取 Record uuid');
      expect(evidence.resultUuid, pipelineRecord.uuid,
          reason: 'resultUuid 与落库 Record uuid 同源');
      expect(evidence.module, 'daliuren');
      expect(evidence.error, isNull, reason: '成功执行无异常');
      expect(evidence.keyResult, isNotNull, reason: '月将/三传是页面可观察结果');
      // 落库的 Record 就是 lastPipelineRecord（同 uuid）
      expect(saved.single.uuid, pipelineRecord.uuid,
          reason: '落库 Record uuid 与排盘 uuid 同源');

      // 与直接调用 executor 的产出逐字段一致
      final direct = await executor.execute(
        ChartRequest<DaliurenChartParams>(
          moment: request.moment,
          params: request.params,
        ),
      );
      expect(direct.uuid, pipelineRecord.uuid);
      expect(direct.question, pipelineRecord.question);
      expect(direct.createdAt, pipelineRecord.createdAt);
      expect(direct.schoolId, pipelineRecord.schoolId);
      expect(direct.yueJiangJson, pipelineRecord.yueJiangJson);
      expect(direct.sanChuanJson, pipelineRecord.sanChuanJson);
      expect(direct.siKeJson, pipelineRecord.siKeJson);
      expect(direct.shenShaJson, pipelineRecord.shenShaJson);
      expect(direct.paramsJson, pipelineRecord.paramsJson);
    });

    test('B: 未注入 executor 时不崩、Pipeline 不走、老路径照常落库', () async {
      viewModel = _buildViewModel();
      await viewModel.initializeData();
      viewModel.updateQuestion('测试问题');
      await viewModel.recalculate();

      expect(viewModel.currentDivination, isNotNull);
      expect(viewModel.isError, isFalse);
      expect(viewModel.lastPipelineRequest, isNull);
      expect(viewModel.lastPipelineRecord, isNull);
      expect(await recordRepo.getAllRecords(), hasLength(1));
    });

    test('B2: 注入 executor 但 Pipeline 抛错时不崩、老路径照常产出', () async {
      final executor = DaliurenPipelineExecutor(
        shenShaService: _shenShaService(),
        shenShaDataService: _shenShaDataService(),
        calculationService: _calcService(),
        momentResolver: const _ThrowingMomentResolver(),
      );
      viewModel = _buildViewModel(pipelineExecutor: executor);
      await viewModel.initializeData();
      viewModel.updateQuestion('测试问题');
      await viewModel.recalculate();

      expect(viewModel.currentDivination, isNotNull);
      expect(viewModel.isError, isFalse);
      expect(viewModel.lastPipelineRecord, isNull);
      expect(await recordRepo.getAllRecords(), hasLength(1));
    });

    test('C: DaliurenChartParams toJson/fromJson 互逆 round-trip', () {
      final realParams = DaliurenChartParams(
        uuid: 'daliuren-test-001',
        question: '今日运势',
        createdAt: DateTime(2026, 5, 23, 8, 25),
      );
      final decoded = DaliurenChartParams.fromJson(realParams.toJson());
      expect(decoded.uuid, realParams.uuid);
      expect(decoded.question, realParams.question);
      expect(decoded.createdAt, realParams.createdAt);
    });

    test('C2: fromJson 缺字段套默认不抛', () {
      final decoded = DaliurenChartParams.fromJson(const {});
      expect(decoded.uuid, '');
      expect(decoded.question, isNull);
      expect(decoded.createdAt, DateTime.fromMillisecondsSinceEpoch(0));
    });

    test('C3: fromJson 类型不合法抛 FormatException，不静默兜底', () {
      expect(
        () => DaliurenChartParams.fromJson(const {'uuid': 123}),
        throwsFormatException,
      );
      expect(
        () => DaliurenChartParams.fromJson(const {'question': 7}),
        throwsFormatException,
      );
      expect(
        () => DaliurenChartParams.fromJson(const {'createdAt': 42}),
        throwsFormatException,
      );
      expect(
        () => DaliurenChartParams.fromJson(const {'createdAt': 'not-a-date'}),
        throwsFormatException,
      );
    });
  });
}

ShenShaDataServiceImpl _shenShaDataService() =>
    ShenShaDataServiceImpl(shenShaData: _FakeShenShaData());

ShenShaCalculationServiceImpl _shenShaService() =>
    ShenShaCalculationServiceImpl(dataService: _shenShaDataService());

DaLiuRenCalculationService _calcService() => DaLiuRenCalculationService(
      lunarCalculator: LunarCalculator(),
      tianDiPanCalculator: TianDiPanCalculator(),
      guiRenCalculator: GuiRenCalculator(),
      fourClassCalculator: FourClassCalculator(),
      threeChuanCalculator: ThreeChuanCalculator(),
    );

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
