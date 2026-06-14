import 'package:daliuren/domain/services/yuding_keti_match_service.dart';
import 'package:daliuren/domain/usecases/base_usecase.dart';
import 'package:daliuren/model/da_liu_ren_ke_pan.dart';

/// 匹配御定课体的参数
class MatchYuDingKetiParams {
  final DaLiuRenKePan kePan;

  const MatchYuDingKetiParams(this.kePan);
}

/// 匹配御定大六壬课体名称的用例
///
/// 封装 YuDingKetiMatchService，通过御定数据集匹配课体名称。
/// ViewModel 通过此用例获取课体匹配结果，而非直接依赖 YuDingKetiMatchService。
class MatchYuDingKetiUseCase extends UseCase<List<String>, MatchYuDingKetiParams> {
  final YuDingKetiMatchService _matchService;

  MatchYuDingKetiUseCase(this._matchService);

  @override
  Future<List<String>> call(MatchYuDingKetiParams params) async {
    try {
      return await _matchService.getKeTiNames(params.kePan);
    } catch (e) {
      throw DivinationFailure('匹配御定课体失败: $e');
    }
  }
}
