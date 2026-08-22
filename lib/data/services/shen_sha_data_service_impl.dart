import 'package:repository_contract_kernel/repository_contract_kernel.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';

/// 神煞数据加载服务实现类
class ShenShaDataServiceImpl implements ShenShaDataService {
  final DaLiuRenShenShaDataRepository shenShaData;
  ShenShaDataServiceImpl({required this.shenShaData});

  List<TianGanShenShaEntity>? _tianGanShenShaCache;
  List<YearShenShaEntity>? _yearShenShaCache;
  List<MonthShenShaEntity>? _monthShenShaCache;
  List<DiZhiShenShaEntity>? _diZhiShenShaCache;
  List<JiShenShaEntity>? _jiShenShaCache;
  List<XunShenShaEntity>? _xunShenShaCache;
  List<TianGanShenShaEntity>? _dayGanShenShaCache;
  List<TianGanShenShaEntity>? _yearGanShenShaCache;
  List<TianGanShenShaEntity>? _monthGanShenShaCache;

  RequestContext get _ctx => RequestContext(scopeUid: 'local-anonymous');

  Future<List<dynamic>> _loadRaw(String id) async {
    final res = await shenShaData.get(id, _ctx);
    final val = res.orElse(null);
    if (val is List) return val;
    return const [];
  }

  @override
  Future<List<TianGanShenShaEntity>> loadTianGanShenSha() async {
    if (_tianGanShenShaCache != null) {
      return _tianGanShenShaCache!;
    }

    try {
      final List<dynamic> jsonList = await _loadRaw("gan");

      // 6_shensha_gan.json 中混合了 干煞、日煞、支煞 类型，只加载 干煞
      _tianGanShenShaCache = jsonList
          .where((j) => j['type'] == '干煞')
          .map((json) => TianGanShenShaEntity.fromJson(json))
          .toList();

      // 同时缓存 日煞 类型
      _dayGanShenShaCache = jsonList
          .where((j) => j['type'] == '日煞')
          .map((json) => TianGanShenShaEntity.fromJson(json))
          .toList();

      return _tianGanShenShaCache!;
    } catch (e) {
      throw Exception('Failed to load 天干神煞 data: $e');
    }
  }

  @override
  Future<List<YearShenShaEntity>> loadYearShenSha() async {
    if (_yearShenShaCache != null) {
      return _yearShenShaCache!;
    }

    try {
      final List<dynamic> jsonList = await _loadRaw("year");

      _yearShenShaCache =
          jsonList.map((json) => YearShenShaEntity.fromJson(json)).toList();

      return _yearShenShaCache!;
    } catch (e) {
      throw Exception('Failed to load 年支神煞 data: $e');
    }
  }

  @override
  Future<List<MonthShenShaEntity>> loadMonthShenSha() async {
    if (_monthShenShaCache != null) {
      return _monthShenShaCache!;
    }

    try {
      final List<dynamic> jsonList = await _loadRaw("month");

      _monthShenShaCache =
          jsonList.map((json) => MonthShenShaEntity.fromJson(json)).toList();

      return _monthShenShaCache!;
    } catch (e) {
      throw Exception('Failed to load 月支神煞 data: $e');
    }
  }

  @override
  Future<List<DiZhiShenShaEntity>> loadDiZhiShenSha() async {
    if (_diZhiShenShaCache != null) {
      return _diZhiShenShaCache!;
    }

    try {
      final List<dynamic> jsonList = await _loadRaw("zhi");

      _diZhiShenShaCache =
          jsonList.map((json) => DiZhiShenShaEntity.fromJson(json)).toList();

      return _diZhiShenShaCache!;
    } catch (e) {
      throw Exception('Failed to load 地支神煞 data: $e');
    }
  }

  @override
  Future<List<JiShenShaEntity>> loadJiShenSha() async {
    if (_jiShenShaCache != null) {
      return _jiShenShaCache!;
    }

    try {
      final List<dynamic> jsonList = await _loadRaw("ji");

      _jiShenShaCache =
          jsonList.map((json) => JiShenShaEntity.fromJson(json)).toList();

      return _jiShenShaCache!;
    } catch (e) {
      throw Exception('Failed to load 季煞 data: $e');
    }
  }

  @override
  Future<List<XunShenShaEntity>> loadXunShenSha() async {
    if (_xunShenShaCache != null) {
      return _xunShenShaCache!;
    }

    try {
      final List<dynamic> jsonList = await _loadRaw("xun");

      _xunShenShaCache =
          jsonList.map((json) => XunShenShaEntity.fromJson(json)).toList();

      return _xunShenShaCache!;
    } catch (e) {
      throw Exception('Failed to load 旬煞 data: $e');
    }
  }

  /// 加载日煞（日干专属神煞，来自 6_shensha_gan.json 中 type='日煞' 的条目）
  @override
  Future<List<TianGanShenShaEntity>> loadDayGanShenSha() async {
    if (_dayGanShenShaCache != null) return _dayGanShenShaCache!;
    // 触发 loadTianGanShenSha 会同时缓存 日煞
    await loadTianGanShenSha();
    return _dayGanShenShaCache ?? [];
  }

  /// 加载年干神煞（6_shensha_year_gan.json）
  @override
  Future<List<TianGanShenShaEntity>> loadYearGanShenSha() async {
    if (_yearGanShenShaCache != null) return _yearGanShenShaCache!;
    try {
      final List<dynamic> jsonList = await _loadRaw("year_gan");
      _yearGanShenShaCache =
          jsonList.map((j) => TianGanShenShaEntity.fromJson(j)).toList();
      return _yearGanShenShaCache!;
    } catch (e) {
      _yearGanShenShaCache = [];
      return _yearGanShenShaCache!;
    }
  }

  /// 加载月干神煞（6_shensha_month_gan.json）
  @override
  Future<List<TianGanShenShaEntity>> loadMonthGanShenSha() async {
    if (_monthGanShenShaCache != null) return _monthGanShenShaCache!;
    try {
      final List<dynamic> jsonList = await _loadRaw("month_gan");
      _monthGanShenShaCache =
          jsonList.map((j) => TianGanShenShaEntity.fromJson(j)).toList();
      return _monthGanShenShaCache!;
    } catch (e) {
      _monthGanShenShaCache = [];
      return _monthGanShenShaCache!;
    }
  }

  /// 加载月支干合神煞（6_shensha_month_zhi_gan.json，type='月煞'）
  Future<List<MonthShenShaEntity>> loadMonthZhiGanShenSha() async {
    try {
      final List<dynamic> jsonList = await _loadRaw("month_zhi_gan");
      return jsonList
          .map((j) => MonthShenShaEntity.fromJson(j))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ShenShaEntity>> loadAllShenSha() async {
    try {
      final tianGanList = await loadTianGanShenSha();
      final yearList = await loadYearShenSha();
      final monthList = await loadMonthShenSha();
      final diZhiList = await loadDiZhiShenSha();
      final jiList = await loadJiShenSha();
      final xunList = await loadXunShenSha();

      return [
        ...tianGanList,
        ...yearList,
        ...monthList,
        ...diZhiList,
        ...jiList,
        ...xunList,
      ];
    } catch (e) {
      throw Exception('Failed to load all 神煞 data: $e');
    }
  }
}
