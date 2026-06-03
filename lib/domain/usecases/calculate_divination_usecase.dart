import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';

class CalculateDivinationUseCase
    extends UseCase<DaLiuRenKePan, dynamic> {
  final DaLiuRenRepository repository;

  CalculateDivinationUseCase(this.repository);

  @override
  Future<DaLiuRenKePan> call(dynamic params) async {
    try {
      if (params is DateTimeParams) {
        return await repository.calculateDivination(
          params.dateTime,
          question: params.question,
        );
      } else if (params is ManualJuParams) {
        return await repository.calculateManualDivination(
          dayJiaZi: params.dayJiaZi,
          yinYangDun: params.yinYangDun,
          monthGeneral: params.monthGeneral,
          timeZhi: params.timeZhi,
          juNumber: params.juNumber,
          yearJiaZi: params.yearJiaZi ?? JiaZi.JIA_ZI,
          monthJiaZi: params.monthJiaZi ?? JiaZi.JIA_ZI,
        );
      }
      throw DivinationFailure('Unsupported parameter type');
    } catch (e) {
      throw DivinationFailure('Failed to calculate divination: $e');
    }
  }
}
