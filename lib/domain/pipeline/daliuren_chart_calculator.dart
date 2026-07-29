import 'dart:convert';

import 'package:daliuren/domain/pipeline/daliuren_calculation_context.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_params.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';
import 'package:daliuren/model/each_chuan.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';

final class DaliurenChartCalculator
    implements
        ChartCalculator<DaliurenChartParams, DaliurenDivinationRecordContract> {
  final DaliurenCalculationContext context;

  const DaliurenChartCalculator({required this.context});

  @override
  String get module => 'daliuren';

  @override
  DaliurenDivinationRecordContract calculate(
    ResolvedMoment moment,
    DaliurenChartParams params,
  ) {
    final kePan = context.calculationService.calculate(
      moment.nominalTime,
      question: params.question,
    );

    return DaliurenDivinationRecordContract(
      uuid: params.uuid,
      question: params.question,
      lunarDateJson: jsonEncode({
        'month': moment.lunar.month,
        'day': moment.lunar.day,
        'isLeapMonth': moment.lunar.isLeapMonth,
      }),
      ganzhiJson: jsonEncode({
        'year': moment.eightChars.year.name,
        'month': moment.eightChars.month.name,
        'day': moment.eightChars.day.name,
        'time': moment.eightChars.time.name,
      }),
      juNumber: null,
      juName: null,
      schoolId: 'default',
      yueJiangJson: jsonEncode({'monthGeneral': kePan.monthGeneral.name}),
      riYueJson: jsonEncode(_buildRiYueJson(kePan)),
      sanChuanJson: jsonEncode(_buildSanChuanJson(kePan)),
      siKeJson: jsonEncode(_buildSiKeJson(kePan)),
      twelveTianJinJson: jsonEncode(_buildTwelveTianJinJson(kePan)),
      shenShaJson: jsonEncode(_buildShenShaJson()),
      paramsJson: jsonEncode(params.toJson()),
      createdAt: params.createdAt,
      updatedAt: params.createdAt,
    );
  }

  Map<String, dynamic> _buildSanChuanJson(DaLiuRenKePan kePan) {
    final tc = kePan.threeChuan;
    return {
      'nineZongMen': tc.nineZongMen.name,
      'first': _eachChuanToJson(tc.first),
      'second': _eachChuanToJson(tc.second),
      'third': _eachChuanToJson(tc.third),
    };
  }

  Map<String, dynamic> _eachChuanToJson(EachChuan chuan) {
    return {
      'order': chuan.order,
      'diZhi': chuan.diZhi.name,
      'guiRen': chuan.guiRen.name,
      'liuQin': chuan.liuQin.name,
      'tianGan': chuan.tianGan?.name,
    };
  }

  Map<String, dynamic> _buildSiKeJson(DaLiuRenKePan kePan) {
    final fc = kePan.fourClass;
    final classes = fc.listAllClass;
    final result = <Map<String, dynamic>>[];
    for (int i = 0; i < classes.length && i < 4; i++) {
      final c = classes[i];
      result.add({
        'order': c.order,
        'ground': c.ground.name,
        'sky': c.sky.name,
        'zeiKeType': c.zeiKeType?.name,
      });
    }
    return {'classes': result, 'isFullClass': fc.isFullClass};
  }

  Map<String, dynamic> _buildTwelveTianJinJson(DaLiuRenKePan kePan) {
    final skyMap = <String, String>{};
    for (final entry in kePan.gongMapper.entries) {
      skyMap[entry.key.name] = entry.value.guiRen.name;
    }
    return {'godsMapper': skyMap};
  }

  Map<String, dynamic> _buildRiYueJson(DaLiuRenKePan kePan) {
    return {
      'dayJiaZi': kePan.getDayJiaZi().name,
      'isDayGuiRen': kePan.isDayGuiRen,
      'guiRenDiZhi': kePan.guiRenDiZhi.name,
    };
  }

  /// 序列化 context 预载的神煞数据（裁决三：神煞前置到 load()，calculate 同步消费）。
  /// 神煞作为盘面的可选附加层，记录预载到的神煞名、吉凶与类型。
  Map<String, dynamic> _buildShenShaJson() {
    final entries = <Map<String, dynamic>>[];
    for (final entity in context.shenShaByName.values) {
      entries.add({
        'name': entity.name,
        'jiXiong': entity.jiXiong.name,
        'type': entity.type,
      });
    }
    return {'shenShaList': entries};
  }
}
