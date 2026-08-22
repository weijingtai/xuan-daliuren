import 'package:repository_contract_kernel/repository_contract_kernel.dart';
import 'dart:math';

import 'package:enumeration/enums.dart' show EnumDatetimeType;
import 'package:flutter/foundation.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';
import 'package:xuan_logger/xuan_logger.dart';
import 'package:xuan_time_location/xuan_time_location.dart';
import 'package:daliuren/domain/entities/daliuren_lesson.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';
import 'package:daliuren/domain/pipeline/daliuren_pipeline_executor.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_params.dart';
import 'package:daliuren/domain/pipeline/pipeline_evidence.dart';
import 'package:daliuren/domain/services/keti_data_service.dart' show KetiMatchResult;
import 'package:daliuren/domain/usecases/get_keti_data_usecase.dart';
import 'package:daliuren/domain/usecases/match_yuding_keti_usecase.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:daliuren/domain/usecases/calculate_divination_usecase.dart';
import 'package:daliuren/domain/usecases/calculate_shen_sha_usecase.dart';
import 'package:daliuren/domain/usecases/load_divination_data_usecase.dart';
import 'package:daliuren/domain/usecases/load_yuding_data_usecase.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';
import 'package:daliuren/presentation/viewmodels/base_viewmodel.dart';
import 'package:daliuren/presentation/models/da_liu_ren_input_state.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';

class DaLiuRenViewModel extends BaseViewModel {
  final CalculateDivinationUseCase _calculateDivinationUseCase;
  final LoadDivinationDataUseCase _loadDivinationDataUseCase;
  final CalculateShenShaUseCase? _calculateShenShaUseCase;
  final GetKetiDataUseCase? _getKetiDataUseCase;
  final MatchYuDingKetiUseCase? _matchYuDingKetiUseCase;
  final LoadYuDingDataUseCase? _loadYuDingDataUseCase;
  final DaliurenRecordRepository? _recordRepository;

  /// Pipeline 统一入参排盘执行器（可选注入）。注入后走新路径，
  /// 失败回退老路径，不打断 UI。
  final DaliurenPipelineExecutor? _pipelineExecutor;

  /// 宿主解析的当前时区（用户偏好 > 地点 > 中国默认）。null 时回退 [chinaTimeZoneId]。
  final String Function()? _timezoneProvider;

  /// 每次排盘现取，保证用户中途改偏好即时生效。
  String get _timezone => _timezoneProvider?.call() ?? chinaTimeZoneId;

  /// 最后一次走统一入参排盘的 [ChartRequest]，供测试断言 executor 被真实调用。
  ChartRequest<DaliurenChartParams>? lastPipelineRequest;

  /// 最后一次统一入参排盘产出的 Record。
  DaliurenDivinationRecordContract? lastPipelineRecord;

  /// 本次排盘执行证据（供壳侧 E2E 测试断言 executor 真实执行）。
  /// 只读：不参与生产逻辑判断、不影响渲染。
  PipelineEvidence? _lastPipelineEvidence;
  int _pipelineCallCount = 0;

  /// 最后一次走统一入参排盘的执行证据；未走 pipeline 路径时为 null。
  @visibleForTesting
  PipelineEvidence? get lastPipelineEvidence => _lastPipelineEvidence;

  DaLiuRenViewModel({
    required CalculateDivinationUseCase calculateDivinationUseCase,
    required LoadDivinationDataUseCase loadDivinationDataUseCase,
    CalculateShenShaUseCase? calculateShenShaUseCase,
    GetKetiDataUseCase? getKetiDataUseCase,
    MatchYuDingKetiUseCase? matchYuDingKetiUseCase,
    LoadYuDingDataUseCase? loadYuDingDataUseCase,
    DaliurenRecordRepository? recordRepository,
    DaliurenPipelineExecutor? pipelineExecutor,
    String Function()? timezoneProvider,
  })  : _recordRepository = recordRepository,
        _pipelineExecutor = pipelineExecutor,
        _timezoneProvider = timezoneProvider,
        _calculateDivinationUseCase = calculateDivinationUseCase,
        _loadDivinationDataUseCase = loadDivinationDataUseCase,
        _calculateShenShaUseCase = calculateShenShaUseCase,
        _getKetiDataUseCase = getKetiDataUseCase,
        _matchYuDingKetiUseCase = matchYuDingKetiUseCase,
        _loadYuDingDataUseCase = loadYuDingDataUseCase;

