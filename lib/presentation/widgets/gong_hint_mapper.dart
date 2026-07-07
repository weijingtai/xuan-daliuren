import 'package:metaphysics_core/enums.dart';
import 'package:daliuren/model/da_liu_ren_gong.dart';
import 'package:daliuren/model/enum_gui_ren.dart';
import 'package:daliuren/presentation/models/wang_shuai_config.dart';

/// 为每个宫位计算各符号的旺衰 hint。
///
/// 返回 [GongWangShuaiResult]，其中天盘支、天干、天将各自独立。
class GongHintMapper {
  static const _strongColor = '0xFF2E7D32'; // 绿 - 强
  static const _weakColor = '0xFFC62828';   // 红 - 弱
  static const _neutralColor = '0xFF888780'; // 灰 - 中

  /// 为指定宫位生成各符号独立的旺衰 hint。
  static GongWangShuaiResult map({
    required DiZhi diZhi,
    required DaLiuRenGong gong,
    required JiaZi monthJiaZi,
    WangShuaiConfig wangShuaiConfig = const WangShuaiConfig(),
  }) {
    final monthZhi = monthJiaZi.diZhi;

    return GongWangShuaiResult(
      skyDiZhiHint: wangShuaiConfig.showSkyDiZhi
          ? _calcDiZhiHint(gong.skyPanDiZhi, diZhi, monthZhi)
          : null,
      tianGanHint: wangShuaiConfig.showTianGan && gong.tianGan != null
          ? _calcTianGanHint(gong.tianGan!, diZhi, monthZhi)
          : null,
      tianJiangHint: wangShuaiConfig.showTianJiang
          ? _calcTianJiangHint(gong.guiRen, diZhi, monthZhi)
          : null,
    );
  }

  /// 天盘支 / 天将寄宫支 的旺衰
  static WangShuaiHint _calcDiZhiHint(DiZhi from, DiZhi to, DiZhi monthZhi) {
    final fiveXing = from.fiveXing;

    // 月令旺衰
    final monthStatus =
        FiveEnergyStatus.getFiveXingWangShuaiAtDiZhi(monthZhi, fiveXing);

    // 宫内十二长生
    final gongStatus = _getDiZhiZhangSheng(from, to);

    return WangShuaiHint(
      monthLabel: monthStatus.name,
      gongLabel: gongStatus.name,
      monthColorHex: _statusToColorHex(monthStatus),
      gongColorHex: _zhangShengToColorHex(gongStatus),
    );
  }

  /// 天干 的旺衰
  static WangShuaiHint _calcTianGanHint(
      TianGan tianGan, DiZhi palaceDiZhi, DiZhi monthZhi) {
    final fiveXing = tianGan.fiveXing;

    // 月令旺衰
    final monthStatus =
        FiveEnergyStatus.getFiveXingWangShuaiAtDiZhi(monthZhi, fiveXing);

    // 宫内十二长生
    final gongStatus =
        TwelveZhangSheng.getZhangShengByTianGanDiZhi(tianGan, palaceDiZhi);

    return WangShuaiHint(
      monthLabel: monthStatus.name,
      gongLabel: gongStatus.name,
      monthColorHex: _statusToColorHex(monthStatus),
      gongColorHex: _zhangShengToColorHex(gongStatus),
    );
  }

  /// 天将 的旺衰（天将寄宫地支在地盘支上的状态）
  static WangShuaiHint _calcTianJiangHint(
      GuiRen guiRen, DiZhi palaceDiZhi, DiZhi monthZhi) {
    final fiveXing = guiRen.fiveXing;

    // 月令旺衰
    final monthStatus =
        FiveEnergyStatus.getFiveXingWangShuaiAtDiZhi(monthZhi, fiveXing);

    // 宫内十二长生（天将寄宫地支在地盘支上的状态）
    final gongStatus = _getDiZhiZhangSheng(guiRen.zhi, palaceDiZhi);

    return WangShuaiHint(
      monthLabel: monthStatus.name,
      gongLabel: gongStatus.name,
      monthColorHex: _statusToColorHex(monthStatus),
      gongColorHex: _zhangShengToColorHex(gongStatus),
    );
  }

  static TwelveZhangSheng _getDiZhiZhangSheng(DiZhi from, DiZhi to) {
    final fiveXing = from.fiveXing;
    final mapper = TwelveZhangSheng.fiveXingZhangShengMapper[fiveXing]!;
    final index = mapper.indexOf(to);
    return TwelveZhangSheng.fromIndex(index);
  }

  static String _statusToColorHex(FiveEnergyStatus status) {
    switch (status) {
      case FiveEnergyStatus.WANG:
      case FiveEnergyStatus.XIANG:
        return _strongColor;
      case FiveEnergyStatus.XIU:
        return _neutralColor;
      case FiveEnergyStatus.QIU:
      case FiveEnergyStatus.SI:
        return _weakColor;
    }
  }

  static String _zhangShengToColorHex(TwelveZhangSheng zhangSheng) {
    if (zhangSheng.isStrong) return _strongColor;
    return _weakColor;
  }
}
