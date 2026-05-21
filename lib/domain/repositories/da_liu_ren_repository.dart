import 'package:common/enums.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';

abstract class DaLiuRenRepository {
  Future<DaLiuRenKePan> calculateDivination(DateTime dateTime, {String? question});
  Future<DaLiuRenKePan> calculateManualDivination({
    required JiaZi dayJiaZi,
    required YinYang yinYangDun,
    required MonthGeneral monthGeneral,
    DiZhi? timeZhi,
    int? juNumber,
    required JiaZi yearJiaZi,
    required JiaZi monthJiaZi,
  });
  Future<void> loadDivinationData();
  Future<List<dynamic>> getYuDingData();
  Future<Map<String, dynamic>> getJuMapperData();
}