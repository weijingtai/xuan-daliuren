import 'package:daliuren/data/repositories/da_liu_ren_repository_impl.dart';
import 'package:daliuren/data/services/shen_sha_data_service_impl.dart';
import 'package:daliuren/domain/repositories/da_liu_ren_repository.dart';
import 'package:daliuren/domain/services/calculators/lunar_calculator.dart';
import 'package:daliuren/domain/services/calculators/tian_di_pan_calculator.dart';
import 'package:daliuren/domain/services/calculators/gui_ren_calculator.dart';
import 'package:daliuren/domain/services/calculators/four_class_calculator.dart';
import 'package:daliuren/domain/services/calculators/three_chuan_calculator.dart';
import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/keti_data_service.dart';
import 'package:daliuren/domain/services/yuding_keti_match_service.dart';
import 'package:daliuren/domain/services/shen_sha_calculation_service_impl.dart';
import 'package:daliuren/domain/usecases/calculate_divination_usecase.dart';
import 'package:daliuren/domain/usecases/calculate_shen_sha_usecase.dart';
import 'package:daliuren/domain/usecases/load_divination_data_usecase.dart';
import 'package:daliuren/domain/usecases/load_yuding_data_usecase.dart';
import 'package:daliuren/domain/usecases/get_keti_data_usecase.dart';
import 'package:daliuren/domain/usecases/match_yuding_keti_usecase.dart';
import 'package:daliuren/presentation/viewmodels/da_liu_ren_viewmodel.dart';
import 'package:daliuren/di/daliuren_storage_dependencies.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyInjection {
  static List<SingleChildWidget> getProviders(DaliurenStorageDependencies deps) {
    final DaLiuRenOfficialDataRepository officialData = deps.officialData;
    final DaLiuRenKetiRepository ketiRepo = deps.keti;
    final DaLiuRenShenShaDataRepository shenShaData = deps.shenShaData;

    return [
      Provider<DaliurenRecordRepository>(
        create: (_) => deps.recordRepository,
      ),
      // Calculators
      Provider<LunarCalculator>(create: (_) => LunarCalculator()),
      Provider<TianDiPanCalculator>(create: (_) => TianDiPanCalculator()),
      Provider<GuiRenCalculator>(create: (_) => GuiRenCalculator()),
      Provider<FourClassCalculator>(create: (_) => FourClassCalculator()),
      Provider<ThreeChuanCalculator>(create: (_) => ThreeChuanCalculator()),

      // Calculation Service
      Provider<DaLiuRenCalculationService>(
        create: (context) => DaLiuRenCalculationService(
          lunarCalculator: context.read<LunarCalculator>(),
          tianDiPanCalculator: context.read<TianDiPanCalculator>(),
          guiRenCalculator: context.read<GuiRenCalculator>(),
          fourClassCalculator: context.read<FourClassCalculator>(),
          threeChuanCalculator: context.read<ThreeChuanCalculator>(),
        ),
      ),

      // KeTi Data Service (now port-injected)
      Provider<KetiDataService>(
        create: (_) => KetiDataService(keti: ketiRepo),
      ),

      // Repository (now port-injected for official data)
      Provider<DaLiuRenRepository>(
        create: (context) => DaLiuRenRepositoryImpl(
          calculationService: context.read<DaLiuRenCalculationService>(),
          ketiDataService: context.read<KetiDataService>(),
          officialData: officialData,
        ),
      ),

      // YuDing KeTi Match Service
      Provider<YuDingKetiMatchService>(
        create: (context) => YuDingKetiMatchService(
          repository: context.read<DaLiuRenRepository>(),
        ),
      ),

      // Shen Sha Services (now port-injected)
      Provider<ShenShaDataServiceImpl>(
        create: (_) => ShenShaDataServiceImpl(shenShaData: shenShaData),
      ),
      Provider<ShenShaCalculationServiceImpl>(
        create: (context) => ShenShaCalculationServiceImpl(
          dataService: context.read<ShenShaDataServiceImpl>(),
        ),
      ),
      Provider<CalculateShenShaUseCase>(
        create: (context) => CalculateShenShaUseCase(
          context.read<ShenShaCalculationServiceImpl>(),
        ),
      ),

      // ViewModel
      ChangeNotifierProvider<DaLiuRenViewModel>(
        create: (context) {
          final repository = context.read<DaLiuRenRepository>();
          return DaLiuRenViewModel(
            calculateDivinationUseCase: CalculateDivinationUseCase(repository),
            loadDivinationDataUseCase: LoadDivinationDataUseCase(repository),
            calculateShenShaUseCase: context.read<CalculateShenShaUseCase>(),
            getKetiDataUseCase: GetKetiDataUseCase(context.read<KetiDataService>()),
            matchYuDingKetiUseCase: MatchYuDingKetiUseCase(context.read<YuDingKetiMatchService>()),
            loadYuDingDataUseCase: LoadYuDingDataUseCase(repository),
            context.read<DaliurenRecordRepository>(),
          );
        },
      ),
    ];
  }
}
