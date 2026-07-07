/// 旺衰显示配置
/// 控制宫格内各类符号的旺衰 hint 是否显示
class WangShuaiConfig {
  /// 天干旺衰 hint
  final bool showTianGan;

  /// 天盘支旺衰 hint
  final bool showSkyDiZhi;

  /// 天将旺衰 hint
  final bool showTianJiang;

  const WangShuaiConfig({
    this.showTianGan = false,
    this.showSkyDiZhi = false,
    this.showTianJiang = false,
  });

  /// 全部显示
  bool get showAll => showTianGan && showSkyDiZhi && showTianJiang;

  /// 全部隐藏
  bool get showNone => !showTianGan && !showSkyDiZhi && !showTianJiang;

  /// 是否有任何旺衰 hint 显示
  bool get hasAny => showTianGan || showSkyDiZhi || showTianJiang;

  WangShuaiConfig copyWith({
    bool? showTianGan,
    bool? showSkyDiZhi,
    bool? showTianJiang,
  }) {
    return WangShuaiConfig(
      showTianGan: showTianGan ?? this.showTianGan,
      showSkyDiZhi: showSkyDiZhi ?? this.showSkyDiZhi,
      showTianJiang: showTianJiang ?? this.showTianJiang,
    );
  }

  /// 全选/全不选
  WangShuaiConfig toggleAll() {
    if (showAll) {
      return const WangShuaiConfig();
    }
    return const WangShuaiConfig(
      showTianGan: true,
      showSkyDiZhi: true,
      showTianJiang: true,
    );
  }
}

/// 每个符号的旺衰结果
class WangShuaiHint {
  /// 月令旺衰 label（如 "旺"、"相"、"休"、"囚"、"死"）
  final String? monthLabel;

  /// 宫内十二长生 label（如 "帝旺"、"长生"、"墓"、"绝"）
  final String? gongLabel;

  /// 月令旺衰颜色
  final String? monthColorHex;

  /// 宫内旺衰颜色
  final String? gongColorHex;

  const WangShuaiHint({
    this.monthLabel,
    this.gongLabel,
    this.monthColorHex,
    this.gongColorHex,
  });

  bool get hasData => monthLabel != null || gongLabel != null;
}

/// 宫位所有符号的旺衰结果
class GongWangShuaiResult {
  final WangShuaiHint? skyDiZhiHint;  // 天盘支
  final WangShuaiHint? tianGanHint;   // 天干
  final WangShuaiHint? tianJiangHint; // 天将

  const GongWangShuaiResult({
    this.skyDiZhiHint,
    this.tianGanHint,
    this.tianJiangHint,
  });
}
