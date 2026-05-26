// lib/di/school_initialization.dart

import 'package:daliuren/data/schools/yuding_school.dart';
import 'package:daliuren/domain/interfaces/school_registry.dart';

/// 流派初始化
/// 在应用启动时调用，注册所有可用的流派
class SchoolInitialization {
  /// 初始化所有流派
  static Future<void> initialize() async {
    // 注册御定大六壬
    final yudingSchool = YudingSchool();
    await yudingSchool.loadData();
    SchoolRegistry.register(yudingSchool);
    
    // 未来添加新流派时，在这里注册
    // final bifaSchool = BifaSchool();
    // await bifaSchool.loadData();
    // SchoolRegistry.register(bifaSchool);
    
    print('已注册 ${SchoolRegistry.count} 个大六壬流派');
  }
  
  /// 获取流派统计信息
  static Future<Map<String, dynamic>> getStats() async {
    final stats = <String, dynamic>{};
    
    for (final school in SchoolRegistry.all) {
      stats[school.id] = {
        'name': school.displayName,
        'entryCount': await school.entryCount,
        'isLoaded': school.isLoaded,
      };
    }
    
    return stats;
  }
}
