import 'package:metaphysics_core/enums.dart';
import 'package:tyme/tyme.dart' hide YinYang;
import 'base_calculator.dart';

/// 农历计算器
///
/// 负责将公历时间转换为农历、计算四柱八字、确定月将、判断阴阳遁和局数
class LunarCalculator extends BaseCalculator {
  @override
  String get name => 'LunarCalculator';

  /// 计算四柱八字
  String calculateBaZi(DateTime dateTime) {
    try {
      final solarTime = SolarTime.fromYmdHms(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
      final eightChar = solarTime.getLunarHour().getEightChar();
      return [
        eightChar.getYear().getName(),
        eightChar.getMonth().getName(),
        eightChar.getDay().getName(),
        eightChar.getHour().getName(),
      ].join(" ");
    } catch (e) {
      throw Exception('Failed to calculate BaZi: $e');
    }
  }

  /// 确定月将(根据节气)
  MonthGeneral calculateMonthGeneral(DateTime dateTime) {
    try {
      final solarDay =
          SolarDay.fromYmd(dateTime.year, dateTime.month, dateTime.day);
      var term = solarDay.getTerm();
      final termAt = _toDateTime(term.getJulianDay().getSolarTime());

      // 时间校准：若最近节气时刻晚于 dateTime（当天节气未到），退回上一个节气。
      if (termAt.isAfter(dateTime)) {
        term = term.next(-1);
      }
      // 月将起点是中气（tyme index 偶数：冬至/大寒/雨水/春分/谷雨/小满/
      // 夏至/大暑/处暑/秋分/霜降/小雪），而 getTerm() 可能返回节（奇数 index）。
      // 循环退回最近的中气（isQi），再匹配 MonthGeneral.jieSegment.item1。
      while (!term.isQi()) {
        term = term.next(-1);
      }
      return MonthGeneral.fromByStartAtJie(term.getName());
    } catch (e) {
      throw Exception('Failed to calculate MonthGeneral: $e');
    }
  }

  /// SolarTime -> DateTime（复用原 getSolarTime 取整逻辑）。
  DateTime _toDateTime(dynamic solarTime) {
    return DateTime(
      solarTime.getYear(),
      solarTime.getMonth(),
      solarTime.getDay(),
      solarTime.getHour(),
      solarTime.getMinute(),
      solarTime.getSecond(),
    );
  }

  /// 判断阴阳遁
  YinYang determineYinYangDun(bool isDayGuiRen) {
    return isDayGuiRen ? YinYang.YANG : YinYang.YIN;
  }

  /// 解析八字字符串为JiaZi列表
  List<JiaZi> parseBaZiString(String baZiStr) {
    try {
      final parts = baZiStr.trim().split(RegExp(r'\s+'));
      if (parts.length != 4) {
        throw ArgumentError(
            'Invalid BaZi format. Expected "年 月 日 时", got: $baZiStr');
      }

      return [
        JiaZi.getFromGanZhiValue(parts[0])!,
        JiaZi.getFromGanZhiValue(parts[1])!,
        JiaZi.getFromGanZhiValue(parts[2])!,
        JiaZi.getFromGanZhiValue(parts[3])!,
      ];
    } catch (e) {
      throw Exception('Failed to parse BaZi string: $e');
    }
  }
}
