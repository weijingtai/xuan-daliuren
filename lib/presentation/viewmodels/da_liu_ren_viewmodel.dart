import 'package:common/enums.dart';
import 'package:common/module.dart';
import 'package:daliuren/domain/entities/daliuren_lesson.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';
import 'package:daliuren/domain/services/keti_data_service.dart';
import 'package:daliuren/domain/services/yuding_keti_match_service.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:daliuren/domain/usecases/calculate_divination_usecase.dart';
import 'package:daliuren/domain/usecases/calculate_shen_sha_usecase.dart';
import 'package:daliuren/domain/usecases/load_divination_data_usecase.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';
import 'package:daliuren/presentation/viewmodels/base_viewmodel.dart';

class DaLiuRenViewModel extends BaseViewModel {
  final CalculateDivinationUseCase _calculateDivinationUseCase;
  final LoadDivinationDataUseCase _loadDivinationDataUseCase;
  final CalculateShenShaUseCase? _calculateShenShaUseCase;
  final KetiDataService? _ketiDataService;
  final YuDingKetiMatchService? _yuDingKetiMatchService;

  DaLiuRenViewModel({
    required CalculateDivinationUseCase calculateDivinationUseCase,
    required LoadDivinationDataUseCase loadDivinationDataUseCase,
    CalculateShenShaUseCase? calculateShenShaUseCase,
    KetiDataService? ketiDataService,
    YuDingKetiMatchService? yuDingKetiMatchService,
  })  : _calculateDivinationUseCase = calculateDivinationUseCase,
        _loadDivinationDataUseCase = loadDivinationDataUseCase,
        _calculateShenShaUseCase = calculateShenShaUseCase,
        _ketiDataService = ketiDataService,
        _yuDingKetiMatchService = yuDingKetiMatchService;

  // Data properties
  DateTime _selectedDateTime = DateTime.now();
  String? _question;
  DaLiuRenKePan? _currentDivination;

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
    if (_ketiDataService == null ||
        _currentDivination == null ||
        _yuDingKetiMatchService == null) {
      print('🟡 [ViewModel] _matchKeTi: Service or divination is null');
      _matchedLessons = [];
      _matchedKeTiNames = [];
      _matchedKetiResults = [];
      return;
    }

    if (!_ketiDataService.isLoaded) {
      print('🟡 [ViewModel] _matchKeTi: KetiDataService not loaded yet');
      _matchedLessons = [];
      _matchedKeTiNames = [];
      _matchedKetiResults = [];
      return;
    }

    try {
      final patternNames =
          await _yuDingKetiMatchService.getKeTiNames(_currentDivination!);
      print('🔵 [ViewModel] _matchKeTi: Pattern names from Service: $patternNames');
      _matchedKeTiNames = patternNames;
      final results = _ketiDataService.findByNames(patternNames);
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
