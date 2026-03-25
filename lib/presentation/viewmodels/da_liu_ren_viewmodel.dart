import 'package:common/enums.dart';
import 'package:common/module.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';
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

  DaLiuRenViewModel({
    required CalculateDivinationUseCase calculateDivinationUseCase,
    required LoadDivinationDataUseCase loadDivinationDataUseCase,
    CalculateShenShaUseCase? calculateShenShaUseCase,
  })  : _calculateDivinationUseCase = calculateDivinationUseCase,
        _loadDivinationDataUseCase = loadDivinationDataUseCase,
        _calculateShenShaUseCase = calculateShenShaUseCase;

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

  // Initialize data
  Future<void> initializeData() async {
    if (_isDataLoaded) return;

    logger.d('🔵 [ViewModel] initializeData() called');
    setLoading();
    try {
      logger.d('🔵 [ViewModel] Calling LoadDivinationDataUseCase...');
      await _loadDivinationDataUseCase.call(NoParams());
      _isDataLoaded = true;
      logger.d('🔵 [ViewModel] Data loaded successfully');
      setSuccess();
    } catch (e) {
      logger.e('🔴 [ViewModel] Error loading data: $e');
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

    logger.d(
        '🔵 [ViewModel] _calculateDivination() called for ${_selectedDateTime}');
    setLoading();
    try {
      final params = DateTimeParams(_selectedDateTime, question: _question);
      logger.d('🔵 [ViewModel] Calling CalculateDivinationUseCase...');
      final divination = await _calculateDivinationUseCase.call(params);
      _currentDivination = divination;
      logger.d(
          '🔵 [ViewModel] Calculation successful: ${divination.dayJiaZi.name}日');
      _updateDivinationProperties();
      await _calculateShenSha();
      setSuccess();
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
      _shenShaResults = await _calculateShenShaUseCase!.call(params);
      final totalCount = _shenShaResults?.values.fold<int>(0, (sum, list) => sum + list.length) ?? 0;
      logger.d('🟢 [ViewModel] ShenSha calculated: $totalCount results');
    } catch (e) {
      logger.e('🔴 [ViewModel] Error calculating shen sha: $e');
    }
  }
}
