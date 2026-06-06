import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';

/// Storage ports injected into the daliuren product by the host/assembly.
/// The product never constructs concrete backends; it only consumes these.
class DaliurenStorageDependencies {
  const DaliurenStorageDependencies({
    required this.officialData,
    required this.keti,
    required this.shenShaData,
    required this.schoolData,
  });

  final DaLiuRenOfficialDataRepository officialData;
  final DaLiuRenKetiRepository keti;
  final DaLiuRenShenShaDataRepository shenShaData;
  final DaLiuRenSchoolDataRepository schoolData;
}
