import 'package:metaphysics_core/enums.dart';
import 'package:xuan_logger/xuan_logger.dart';
import 'package:theme/const_resources_mapper.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/keti_data_service.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';
import 'package:daliuren/model/da_liu_ren_pan_model.dart';

class DaLiuRenRepositoryImpl implements DaLiuRenRepository {
  final DaLiuRenCalculationService calculationService;
  final KetiDataService ketiDataService;
  final DaLiuRenOfficialDataRepository officialData;

  DaLiuRenRepositoryImpl({
    required this.calculationService,
    required this.ketiDataService,
    required this.officialData,
  });

  List<dynamic>? _yuDingData;
  Map<String, dynamic>? _juMapperData;
  List<DaLiuRenPanModel>? _yangPanData;
  List<DaLiuRenPanModel>? _yinPanData;

  @override
  Future<void> loadDivinationData() async {
    logger.d('🟡 [Repository] loadDivinationData() called');
    try {
      await Future.wait([
        _loadYuDingData(),
        _loadJuMapperData(),
        _loadPanData(YinYang.YANG),
        _loadPanData(YinYang.YIN),
        ketiDataService.loadData(),
      ]);
      logger.d('🟡 [Repository] All divination data loaded successfully');
    } catch (e) {
      logger.e('🔴 [Repository] Failed to load some divination data: $e');
      // 允许部分数据加载失败，应用仍可继续运行
    }
  }

  Future<void> _loadYuDingData() async {
    _yuDingData ??= await officialData.loadYuDingData();
  }

  Future<void> _loadJuMapperData() async {
    _juMapperData ??= await officialData.loadJuMapperData();
  }

  Future<void> _loadPanData(YinYang yinYang) async {
    try {
      final rawList = yinYang.isYang
          ? await officialData.loadYangPanData()
          : await officialData.loadYinPanData();
      final panList =
          rawList.map((m) => DaLiuRenPanModel.fromJson(m)).toList();
      if (yinYang.isYang) {
        _yangPanData = panList;
      } else {
        _yinPanData = panList;
      }
    } catch (e) {
      if (yinYang.isYang) {
        _yangPanData = <DaLiuRenPanModel>[];
      } else {
        _yinPanData = <DaLiuRenPanModel>[];
      }
    }
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
    await loadDivinationData();
    DaLiuRenPanModel panModel;
    if (timeZhi != null) {
      panModel = await _getPanByTimeZhi(dayJiaZi, timeZhi, yinYangDun);
    } else if (juNumber != null) {
      panModel = await _getPanByJuNumber(dayJiaZi, yinYangDun, juNumber);
    } else {
      throw const DivinationFailure('Either timeZhi or juNumber must be provided');
    }

    final timeJiaZi = timeZhi != null
        ? JiaZi.getFromGanZhiEnum(TianGan.JIA, timeZhi)
        : JiaZi.getFromGanZhiEnum(TianGan.JIA, panModel.shiChen);
    final eightChar =
        "${yearJiaZi.ganZhiStr} ${monthJiaZi.ganZhiStr} ${dayJiaZi.ganZhiStr} ${timeJiaZi.ganZhiStr}";

    return DaLiuRenKePan(
      panDateTime: DateTime.now(),
      eightChatStr: eightChar,
      monthGeneral: monthGeneral,
    );
  }

  @override
  Future<DaLiuRenKePan> calculateDivination(DateTime dateTime,
      {String? question}) async {
    logger.d('🟡 [Repository] calculateDivination() called for $dateTime');
    try {
      // Ensure data is loaded (for future use of YuDing data, etc.)
      await loadDivinationData();

      logger.d('🟡 [Repository] Calling CalculationService.calculate()...');
      // Use CalculationService to perform real calculation
      final kePan = calculationService.calculate(dateTime, question: question);
      logger
          .d('🟡 [Repository] CalculationService returned KePan successfully');

      return kePan;
    } catch (e) {
      logger.e('🔴 [Repository] Error in calculateDivination: $e');
      rethrow; // 不再吞掉异常,让上层处理
    }
  }

  Future<DaLiuRenPanModel> _getPanByJuNumber(
      JiaZi dayJiaZi, YinYang yinYangDun, int number) async {
    final resultList = yinYangDun.isYang ? _yangPanData! : _yinPanData!;
    final juNumberName = ConstResourcesMapper.chineseNumberMapper[number]!;
    return resultList.firstWhere(
        (pan) => pan.dayJiaZi == dayJiaZi && pan.juNumberName == juNumberName);
  }

  Future<DaLiuRenPanModel> _getPanByTimeZhi(
      JiaZi dayJiaZi, DiZhi shiZhi, YinYang yinYangDun) async {
    final resultList = yinYangDun.isYang ? _yangPanData! : _yinPanData!;
    return resultList
        .firstWhere((pan) => pan.dayJiaZi == dayJiaZi && pan.shiChen == shiZhi);
  }

  Future<int> _checkPanJu(
      JiaZi dayJiaZi, JiaZi timeJiaZi, YinYang yinYangDun) async {
    final mapper = _getJuMapper();
    return mapper[dayJiaZi.name]![timeJiaZi.diZhi.name]![
        yinYangDun.isYang ? "yang" : "yin"]!;
  }

  Map<String, Map<String, Map<String, int>>> _getJuMapper() {
    final decodedJson = _juMapperData as Map<String, dynamic>;
    return decodedJson.map((key, value) {
      return MapEntry(
        key,
        (value as Map<String, dynamic>).map((subKey, subValue) {
          return MapEntry(
            subKey,
            (subValue as Map<String, dynamic>).map((subSubKey, subSubValue) {
              return MapEntry(subSubKey, subSubValue as int);
            }),
          );
        }),
      );
    });
  }

  @override
  Future<List<dynamic>> getYuDingData() async {
    await _loadYuDingData();
    return _yuDingData!;
  }

  @override
  Future<Map<String, dynamic>> getJuMapperData() async {
    await _loadJuMapperData();
    return _juMapperData!;
  }
}
