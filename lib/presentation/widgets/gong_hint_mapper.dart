import 'dart:ui';

import 'package:metaphysics_chart_ui/metaphysics_chart_ui.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:daliuren/model/da_liu_ren_gong.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';

/// 将大六壬宫格数据映射为 SymbolAnnotation 所需的 VitalityValue 列表。
///
/// 每个宫位可展示的 hint 类型：
/// - 天将（贵人、腾蛇、朱雀…）
/// - 神煞（天德、月德、驿马…）
/// - 五行属性（通过天干推导）
class GongHintMapper {
  /// 为指定宫位生成 hint 列表。
  ///
  /// [diZhi] 宫位地支
  /// [gong] 该宫位的宫格数据
  /// [shenShaResults] 全盘神煞计算结果（按地支索引）
  static List<VitalityValue> map({
    required DiZhi diZhi,
    required DaLiuRenGong gong,
    Map<DiZhi, List<ShenShaResult>>? shenShaResults,
  }) {
    final values = <VitalityValue>[];

    // 天将 hint
    values.add(VitalityValue(
      text: gong.guiRen.name,
      level: GongInkLevel.mark,
    ));

    // 神煞 hints（取该宫位的神煞，最多展示 3 个）
    if (shenShaResults != null) {
      final results = shenShaResults[diZhi];
      if (results != null) {
        for (final r in results.take(3)) {
          values.add(VitalityValue(
            text: r.shenSha.name,
            level: _jiXiongToLevel(r.shenSha.jiXiong),
            semanticColor: _jiXiongToColor(r.shenSha.jiXiong),
          ));
        }
      }
    }

    return values;
  }

  static GongInkLevel _jiXiongToLevel(JiXiongEnum jiXiong) {
    if (jiXiong.isJi()) return GongInkLevel.focalAccent;
    if (jiXiong.isXiong()) return GongInkLevel.mark;
    return GongInkLevel.base;
  }

  static Color? _jiXiongToColor(JiXiongEnum jiXiong) {
    if (jiXiong.isJi()) return const Color(0xFF2E7D32);
    if (jiXiong.isXiong()) return const Color(0xFFC62828);
    return null;
  }
}
