import 'dart:convert';

import 'package:daliuren/domain/pipeline/daliuren_calculation_context.dart';
import 'package:daliuren/domain/pipeline/daliuren_chart_params.dart';
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

    final now = params.createdAt ?? DateTime.now();

    return DaliurenDivinationRecordContract(
      uuid: params.uuid,
      question: params.question,
      lunarDateJson: jsonEncode({
        'month': moment.lunar.month,
        'day': moment.lunar.day,
        'isLeapMonth': moment.lunar.isLeapMonth,
      }),
      ganzhiJson: jsonEncode({
        'year': moment.eightChars.year,
        'month': moment.eightChars.month,
        'day': moment.eightChars.day,
        'time': moment.eightChars.time,
      }),
      juNumber: null,
      juName: null,
      schoolId: 'default',
      yueJiangJson: jsonEncode({'monthGeneral': kePan.monthGeneral}),
      riYueJson: null,
      sanChuanJson: null,
      siKeJson: null,
      twelveTianJinJson: null,
      paramsJson: jsonEncode(params.toJson()),
      createdAt: now,
      updatedAt: now,
    );
  }
}