  // ==================== 输入状态（Input State） ====================
  DaLiuRenInputState _inputState = DaLiuRenInputState.empty;

  /// 当前输入状态（只读）
  DaLiuRenInputState get inputState => _inputState;

  // Data properties
  DateTime _selectedDateTime = DateTime.now();
  String? _question;
  DaLiuRenKePan? _currentDivination;
  List<dynamic>? _yudingData;

  // UI State properties
  JiaZi? _yearJiaZi;
  JiaZi? _monthJiaZi;
  JiaZi? _dayJiaZi;
  JiaZi? _timeJiaZi;
  DiZhi? _dunGanZhi;
  int? _juNumber;
  bool _isDataLoaded = false;

  // Shen sha results
  Map<DiZhi, List<ShenShaResult>>? _shenShaResults;

  // Matched 课体 results
  List<DaliurenLesson> _matchedLessons = [];
  List<String> _matchedKeTiNames = [];
  List<KetiMatchResult> _matchedKetiResults = [];

  // Getters
  DateTime get selectedDateTime => _selectedDateTime;
  String? get question => _question;
  DaLiuRenKePan? get currentDivination => _currentDivination;
  JiaZi? get yearJiaZi => _yearJiaZi;
  JiaZi? get monthJiaZi => _monthJiaZi;
  JiaZi? get dayJiaZi => _dayJiaZi;
  JiaZi? get timeJiaZi => _timeJiaZi;
  DiZhi? get dunGanZhi => _dunGanZhi;
  int? get juNumber => _juNumber;
  bool get isDataLoaded => _isDataLoaded;
  Map<DiZhi, List<ShenShaResult>>? get shenShaResults => _shenShaResults;
  List<DaliurenLesson> get matchedLessons => _matchedLessons;
  List<String> get matchedKeTiNames => _matchedKeTiNames;
  List<KetiMatchResult> get matchedKetiResults => _matchedKetiResults;
  List<dynamic>? get yudingData => _yudingData;

  // Initialize data
  Future<void> initializeData() async {
    if (_isDataLoaded) return;

    logger.d('🔵 [ViewModel] initializeData() called');
    setLoading();
    try {
      logger.d('🔵 [ViewModel] Calling LoadDivinationDataUseCase...');
      await _loadDivinationDataUseCase.call(NoParams());
      // Auto-load yuding data during initialization
      if (_loadYuDingDataUseCase != null) {
        logger.d('🔵 [ViewModel] Loading yuding data...');
        _yudingData = await _loadYuDingDataUseCase.call(NoParams());
        logger.d('🔵 [ViewModel] Yuding data loaded: ${_yudingData?.length ?? 0} items');
      }
      _isDataLoaded = true;
      logger.d('🔵 [ViewModel] Data loaded successfully');
      setSuccess();
    } catch (e) {
      logger.e('🔴 [ViewModel] Error loading data: $e');
      setError(e is DivinationFailure ? e.message : e.toString());
    }
  }

  /// 加载御定大六壬数据（缓存结果）
  Future<List<dynamic>> loadYuDingData() async {
    if (_yudingData != null) return _yudingData!;
    if (_loadYuDingDataUseCase == null) {
      throw DivinationFailure('LoadYuDingDataUseCase not configured');
    }
    _yudingData = await _loadYuDingDataUseCase.call(NoParams());
    return _yudingData!;
  }

