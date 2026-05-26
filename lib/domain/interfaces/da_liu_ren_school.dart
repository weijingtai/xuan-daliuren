// lib/domain/interfaces/da_liu_ren_school.dart

import 'package:daliuren/domain/interfaces/school_entry.dart';

/// 大六壬流派抽象接口
/// 所有流派都应实现此接口
abstract class DaLiuRenSchool {
  /// 流派唯一标识符 (如: "yuding", "bifa", "kejing")
  String get id;
  
  /// 流派显示名称 (如: "御定大六壬", "毕法赋")
  String get displayName;
  
  /// 流派简短描述
  String get description;
  
  /// 流派代表书籍
  String get representativeBook;
  
  /// 流派特点标签 (如: ["官方", "规范", "完整"])
  List<String> get tags;
  
  /// 流派年代 (如: "清代", "宋代")
  String get era;
  
  /// 加载流派数据
  Future<void> loadData();
  
  /// 数据是否已加载
  bool get isLoaded;
  
  /// 根据日干支和局名匹配条目
  Future<List<SchoolEntry>> matchEntries(String dayJiaZi, String juName);
  
  /// 根据日干支获取所有条目
  Future<List<SchoolEntry>> getEntriesByDay(String dayJiaZi);
  
  /// 获取所有条目数量
  Future<int> get entryCount;
  
  /// 获取该流派支持的所有日干支
  Future<List<String>> get supportedDays;
}
