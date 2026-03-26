import 'package:common/enums.dart';
import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/model/da_liu_ren_panel.dart';

class YuDingKetiMatchService {
  final DaLiuRenRepository repository;

  YuDingKetiMatchService({required this.repository});

  /// 获取课体名称列表
  /// 目前通过《御定大六壬》预计算的数据集进行匹配。
  /// 未来可扩展基于 keti_data.json 中 conditions 实时运算的方案。
  Future<List<String>> getKeTiNames(DaLiuRenPanel kePan) async {
    try {
      final yuDingData = await repository.getYuDingData();
      final String dayJiaZiStr = kePan.getDayJiaZi().name; // e.g. "甲子"
      
      // 找到日干的寄宫 (JiGong)
      final DiZhi jiGong = _getJiGong(kePan.getDayJiaZi().tianGan);
      
      // 获取该寄宫上的天盘地支名称，作为 juName 进行匹配
      final String juName = kePan.getGongMapper()[jiGong]!.skyPanDiZhi.name;
      
      print('🔍 [YuDingService] Searching match for: Day=$dayJiaZiStr, Ju=$juName (JiGong=${jiGong.name})');

      // 在御定数据集中查找对应的条目
      final match = yuDingData.firstWhere(
        (item) => item['dayJiaZi'] == dayJiaZiStr && item['juName'] == juName,
        orElse: () => null,
      );

      if (match != null && match['body'] != null) {
        final results = List<String>.from(match['body']);
        print('✅ [YuDingService] Found KeTi: $results');
        return results;
      }
      
      print('❌ [YuDingService] No match found in YuDing dataset for $dayJiaZiStr / $juName');
      return [];
    } catch (e) {
      print('🚨 [YuDingService] Error matching KeTi: $e');
      return [];
    }
  }

  DiZhi _getJiGong(TianGan tianGan) {
    switch (tianGan) {
      case TianGan.JIA:
        return DiZhi.YIN;
      case TianGan.YI:
        return DiZhi.CHEN;
      case TianGan.BING:
      case TianGan.WU:
        return DiZhi.SI;
      case TianGan.DING:
      case TianGan.JI:
        return DiZhi.WEI;
      case TianGan.GENG:
        return DiZhi.SHEN;
      case TianGan.XIN:
        return DiZhi.XU;
      case TianGan.REN:
        return DiZhi.HAI;
      case TianGan.GUI:
      case TianGan.KONG_WANG: // Handle empty values gracefully
        return DiZhi.CHOU;
    }
  }
}
