import 'package:flutter_test/flutter_test.dart';
import 'package:daliuren/domain/services/keti_data_service.dart';
import 'package:daliuren/di/daliuren_storage_dependencies.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:daliuren/data/repositories/da_liu_ren_repository_impl.dart';
import 'package:daliuren/domain/services/da_liu_ren_calculation_service.dart';
import 'package:daliuren/domain/services/calculators/lunar_calculator.dart';
import 'package:daliuren/domain/services/calculators/tian_di_pan_calculator.dart';
import 'package:daliuren/domain/services/calculators/gui_ren_calculator.dart';
import 'package:daliuren/domain/services/calculators/four_class_calculator.dart';
import 'package:daliuren/domain/services/calculators/three_chuan_calculator.dart';
import 'package:daliuren/data/services/shen_sha_data_service_impl.dart';
import 'package:daliuren/data/schools/yuding_school.dart';

// ── Fake port implementations with Spy / Call Counters ─────────

class _FakeOfficialData implements DaLiuRenOfficialDataRepository {
  int getYudingDataCallCount = 0;
  int getJuMapperDataCallCount = 0;
  int getYangPanDataCallCount = 0;
  int getYinPanDataCallCount = 0;

  @override
  Future<dynamic> get(String id) async {
    switch (id) {
      case 'yuding':
        getYudingDataCallCount++;
        return [
          {'dayJiaZi': '甲子', 'juNumber': 1, 'juName': 'test_ju', 'body': []}
        ];
      case 'jumapper':
        getJuMapperDataCallCount++;
        return {'甲子': 1};
      case 'yangpan':
        getYangPanDataCallCount++;
        return [];
      case 'yinpan':
        getYinPanDataCallCount++;
        return [];
      default:
        throw ArgumentError('Unknown id: $id');
    }
  }

  @override
  Future<List<dynamic>> query([Map<String, Object?>? criteria]) async {
    final type = criteria?['type'] as String? ?? 'yuding';
    return get(type) as Future<List<dynamic>>;
  }
}

class _FakeKeti implements DaLiuRenKetiRepository {
  int queryCallCount = 0;

  @override
  Future<List<dynamic>> query([Map<String, Object?>? criteria]) async {
    queryCallCount++;
    return [
      {'id': 1, 'name': '伏吟'},
    ];
  }

  @override
  Future<dynamic> get(String id) async {
    return null;
  }
}

class _FakeShenSha implements DaLiuRenShenShaDataRepository {
  int loadGanShenShaRawCallCount = 0;
  int loadYearShenShaRawCallCount = 0;
  int loadMonthShenShaRawCallCount = 0;
  int loadZhiShenShaRawCallCount = 0;
  int loadJiShenShaRawCallCount = 0;
  int loadXunShenShaRawCallCount = 0;
  int loadYearGanShenShaRawCallCount = 0;
  int loadMonthGanShenShaRawCallCount = 0;
  int loadMonthZhiGanShenShaRawCallCount = 0;

