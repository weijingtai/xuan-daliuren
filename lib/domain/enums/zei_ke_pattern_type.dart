import 'package:json_annotation/json_annotation.dart';

/// 贼克课型分类（高层模式分类，区别于 model/zei_key_type.dart 中的 EachClassZeiKeType 低层分类）
enum ZeiKePatternType {
  @JsonValue("始入课")
  SHI_RU_KE("始入课"), // 有且仅有一组下贼上
  @JsonValue("元首课")
  YUAN_SHOU_KE("元首课"), // 只有一组上克下
  @JsonValue("重申课")
  CHONG_SHEN_KE("重申课"); // 有多组克，但只有一组贼

  const ZeiKePatternType(this.displayName);
  final String displayName;
}
