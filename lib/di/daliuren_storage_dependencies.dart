import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:xuan_time_location/xuan_time_location.dart';

/// Storage ports injected into the daliuren product by the host/assembly.
/// The product never constructs concrete backends; it only consumes these.
class DaliurenStorageDependencies {
  const DaliurenStorageDependencies({
    required this.officialData,
    required this.keti,
    required this.shenShaData,
    required this.schoolData,
    required this.recordRepository,
    this.timezoneProvider,
  });

  final DaLiuRenOfficialDataRepository officialData;
  final DaLiuRenKetiRepository keti;
  final DaLiuRenShenShaDataRepository shenShaData;
  final DaLiuRenSchoolDataRepository schoolData;
  final DaliurenRecordRepository recordRepository;

  /// 宿主解析的当前时区（用户偏好 > 地点 > 中国默认）。null 时回退 [chinaTimeZoneId]。
  final String Function()? timezoneProvider;
}