  @override
  Future<List<dynamic>> loadGanShenShaRaw() async {
    loadGanShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadYearShenShaRaw() async {
    loadYearShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadMonthShenShaRaw() async {
    loadMonthShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadZhiShenShaRaw() async {
    loadZhiShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadJiShenShaRaw() async {
    loadJiShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadXunShenShaRaw() async {
    loadXunShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadYearGanShenShaRaw() async {
    loadYearGanShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadMonthGanShenShaRaw() async {
    loadMonthGanShenShaRawCallCount++;
    return [];
  }
  @override
  Future<List<dynamic>> loadMonthZhiGanShenShaRaw() async {
    loadMonthZhiGanShenShaRawCallCount++;
    return [];
  }
}

class _FakeSchool implements DaLiuRenSchoolDataRepository {
  int queryCallCount = 0;
  final List<String> queryParams = [];

  @override
  Future<List<SchoolEntryContract>> query([Map<String, Object?>? criteria]) async {
    queryCallCount++;
    final schoolId = criteria?['schoolId'] as String? ?? '';
    queryParams.add(schoolId);
    return [];
  }

  @override
  Future<SchoolEntryContract?> get(String id) async {
    return null;
  }
}

class _FakeRecordRepository implements DaliurenRecordRepository {
  @override
  Future<String> put(DaliurenDivinationRecordContract record) async => record.uuid;

  @override
  Future<List<DaliurenDivinationRecordContract>> query([Map<String, Object?>? criteria]) async => const [];

  @override
  Future<DaliurenDivinationRecordContract?> get(String id) async => null;

  @override
  Future<bool> delete(String id) async => true;

  @override
  Stream<List<DaliurenDivinationRecordContract>> watchAll() => Stream.value(const []);
}

// ── Tests ─────────────────────────────────────────────────────────────

void main() {
  test('KetiDataService.loadData parses via fake keti port and uses spy',
      () async {
    final fakeKeti = _FakeKeti();
    final service = KetiDataService(keti: fakeKeti);

    expect(fakeKeti.queryCallCount, 0);

    await service.loadData();
    expect(fakeKeti.queryCallCount, 1);

    // loadData is idempotent, second call returns early.
    await service.loadData();
    expect(fakeKeti.queryCallCount, 1);
  });

  test('DaLiuRenRepositoryImpl.loadDivinationData works via fake official port with spy',
      () async {
    final fakeOfficial = _FakeOfficialData();
    final fakeKeti = _FakeKeti();
    final service = KetiDataService(keti: fakeKeti);

    final calculationService = DaLiuRenCalculationService(
      lunarCalculator: LunarCalculator(),
      tianDiPanCalculator: TianDiPanCalculator(),
      guiRenCalculator: GuiRenCalculator(),
      fourClassCalculator: FourClassCalculator(),
      threeChuanCalculator: ThreeChuanCalculator(),
    );

    final repo = DaLiuRenRepositoryImpl(
      calculationService: calculationService,
      ketiDataService: service,
      officialData: fakeOfficial,
    );

    expect(fakeOfficial.getYudingDataCallCount, 0);
    expect(fakeOfficial.getJuMapperDataCallCount, 0);
    expect(fakeOfficial.getYangPanDataCallCount, 0);
    expect(fakeOfficial.getYinPanDataCallCount, 0);
    expect(fakeKeti.queryCallCount, 0);

    // Initial load
    await repo.loadDivinationData();

    expect(fakeOfficial.getYudingDataCallCount, 1);
    expect(fakeOfficial.getJuMapperDataCallCount, 1);
    expect(fakeOfficial.getYangPanDataCallCount, 1);
    expect(fakeOfficial.getYinPanDataCallCount, 1);
    expect(fakeKeti.queryCallCount, 1);

    // Second load should use cache for official/mapper/keti data,
    // but pan data is reloaded every time in DaLiuRenRepositoryImpl.
    await repo.loadDivinationData();

    expect(fakeOfficial.getYudingDataCallCount, 1);
    expect(fakeOfficial.getJuMapperDataCallCount, 1);
    expect(fakeOfficial.getYangPanDataCallCount, 2);
    expect(fakeOfficial.getYinPanDataCallCount, 2);
    expect(fakeKeti.queryCallCount, 1);
  });

  test('ShenShaDataServiceImpl uses spy/call counter', () async {
    final fakeShenSha = _FakeShenSha();
    final shenShaService = ShenShaDataServiceImpl(shenShaData: fakeShenSha);

    expect(fakeShenSha.loadGanShenShaRawCallCount, 0);
    expect(fakeShenSha.loadYearShenShaRawCallCount, 0);
    expect(fakeShenSha.loadMonthShenShaRawCallCount, 0);
    expect(fakeShenSha.loadZhiShenShaRawCallCount, 0);
    expect(fakeShenSha.loadJiShenShaRawCallCount, 0);
    expect(fakeShenSha.loadXunShenShaRawCallCount, 0);

    // This calls all 6 loader methods internally
    await shenShaService.loadAllShenSha();

    expect(fakeShenSha.loadGanShenShaRawCallCount, 1);
    expect(fakeShenSha.loadYearShenShaRawCallCount, 1);
    expect(fakeShenSha.loadMonthShenShaRawCallCount, 1);
    expect(fakeShenSha.loadZhiShenShaRawCallCount, 1);
    expect(fakeShenSha.loadJiShenShaRawCallCount, 1);
    expect(fakeShenSha.loadXunShenShaRawCallCount, 1);

    // Load again, should use cache and not increment call counts
    await shenShaService.loadAllShenSha();

    expect(fakeShenSha.loadGanShenShaRawCallCount, 1);
    expect(fakeShenSha.loadYearShenShaRawCallCount, 1);
    expect(fakeShenSha.loadMonthShenShaRawCallCount, 1);
    expect(fakeShenSha.loadZhiShenShaRawCallCount, 1);
    expect(fakeShenSha.loadJiShenShaRawCallCount, 1);
    expect(fakeShenSha.loadXunShenShaRawCallCount, 1);
  });

  test('YudingSchool uses spy/call counter and records parameters', () async {
    final fakeSchool = _FakeSchool();
    final yudingSchool = YudingSchool(schoolData: fakeSchool);

    expect(fakeSchool.queryCallCount, 0);
    expect(fakeSchool.queryParams, isEmpty);

    await yudingSchool.loadData();

    expect(fakeSchool.queryCallCount, 1);
    expect(fakeSchool.queryParams, equals(['yuding']));

    // Second call is cached, count remains 1
    await yudingSchool.loadData();
    expect(fakeSchool.queryCallCount, 1);
    expect(fakeSchool.queryParams, equals(['yuding']));
  });

  test('DaliurenStorageDependencies bundle is verified', () async {
    final fakeOfficial = _FakeOfficialData();
    final fakeKeti = _FakeKeti();
    final fakeShenSha = _FakeShenSha();
    final fakeSchool = _FakeSchool();
    final fakeRecord = _FakeRecordRepository();

    final deps = DaliurenStorageDependencies(
      officialData: fakeOfficial,
      keti: fakeKeti,
      shenShaData: fakeShenSha,
      schoolData: fakeSchool,
      recordRepository: fakeRecord,
    );

    // Verify the bundle holds the correct types.
    expect(deps.officialData, isA<DaLiuRenOfficialDataRepository>());
    expect(deps.keti, isA<DaLiuRenKetiRepository>());
    expect(deps.shenShaData, isA<DaLiuRenShenShaDataRepository>());
    expect(deps.schoolData, isA<DaLiuRenSchoolDataRepository>());
    expect(deps.recordRepository, isA<DaliurenRecordRepository>());
  });
}

