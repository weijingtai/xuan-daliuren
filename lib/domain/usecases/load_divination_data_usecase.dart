import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:xuan_logger/xuan_logger.dart';

class LoadDivinationDataUseCase extends UseCase<void, NoParams> {
  final DaLiuRenRepository repository;

  LoadDivinationDataUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    try {
      logger.d('🟢 [UseCase] LoadDivinationDataUseCase.call() - Loading data from Repository...');
      await repository.loadDivinationData();
      logger.d('🟢 [UseCase] Data loaded successfully from Repository');
    } catch (e) {
      logger.e('🔴 [UseCase] Error in LoadDivinationDataUseCase: $e');
      throw DivinationFailure('Failed to load divination data: $e');
    }
  }
}
