import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../di/daliuren_storage_dependencies.dart';
import '../../di/dependency_injection.dart';

final class DaliurenModuleManifest {
  const DaliurenModuleManifest._();

  static const String id = 'daliuren';
  static const String displayNameKey = 'module_daliuren_name';
  static const String version = '0.1.0';
  static const String minShellVersion = '0.1.0-a3';

  static List<SingleChildWidget> createProviders(
    DaliurenStorageDependencies deps,
  ) {
    return DependencyInjection.getProviders(deps);
  }
}
