import 'package:flutter/material.dart';
import 'package:daliuren/navigator.dart';
import 'package:daliuren/di/daliuren_storage_dependencies.dart';
import 'package:daliuren/di/school_initialization.dart';
import 'package:provider/provider.dart';
import 'package:persistence_drift/persistence_drift.dart';
import 'package:persistence_preferences/persistence_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistence_drift/daliuren/daliuren_module_registry.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:theme/theme.dart';
import 'package:xuan_common_ui/xuan_common_ui.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'assets_repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final newDb = PersistenceDriftDatabase(
    driftDatabase(
      name: 'daliuren',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    ),
  );
  final prefs = await SharedPreferences.getInstance();
  final sessionRepo = PreferencesAccountSessionRepository(prefs);
  final accountDb = AccountDatabase(
    driftDatabase(
      name: 'account',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    ),
  );
  final identityLinkRepo = DriftAccountIdentityLinkRepository(accountDb);
  
  final bootstrapStore = DriftScopeBootstrapStore(newDb);
  final ledger = DriftScopeLedger(db: newDb, bootstrapStore: bootstrapStore);
  final resolver = ScopeResolver(
    sessionRepository: sessionRepo,
    identityLinkRepository: identityLinkRepo,
    ledger: ledger,
  );
  final resolvedScope = await resolver.resolve();
  final scopeUid = resolvedScope.scopeUid;

  final ds = DriftRecordDataSource(newDb, scopeUid: scopeUid);
  final store = LocalRecordRepository(ds, RecordAdapterRegistry([DaliurenModuleRegistry.codec()]));
  final recordBackedRepository = DaliurenModuleRegistry.repository(store: store);

  // Construct concrete backend implementations (host/assembly seam)
  final deps = DaliurenStorageDependencies(
    officialData: AssetsDaLiuRenOfficialDataRepository(),
    keti: AssetsDaLiuRenKetiRepository(),
    shenShaData: AssetsDaLiuRenShenShaDataRepository(),
    schoolData: AssetsDaLiuRenSchoolDataRepository(),
    recordRepository: recordBackedRepository,
  );

  // Initialize schools using the injected port
  await SchoolInitialization.initialize(deps.schoolData);

  runApp(MyApp(deps: deps));
}

class MyApp extends StatelessWidget {
  final DaliurenStorageDependencies deps;
  const MyApp({super.key, required this.deps});

  @override
  Widget build(BuildContext context) {
    return Provider<DaliurenStorageDependencies>.value(
      value: deps,
      child: XuanThemeScope(
        themeData: DefaultXuanThemeData.themeSet.light,
        child: MaterialApp(
          title: '大六壬 Example',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SelectionPage(),
          onGenerateRoute: NavigatorGenerator.generateRoute,
        ),
      ),
    );
  }
}

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const XuanAppBar(title: Text('大六壬架构选择')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            XuanButton.primary(
              onPressed: () {
                Navigator.of(context).pushNamed('/daliuren/old');
              },
              child: const Text('老架构 (Direct View)'),
            ),
            const SizedBox(height: 24),
            XuanButton.primary(
              onPressed: () {
                Navigator.of(context).pushNamed('/daliuren');
              },
              child: const Text('新架构 (DaLiuRenView)'),
            ),
            const SizedBox(height: 24),
            XuanButton.primary(
              onPressed: () {
                Navigator.of(context).pushNamed('/daliuren/new');
              },
              child: const Text('旧架构新UI (Design System)'),
            ),
            const SizedBox(height: 24),
            XuanButton.primary(
              onPressed: () {
                Navigator.of(context).pushNamed('/daliuren/dev');
              },
              child: const Text('多流派调试 (DevPage)'),
            ),
          ],
        ),
      ),
    );
  }
}
