import 'package:metaphysics_core/enums.dart';
import 'package:metaphysics_core/models/divination_datetime.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:daliuren/domain/enums/gui_ren_type.dart';

export 'package:daliuren/domain/enums/gui_ren_type.dart';

enum CalculateMonthGeneralType {
  @JsonValue("月建")
  monthJian("月建"),
  @JsonValue("月合")
  monthHe("月合"),
  @JsonValue("中气")
  middleQi("中气"),
  @JsonValue("超神法")
  chaoShen("超神法");

  final String name;
  const CalculateMonthGeneralType(this.name);
}

enum DayNightBoundaryType {
  @JsonValue("卯酉")
  maoYou, // 固定卯酉为晨昏分界
  @JsonValue("四季")
  season4, // 夏季为 寅戌， 春秋为卯酉，冬为辰申
  @JsonValue("日升落")
  sunRiseSet, // 根据太阳的实时时间
  @JsonValue("手动")
  manual;
}


class CalculateMonthGeneralService {
  /// 计算月将
  ///
  /// 根据不同的计算类型返回对应的月将地支：
  /// - [CalculateMonthGeneralType.monthJian]: 方法一，月建即月将
  /// - [CalculateMonthGeneralType.monthHe]: 方法二，月建之六合为月将
  /// - [CalculateMonthGeneralType.middleQi]: 中气法
  /// - [CalculateMonthGeneralType.chaoShen]: 超神法（待实现）
  ///
  /// [type] 计算类型
  /// [datetimeModel] 占卜时间模型，包含节气信息
  ///
  /// 返回对应的月将地支
  MonthGeneral calculate(
      CalculateMonthGeneralType type, DivinationDatetimeModel datetimeModel) {
    switch (type) {
      case CalculateMonthGeneralType.monthJian:
        return _calculateByMonthJian(datetimeModel);
      case CalculateMonthGeneralType.monthHe:
        return _calculateByMonthHe(datetimeModel);
      case CalculateMonthGeneralType.middleQi:
        return _calculateByZhongQi(datetimeModel);
      case CalculateMonthGeneralType.chaoShen:
        // TODO: 实现超神法
        throw UnimplementedError('超神法暂未实现');
    }
  }

  /// 方法一：月建即月将
  ///
  /// 这是最简单的一种方法，虽然不常用，但逻辑清晰。
  /// 核心原理：月将与月建完全相同。
  ///
  /// 实现思路：
  /// 1. 接收 target_datetime
  /// 2. 根据 target_datetime 和二十四节气表，判断其所属的"节令月"，从而确定月建地支
  /// 3. 直接将这个月建地支作为结果返回
  ///
  /// [datetimeModel] 占卜时间模型
  /// 返回月建地支作为月将
  MonthGeneral _calculateByMonthJian(DivinationDatetimeModel datetimeModel) {
    // 获取当前节气信息
    final jieQiInfo = datetimeModel.jieQiInfo;
    final currentJieQi = jieQiInfo.jieQi;
    return MonthGeneral.getByDiZhi(datetimeModel.monthJiaZi.diZhi);

    // // 根据节气确定月建地支
    // // 月建是根据二十四节气中的"节"来划分的
    // // 从"立春"到"惊蛰"前为寅月，从"惊蛰"到"清明"前为卯月，以此类推
    // DiZhi monthJianZhi = _getMonthJianByJieQi(currentJieQi);

    // return monthJianZhi;
  }

