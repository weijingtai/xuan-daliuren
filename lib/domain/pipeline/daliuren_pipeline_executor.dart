import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service.dart';
import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:xuan_time_location/xuan_time_location.dart';

import 'daliuren_calculation_context.dart';
import 'daliuren_chart_calculator.dart';
import 'daliuren_chart_params.dart';

/// 大六壬管线编排器。
///
/// 服务依赖（[ShenShaCalculationService]、[ShenShaDataService]、
/// [DaLiuRenCalculationService]）跨次排盘不变，作为构造参数注入；
/// 每次排盘会变的数据（时刻、params）统一走 [ChartRequest]。
final class DaliurenPipelineExecutor {
  final ShenShaCalculationService shenShaService;
  final ShenShaDataService shenShaDataService;
  final DaLiuRenCalculationService calculationService;
  final MomentResolver _momentResolver;

  DaliurenPipelineExecutor({
    required this.shenShaService,
    required this.shenShaDataService,
    required this.calculationService,
    MomentResolver? momentResolver,
  }) : _momentResolver = momentResolver ?? const DefaultMomentResolver();

  /// 执行大六壬管线：加载 context → 构造 calculator → 计算合约。
  Future<DaliurenDivinationRecordContract> execute(
    ChartRequest<DaliurenChartParams> request,
  ) async {
    final moment = _momentResolver.resolve(request.moment);
    final context = await DaliurenCalculationContext.load(
      shenShaService: shenShaService,
      shenShaDataService: shenShaDataService,
      calculationService: calculationService,
    );
    final calculator = DaliurenChartCalculator(context: context);
    return calculator.calculate(moment, request.params);
  }
}
