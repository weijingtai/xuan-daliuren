import 'package:metaphysics_core/enums.dart';
import 'package:xuan_logger/xuan_logger.dart';
import 'package:daliuren/domain/entities/daliuren_lesson.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';
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

class DaLiuRenViewModel extends BaseViewModel {
  final CalculateDivinationUseCase _calculateDivinationUseCase;
  final LoadDivinationDataUseCase _loadDivinationDataUseCase;
  final CalculateShenShaUseCase? _calculateShenShaUseCase;
  final GetKetiDataUseCase? _getKetiDataUseCase;
  final MatchYuDingKetiUseCase? _matchYuDingKetiUseCase;
  final LoadYuDingDataUseCase? _loadYuDingDataUseCase;

  DaLiuRenViewModel({
    required CalculateDivinationUseCase calculateDivinationUseCase,
    required LoadDivinationDataUseCase loadDivinationDataUseCase,
    CalculateShenShaUseCase? calculateShenShaUseCase,
    GetKetiDataUseCase? getKetiDataUseCase,
    MatchYuDingKetiUseCase? matchYuDingKetiUseCase,
    LoadYuDingDataUseCase? loadYuDingDataUseCase,
  })  : _calculateDivinationUseCase = calculateDivinationUseCase,
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

    print('🔵 [ViewModel] initializeData() called');
    setLoading();
    try {
      print('🔵 [ViewModel] Calling LoadDivinationDataUseCase...');
      await _loadDivinationDataUseCase.call(NoParams());
      _isDataLoaded = true;
      print('🔵 [ViewModel] Data loaded successfully');
      setSuccess();
    } catch (e) {
      print('🔴 [ViewModel] Error loading data: $e');
      setError(e is DivinationFailure ? e.message : e.toString());
    }
  }

  /// 加载御定大六壬数据（缓存结果）
  Future<List<dynamic>> loadYuDingData() async {
    if (_yudingData != null) return _yudingData!;
    if (_loadYuDingDataUseCase == null) {
      throw DivinationFailure('LoadYuDingDataUseCase not configured');
    }
    _yudingData = await _loadYuDingDataUseCase!.call(NoParams());
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

    print('🔵 [ViewModel] _calculateDivination() called for $_selectedDateTime');
    setLoading();
    try {
      final params = DateTimeParams(_selectedDateTime, question: _question);
      print('🔵 [ViewModel] Calling CalculateDivinationUseCase...');
      final divination = await _calculateDivinationUseCase.call(params);
      _currentDivination = divination;
      print('🔵 [ViewModel] Calculation successful: ${divination.dayJiaZi.name}日');
      _updateDivinationProperties();
      // Run async enrichment THEN do a single final notifyListeners
      await _matchKeTi();
      await _calculateShenSha();
      setSuccess(); // This calls notifyListeners() with all data already populated
    } catch (e) {
      print('🔴 [ViewModel] Calculation error: $e');
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
      setSuccess();
    } catch (e) {
      setError(e is DivinationFailure ? e.message : e.toString());
    }
  }

  Future<void> _matchKeTi() async {
    if (_getKetiDataUseCase == null ||
        _currentDivination == null ||
        _matchYuDingKetiUseCase == null) {
      print('🟡 [ViewModel] _matchKeTi: UseCase or divination is null');
      _matchedLessons = [];
      _matchedKeTiNames = [];
      _matchedKetiResults = [];
      return;
    }

    if (!_getKetiDataUseCase.isLoaded) {
      print('🟡 [ViewModel] _matchKeTi: GetKetiDataUseCase not loaded yet');
      _matchedLessons = [];
      _matchedKeTiNames = [];
      _matchedKetiResults = [];
      return;
    }

    try {
      final patternNames = await _matchYuDingKetiUseCase.call(
        MatchYuDingKetiParams(_currentDivination!),
      );
      print('🔵 [ViewModel] _matchKeTi: Pattern names from UseCase: $patternNames');
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
      print('🟢 [ViewModel] _matchKeTi: Final matched lessons: ${_matchedLessons.map((l) => l.name).toList()}');
      print('🟢 [ViewModel] _matchKeTi: Sub-lessons matched: ${results.where((r) => r.matchedSubLesson != null).map((r) => r.matchedSubLesson!.name).toList()}');
      // Do NOT call notifyListeners here – let the caller (_calculateDivination) do it via setSuccess()
    } catch (e) {
      print('🔴 [ViewModel] Error in _matchKeTi: $e');
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
