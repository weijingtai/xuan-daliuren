import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';

class DaliurenCalculationContext {
  final DaLiuRenCalculationService calculationService;
  final List<String> knownShenShaNames;
  final Map<String, ShenShaEntity> shenShaByName;

  const DaliurenCalculationContext({
    required this.calculationService,
    required this.knownShenShaNames,
    required this.shenShaByName,
  });

  /// 从权威数据源 [shenShaDataService] 加载全部神煞实体，
  /// 取代之前的硬编码取样（干德、太岁、天德）。
  static Future<DaliurenCalculationContext> load({
    required ShenShaCalculationService shenShaService,
    required ShenShaDataService shenShaDataService,
    required DaLiuRenCalculationService calculationService,
  }) async {
    final allEntities = await shenShaDataService.loadAllShenSha();

    final allShenSha = <String, ShenShaEntity>{};
    final names = <String>[];

    for (final entity in allEntities) {
      allShenSha[entity.name] = entity;
      names.add(entity.name);
    }

    return DaliurenCalculationContext(
      calculationService: calculationService,
      knownShenShaNames: names,
      shenShaByName: allShenSha,
    );
  }
}
