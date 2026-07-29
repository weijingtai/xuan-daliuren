import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service.dart';
import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';

import 'daliuren_calculation_context.dart';
import 'daliuren_chart_calculator.dart';
import 'daliuren_chart_params.dart';

/// 大六壬管线编排结果，承载最终的占卜记录合约。
class DaliurenPipelineResult {
  final DaliurenDivinationRecordContract contract;
  const DaliurenPipelineResult({required this.contract});
}

/// 大六壬管线编排器。
///
/// 调用方必须注入三个必需的 service 实例（不可从全局单例抓取）：
/// - [shenShaService]：神煞计算服务
/// - [shenShaDataService]：神煞数据加载服务
/// - [calculationService]：大六壬核心计算服务
///
/// 用法：
/// ```dart
/// final executor = DaliurenPipelineExecutor(
///   shenShaService: shenShaService,
///   shenShaDataService: shenShaDataService,
///   calculationService: calculationService,
/// );
/// final result = await executor.execute(moment: moment, params: params);
/// ```
class DaliurenPipelineExecutor {
  final ShenShaCalculationService shenShaService;
  final ShenShaDataService shenShaDataService;
  final DaLiuRenCalculationService calculationService;

  const DaliurenPipelineExecutor({
    required this.shenShaService,
    required this.shenShaDataService,
    required this.calculationService,
  });

  /// 执行大六壬管线：加载 context → 构造 calculator → 计算合约。
  Future<DaliurenPipelineResult> execute({
    required ResolvedMoment moment,
    required DaliurenChartParams params,
  }) async {
    final context = await DaliurenCalculationContext.load(
      shenShaService: shenShaService,
      shenShaDataService: shenShaDataService,
      calculationService: calculationService,
    );
    final calculator = DaliurenChartCalculator(context: context);
    final contract = calculator.calculate(moment, params);
    return DaliurenPipelineResult(contract: contract);
  }
}
