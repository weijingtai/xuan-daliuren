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

  static Future<DaliurenCalculationContext> load({
    required ShenShaCalculationService shenShaService,
    required DaLiuRenCalculationService calculationService,
  }) async {
    final allShenSha = <String, ShenShaEntity>{};
    final names = <String>[];

    // Try to find known shen sha entities by name
    final knownNames = ['干德', '太岁', '天德'];
    for (final name in knownNames) {
      final entity = await shenShaService.findShenShaByName(name);
      if (entity != null) {
        allShenSha[name] = entity;
        names.add(name);
      }
    }

    return DaliurenCalculationContext(
      calculationService: calculationService,
      knownShenShaNames: names,
      shenShaByName: allShenSha,
    );
  }
}