  // Update selected date/time
  void updateDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
    _calculateDivination();
  }

  // Update question
  void updateQuestion(String? question) {
    _question = question;
    notifyListeners();
  }

  // Calculate divination
  Future<void> _calculateDivination() async {
    if (!_isDataLoaded) {
      await initializeData();
    }

    logger.d('🔵 [ViewModel] _calculateDivination() called for $_selectedDateTime');
    setLoading();
    try {
      final params = DateTimeParams(_selectedDateTime, question: _question);
      logger.d('🔵 [ViewModel] Calling CalculateDivinationUseCase...');
      final divination = await _calculateDivinationUseCase.call(params);
      _currentDivination = divination;
      logger.d('🔵 [ViewModel] Calculation successful: ${divination.dayJiaZi.name}日');
      _updateDivinationProperties();
      // Run async enrichment THEN do a single final notifyListeners
      await _matchKeTi();
      await _calculateShenSha();
      await _saveCurrentDivinationWithPipeline();
      setSuccess(); // This calls notifyListeners() with all data already populated
    } catch (e) {
      logger.e('🔴 [ViewModel] Calculation error: $e');
      setError(e is DivinationFailure ? e.message : e.toString());
    }
  }

  void _updateDivinationProperties() {
    if (_currentDivination != null) {
      _yearJiaZi = _currentDivination!.yearJiaZi;
      _monthJiaZi = _currentDivination!.monthJiaZi;
      _dayJiaZi = _currentDivination!.dayJiaZi;
      _timeJiaZi = _currentDivination!.timeJiaZi;
      // Add other property mappings as needed
    }
  }

  // Trigger shake animation
  void triggerShakeAnimation() {
    // This will be handled by UI widgets with GlobalKey
    notifyListeners();
  }

  // Recalculate with current parameters
  Future<void> recalculate() async {
    await _calculateDivination();
  }

  // Reset to current time
  void resetToNow() {
    updateDateTime(DateTime.now());
  }

  // Clear state
  void clear() {
    _currentDivination = null;
    _shenShaResults = null;
    _matchedLessons = [];
    _matchedKeTiNames = [];
    _matchedKetiResults = [];
    _yearJiaZi = null;
    _monthJiaZi = null;
    _dayJiaZi = null;
    _timeJiaZi = null;
    notifyListeners();
  }

  // ==================== 输入 Intent 方法 ====================

  /// 更新年干支输入
  void updateYearJiaZi(String? value) {
    _inputState = _inputState.copyWith(yearJiaZi: value);
    notifyListeners();
  }

  /// 更新月干支输入
  void updateMonthJiaZi(String? value) {
    _inputState = _inputState.copyWith(monthJiaZi: value);
    notifyListeners();
  }

  /// 更新日干支输入
  void updateDayJiaZi(String? value) {
    _inputState = _inputState.copyWith(dayJiaZi: value);
    notifyListeners();
  }

  /// 更新时干支输入
  void updateTimeJiaZi(String? value) {
    if (value == null || value.isEmpty) {
      _inputState = _inputState.copyWith(clearTimeJiaZi: true);
    } else {
      _inputState = _inputState.copyWith(timeJiaZi: value);
    }
    notifyListeners();
  }

  /// 更新月将输入
  void updateMonthGeneral(String? value) {
    _inputState = _inputState.copyWith(monthGeneral: value);
    notifyListeners();
  }

  /// 更新阴阳遁
  void updateYinYangDun(bool value) {
    _inputState = _inputState.copyWith(isYinDun: value);
    notifyListeners();
  }

  /// 更新局数
  void updateJuNumber(int? value) {
    if (value == null) {
      _inputState = _inputState.copyWith(clearJuNumber: true);
    } else {
      _inputState = _inputState.copyWith(juNumber: value);
    }
    notifyListeners();
  }

  /// 更新占卜问题
  void updateInputQuestion(String? question) {
    if (question == null || question.isEmpty) {
      _inputState = _inputState.copyWith(clearQuestion: true);
    } else {
      _inputState = _inputState.copyWith(question: question);
    }
    _question = question;
    notifyListeners();
  }

  /// 提交手动排盘（从输入状态验证并计算）
  Future<bool> submitManualDivination() async {
    if (!_inputState.isReadyToSubmit) {
      setError('输入不完整: ${_inputState.validationErrors.values.join(', ')}');
      return false;
    }

    try {
      final input = _inputState;
      final parsedYear = JiaZi.getFromGanZhiValue(input.yearJiaZi!)!;
      final parsedMonth = JiaZi.getFromGanZhiValue(input.monthJiaZi!)!;
      final parsedDay = JiaZi.getFromGanZhiValue(input.dayJiaZi!)!;
      final parsedTime = input.timeJiaZi != null
          ? JiaZi.getFromGanZhiValue(input.timeJiaZi!)
          : null;
      final parsedMonthGeneral = MonthGeneral.values.firstWhere(
        (mg) => mg.name == input.monthGeneral,
        orElse: () => throw DivinationFailure('无效的月将: ${input.monthGeneral}'),
      );

      // isYinDun: true=阴遁 → YinYang.YIN, false=阳遁 → YinYang.YANG
      final yinYangDun = input.isYinDun! ? YinYang.YIN : YinYang.YANG;

      _question = input.question;
      await updateManualJu(
        yearJiaZi: parsedYear,
        monthJiaZi: parsedMonth,
        dayJiaZi: parsedDay,
        yinYangDun: yinYangDun,
        monthGeneral: parsedMonthGeneral,
        timeJiaZi: parsedTime,
        juNumber: input.juNumber,
      );
      return true;
    } catch (e) {
      setError(e is DivinationFailure ? e.message : e.toString());
      return false;
    }
  }

  /// 从日期时间提交排盘
  Future<void> submitDateTimeDivination(DateTime dateTime) async {
    updateDateTime(dateTime);
  }

  /// 清空输入状态
  void clearInput() {
    _inputState = DaLiuRenInputState.empty;
    _question = null;
    notifyListeners();
  }

  // Update manual Ju
  Future<void> updateManualJu({
    required JiaZi yearJiaZi,
    required JiaZi monthJiaZi,
    required JiaZi dayJiaZi,
    required YinYang yinYangDun,
    required MonthGeneral monthGeneral,
    JiaZi? timeJiaZi,
    int? juNumber,
  }) async {
    setLoading();
    try {
      final params = ManualJuParams(
        dayJiaZi,
        yinYangDun,
        monthGeneral,
        timeZhi: timeJiaZi?.diZhi,
        juNumber: juNumber,
        yearJiaZi: yearJiaZi,
        monthJiaZi: monthJiaZi,
      );
      final divination = await _calculateDivinationUseCase.call(params);
      _currentDivination = divination;
      _updateDivinationProperties();
      await _matchKeTi();
      await _calculateShenSha();
      await _saveCurrentDivinationWithPipeline();
      setSuccess();
    } catch (e) {
      setError(e is DivinationFailure ? e.message : e.toString());
    }
  }

  void _saveCurrentDivination() {
    if (_recordRepository == null || _currentDivination == null) return;
    final now = DateTime.now();
    final contract = DaliurenDivinationRecordContract(
      uuid: '${now.millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      question: _question,
      createdAt: now,
    );
    _recordRepository!.put(contract, RequestContext(scopeUid: 'local-anonymous'));
  }

  /// 落库当前盘面。
  ///
  /// 注入 [DaliurenPipelineExecutor] 时走 Pipeline 统一入参排盘并落库完整 Record，
  /// 失败只记日志回退老路径，不打断 UI；未注入时走老路径。
  Future<void> _saveCurrentDivinationWithPipeline() async {
    final executor = _pipelineExecutor;
    if (executor != null && _currentDivination != null) {
      try {
        _pipelineCallCount++;
        final record = await _runPipeline(executor);
        lastPipelineRecord = record;
        _lastPipelineEvidence = PipelineEvidence(
          callCount: _pipelineCallCount,
          requestId: record.uuid,
          resultUuid: record.uuid,
          module: 'daliuren',
          keyResult: _keyResultOf(record),
          error: null,
        );
        final repo = _recordRepository;
        if (repo != null) {
          await repo.put(record, RequestContext(scopeUid: 'local-anonymous'));
        }
        return;
      } catch (error, stack) {
        _lastPipelineEvidence = PipelineEvidence(
          callCount: _pipelineCallCount,
          requestId: null,
          resultUuid: null,
          module: 'daliuren',
          keyResult: null,
          error: error,
        );
        debugPrint('大六壬 Pipeline 排盘失败，已回退老路径: $error\n$stack');
      }
    }
    _saveCurrentDivination();
  }

  /// 构建统一入参并调用 Pipeline executor 排盘，返回落库用的 Record。
  Future<DaliurenDivinationRecordContract> _runPipeline(
    DaliurenPipelineExecutor executor,
  ) async {
    final dateTime = _selectedDateTime;
    final params = DaliurenChartParams(
      uuid: 'daliuren-${dateTime.millisecondsSinceEpoch}',
      question: _question,
      createdAt: DateTime.now(),
    );
    final request = ChartRequest<DaliurenChartParams>(
      moment: DivinationMoment(
        instantUtc: dateTime.toUtc(),
        place: GeoPoint(
          latitude: 0.0,
          longitude: 0.0,
          timeZoneId: _timezone,
        ),
        reckoning: EnumDatetimeType.standard,
      ),
      params: params,
    );
    lastPipelineRequest = request;
    return executor.execute(request);
  }

  /// 提取页面可观察的关键结果（月将 + 三传），作为执行证据的 keyResult。
  ///
  /// 月将与三传由本次排盘决定（executor/calculator 计算产出），
  /// 且直接显示在大六壬盘面页面上，因此能代表「这次执行真的发生了」。
  Object? _keyResultOf(DaliurenDivinationRecordContract record) {
    return {
      'yueJiang': record.yueJiangJson,
      'sanChuan': record.sanChuanJson,
    };
  }

  Future<void> _matchKeTi() async {
    if (_getKetiDataUseCase == null ||
        _currentDivination == null ||
        _matchYuDingKetiUseCase == null) {
      logger.d('🟡 [ViewModel] _matchKeTi: UseCase or divination is null');
      _matchedLessons = [];
      _matchedKeTiNames = [];
      _matchedKetiResults = [];
      return;
    }

    if (!_getKetiDataUseCase.isLoaded) {
      logger.d('🟡 [ViewModel] _matchKeTi: GetKetiDataUseCase not loaded yet');
      _matchedLessons = [];
      _matchedKeTiNames = [];
      _matchedKetiResults = [];
      return;
    }

    try {
      final patternNames = await _matchYuDingKetiUseCase.call(
        MatchYuDingKetiParams(_currentDivination!),
      );
      logger.d('🔵 [ViewModel] _matchKeTi: Pattern names from UseCase: $patternNames');
      _matchedKeTiNames = patternNames;
      final results = _getKetiDataUseCase.findByNames(patternNames);
      _matchedKetiResults = results;
      _matchedLessons = [];
      final seen = <String>{};
      for (final r in results) {
        if (!seen.contains(r.lesson.name)) {
          seen.add(r.lesson.name);
          _matchedLessons.add(r.lesson);
        }
      }
      logger.d('🟢 [ViewModel] _matchKeTi: Final matched lessons: ${_matchedLessons.map((l) => l.name).toList()}');
      logger.d('🟢 [ViewModel] _matchKeTi: Sub-lessons matched: ${results.where((r) => r.matchedSubLesson != null).map((r) => r.matchedSubLesson!.name).toList()}');
      // Do NOT call notifyListeners here – let the caller (_calculateDivination) do it via setSuccess()
    } catch (e) {
      logger.e('🔴 [ViewModel] Error in _matchKeTi: $e');
      _matchedLessons = [];
      _matchedKeTiNames = [];
      _matchedKetiResults = [];
    }
  }

  Future<void> _calculateShenSha() async {
    if (_calculateShenShaUseCase == null) {
      logger.d('🟡 [ViewModel] ShenSha UseCase is null, skipping');
      return;
    }
    if (_yearJiaZi == null || _monthJiaZi == null || _dayJiaZi == null || _timeJiaZi == null) {
      logger.d('🟡 [ViewModel] JiaZi values not ready for ShenSha');
      return;
    }
    try {
      logger.d('🔵 [ViewModel] Calculating ShenSha...');
      final params = CalculateShenShaParams(
        yearJiaZi: _yearJiaZi!,
        monthJiaZi: _monthJiaZi!,
        dayJiaZi: _dayJiaZi!,
        hourJiaZi: _timeJiaZi!,
      );
      _shenShaResults = await _calculateShenShaUseCase.call(params);
      final totalCount = _shenShaResults?.values.fold<int>(0, (sum, list) => sum + list.length) ?? 0;
      logger.d('🟢 [ViewModel] ShenSha calculated: $totalCount results');
    } catch (e) {
      logger.e('🔴 [ViewModel] Error calculating shen sha: $e');
    }
  }
}
