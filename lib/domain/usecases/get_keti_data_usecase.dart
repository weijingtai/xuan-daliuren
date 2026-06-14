import 'package:daliuren/domain/entities/daliuren_lesson.dart';
import 'package:daliuren/domain/services/keti_data_service.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';

/// 加载课体数据的参数
class LoadKetiDataParams {
  const LoadKetiDataParams();
}

/// 加载并查询课体数据的用例
///
/// 封装 KetiDataService，提供课体数据加载和查询能力。
/// ViewModel 通过此用例访问课体数据，而非直接依赖 KetiDataService。
class GetKetiDataUseCase extends UseCase<List<DaliurenLesson>, LoadKetiDataParams> {
  final KetiDataService _ketiDataService;

  GetKetiDataUseCase(this._ketiDataService);

  @override
  Future<List<DaliurenLesson>> call(LoadKetiDataParams params) async {
    try {
      if (!_ketiDataService.isLoaded) {
        await _ketiDataService.loadData();
      }
      return _ketiDataService.lessons;
    } catch (e) {
      throw DivinationFailure('加载课体数据失败: $e');
    }
  }

  /// 按名称列表批量匹配课体
  List<KetiMatchResult> findByNames(List<String> names) {
    return _ketiDataService.findByNames(names);
  }

  /// 课体数据是否已加载
  bool get isLoaded => _ketiDataService.isLoaded;
}
