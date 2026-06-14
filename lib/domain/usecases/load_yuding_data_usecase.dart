import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';

/// 加载御定大六壬原始数据的用例
///
/// 封装 DaLiuRenRepository.getYuDingData()，为后续 D3 迁移做准备。
/// 页面层将通过此用例加载御定数据，而非直接访问 Repository。
class LoadYuDingDataUseCase extends UseCase<List<dynamic>, NoParams> {
  final DaLiuRenRepository _repository;

  LoadYuDingDataUseCase(this._repository);

  @override
  Future<List<dynamic>> call(NoParams params) async {
    try {
      return await _repository.getYuDingData();
    } catch (e) {
      throw DivinationFailure('加载御定数据失败: $e');
    }
  }
}
