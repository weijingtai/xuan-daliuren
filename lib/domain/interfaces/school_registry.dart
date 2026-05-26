// lib/domain/interfaces/school_registry.dart

import 'package:daliuren/domain/interfaces/da_liu_ren_school.dart';

/// 流派注册表
/// 管理所有已注册的大六壬流派
class SchoolRegistry {
  static final Map<String, DaLiuRenSchool> _schools = {};
  static String? _defaultSchoolId;
  
  /// 注册一个流派
  static void register(DaLiuRenSchool school) {
    _schools[school.id] = school;
    // 如果是第一个注册的流派，设为默认
    _defaultSchoolId ??= school.id;
  }
  
  /// 注销一个流派
  static void unregister(String id) {
    _schools.remove(id);
    if (_defaultSchoolId == id) {
      _defaultSchoolId = _schools.isNotEmpty ? _schools.keys.first : null;
    }
  }
  
  /// 获取指定流派
  static DaLiuRenSchool? get(String id) => _schools[id];
  
  /// 获取所有已注册流派
  static List<DaLiuRenSchool> get all => _schools.values.toList();
  
  /// 获取所有流派ID
  static List<String> get allIds => _schools.keys.toList();
  
  /// 获取默认流派
  static DaLiuRenSchool? get defaultSchool => 
      _defaultSchoolId != null ? _schools[_defaultSchoolId] : null;
  
  /// 设置默认流派
  static bool setDefault(String id) {
    if (_schools.containsKey(id)) {
      _defaultSchoolId = id;
      return true;
    }
    return false;
  }
  
  /// 检查流派是否已注册
  static bool has(String id) => _schools.containsKey(id);
  
  /// 已注册流派数量
  static int get count => _schools.length;
  
  /// 清空所有注册（主要用于测试）
  static void clear() {
    _schools.clear();
    _defaultSchoolId = null;
  }
}