  /// 方法二：月建之六合为月将
  ///
  /// 这是"金口诀"流派常用的方法，逻辑在方法一的基础上进了一步。
  /// 核心原理：月将是月建地支的"六合"地支。
  ///
  /// 六合关系：
  /// - 子丑合、寅亥合、卯戌合、辰酉合、巳申合、午未合
  ///
  /// 实现思路：
  /// 1. 执行与方法一相同的步骤，先根据 target_datetime 确定月建
  /// 2. 使用六合关系查找表，找到该月建地支对应的六合地支
  /// 3. 返回这个六合地支作为月将
  ///
  /// [datetimeModel] 占卜时间模型
  /// 返回月建地支的六合地支作为月将
  MonthGeneral _calculateByMonthHe(DivinationDatetimeModel datetimeModel) {
    // 先获取月建地支
    // DiZhi monthJianZhi = (datetimeModel);

    // 获取月建地支的六合地支
    // DiZhi monthHeZhi = monthJianZhi.sixHeZhi;
    return MonthGeneral.getByDiZhi(datetimeModel.monthJiaZi.diZhi.sixHeZhi);

    // return monthHeZhi;
  }

  ///
  /// 这是基于太阳在黄道十二宫位置的精确计算方法。
  /// 核心原理：根据二十四节气中的"中气"和"节"来确定月将。
  ///
  /// 中气换月将对应关系：
  /// - 雨水、惊蛰 → 亥（登明）
  /// - 春分、清明 → 戌（河魁）
  /// - 谷雨、立夏 → 酉（从魁）
  /// - 小满、芒种 → 申（传送）
  /// - 夏至、小暑 → 未（小吉）
  /// - 大暑、立秋 → 午（胜光）
  /// - 处暑、白露 → 巳（太乙）
  /// - 秋分、寒露 → 辰（天罡）
  /// - 霜降、立冬 → 卯（太冲）
  /// - 小雪、大雪 → 寅（功曹）
  /// - 冬至、小寒 → 丑（大吉）
  /// - 大寒、立春 → 子（神后）
  ///
  /// [datetimeModel] 占卜时间模型
  /// 返回根据中气法计算的月将地支
  MonthGeneral _calculateByZhongQi(DivinationDatetimeModel datetimeModel) {
    // 获取当前节气信息
    final jieQiInfo = datetimeModel.jieQiInfo;
    final currentJieQi = jieQiInfo.jieQi;

    // 根据节气的order来判断月将
    switch (currentJieQi.order) {
      // 雨水(4)、惊蛰(5) -> 亥（登明）
      case 4:
      case 5:
        return MonthGeneral.HAI_ZHENG_MING;

      // 春分(6)、清明(7) -> 戌（河魁）
      case 6:
      case 7:
        return MonthGeneral.XU_TIAN_KUI;

      // 谷雨(8)、立夏(9) -> 酉（从魁）
      case 8:
      case 9:
        return MonthGeneral.YOU_CONG_KUI;

      // 小满(10)、芒种(11) -> 申（传送）
      case 10:
      case 11:
        return MonthGeneral.SHEN_CHUAN_SONG;

      // 夏至(12)、小暑(13) -> 未（小吉）
      case 12:
      case 13:
        return MonthGeneral.WEI_XIAO_JI;

      // 大暑(14)、立秋(15) -> 午（胜光）
      case 14:
      case 15:
        return MonthGeneral.WU_SHENG_GUANG;

      // 处暑(16)、白露(17) -> 巳（太乙）
      case 16:
      case 17:
        return MonthGeneral.SI_TAI_YI;

      // 秋分(18)、寒露(19) -> 辰（天罡）
      case 18:
      case 19:
        return MonthGeneral.CHEN_TIAN_GANG;

      // 霜降(20)、立冬(21) -> 卯（太冲）
      case 20:
      case 21:
        return MonthGeneral.MAO_TAI_CHONG;

      // 小雪(22)、大雪(23) -> 寅（功曹）
      case 22:
      case 23:
        return MonthGeneral.YIN_GONG_CAO;

      // 冬至(0)、小寒(1) -> 丑（大吉）
      case 0:
      case 1:
        return MonthGeneral.CHOU_DA_JI;

      // 大寒(2)、立春(3) -> 子（神后）
      case 2:
      case 3:
        return MonthGeneral.ZI_SHEN_HOU;

      default:
        throw ArgumentError('无效的节气order: ${currentJieQi.order}');
    }
  }
}
