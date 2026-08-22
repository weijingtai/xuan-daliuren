import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';

/// Assets-backed implementation of DaLiuRenOfficialDataRepository.
/// Reads JSON files from the example app's assets/da_liu_ren/ directory.
class AssetsDaLiuRenOfficialDataRepository
    implements DaLiuRenOfficialDataRepository {
  @override
  Future<dynamic> get(String id) async {
    switch (id) {
      case 'yuding':
        final raw = await rootBundle.loadString(
          'assets/da_liu_ren/御定大六壬.json',
        );
        return json.decode(raw) as List<dynamic>;
      case 'jumapper':
        final raw = await rootBundle.loadString(
          'assets/da_liu_ren/ju_mapper.json',
        );
        return json.decode(raw) as Map<String, dynamic>;
      case 'yangpan':
        final raw = await rootBundle.loadString(
          'assets/da_liu_ren/甲午庚牛羊_阳.json',
        );
        final list = json.decode(raw) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
      case 'yinpan':
        final raw = await rootBundle.loadString(
          'assets/da_liu_ren/甲午庚牛羊_阴.json',
        );
        final list = json.decode(raw) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
      default:
        throw ArgumentError('Unknown id: $id');
    }
  }

  @override
  Future<List<dynamic>> query([Map<String, Object?>? criteria]) async {
    final type = criteria?['type'] as String? ?? 'yuding';
    return get(type) as Future<List<dynamic>>;
  }
}

/// Assets-backed implementation of DaLiuRenKetiRepository.
class AssetsDaLiuRenKetiRepository implements DaLiuRenKetiRepository {
  @override
  Future<List<dynamic>> query([Map<String, Object?>? criteria]) async {
    final raw = await rootBundle.loadString(
      'assets/da_liu_ren/keti_data.json',
    );
    return json.decode(raw) as List<dynamic>;
  }
}

/// Stub implementation of DaLiuRenShenShaDataRepository.
/// Returns empty lists; the example app does not include shen_sha assets.
class AssetsDaLiuRenShenShaDataRepository
    implements DaLiuRenShenShaDataRepository {
  @override
  Future<List<dynamic>> loadGanShenShaRaw() async => [];
  @override
  Future<List<dynamic>> loadYearShenShaRaw() async => [];
  @override
  Future<List<dynamic>> loadMonthShenShaRaw() async => [];
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

/// Stub implementation of DaLiuRenSchoolDataRepository.
/// Returns empty list; the example app does not include school data assets.
class AssetsDaLiuRenSchoolDataRepository
    implements DaLiuRenSchoolDataRepository {
  @override
  Future<List<SchoolEntryContract>> query([Map<String, Object?>? criteria]) async => [];
}
