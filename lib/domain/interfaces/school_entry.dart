// lib/domain/interfaces/school_entry.dart

/// 大六壬流派条目抽象接口
/// 所有流派的条目都应实现此接口
abstract class SchoolEntry {
  /// 条目标题 (如: "甲子日第一局干上子")
  String get title;
  
  /// 日干支 (如: "甲子")
  String get dayJiaZi;
  
  /// 局名/地支 (如: "寅")
  String get juName;
  
  /// 局数
  int get juNumber;
  
  /// 课体名称列表 (如: ["伏吟", "元胎"])
  List<String> get keTiNames;
  
  /// 课义
  String get meaning;
  
  /// 解释
  String get explanation;
  
  /// 断语
  String get prediction;
  
  /// 杂占 (类别 -> 解释)
  Map<String, String> get details;
  
  /// 经典引用 (书名 -> 内容)
  Map<String, String> get bookReferences;
  
  /// 所属流派ID
  String get schoolId;
}
