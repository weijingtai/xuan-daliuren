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
  int loadYuDingDataCallCount = 0;
  int loadJuMapperDataCallCount = 0;
  int loadYangPanDataCallCount = 0;
  int loadYinPanDataCallCount = 0;

  @override
  Future<List<dynamic>> loadYuDingData() async {
    loadYuDingDataCallCount++;
    return [
      {'dayJiaZi': '甲子', 'juNumber': 1, 'juName': 'test_ju', 'body': []}
    ];
  }

  @override
  Future<Map<String, dynamic>> loadJuMapperData() async {
    loadJuMapperDataCallCount++;
    return {'甲子': 1};
  }

  @override
  Future<List<Map<String, dynamic>>> loadYangPanData() async {
    loadYangPanDataCallCount++;
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> loadYinPanData() async {
    loadYinPanDataCallCount++;
    return [];
  }
}

class _FakeKeti implements DaLiuRenKetiRepository {
  int loadKetiDataCallCount = 0;

  @override
  Future<List<dynamic>> loadKetiData() async {
    loadKetiDataCallCount++;
    return [
      {'id': 1, 'name': '伏吟'},
    ];
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
  int loadEntriesCallCount = 0;
  final List<String> loadEntriesParams = [];

  @override
  Future<List<SchoolEntryContract>> loadEntries(String schoolId) async {
    loadEntriesCallCount++;
    loadEntriesParams.add(schoolId);
    return [];
  }
}

class _FakeRecordRepository implements DaliurenRecordRepository {
  @override
  Future<String> saveRecord(DaliurenDivinationRecordContract record) async => record.uuid;

  @override
  Future<List<DaliurenDivinationRecordContract>> getAllRecords() async => const [];

  @override
  Future<DaliurenDivinationRecordContract?> getRecordByUuid(String uuid) async => null;

  @override
  Future<bool> softDeleteRecord(String uuid) async => true;

  @override
  Stream<List<DaliurenDivinationRecordContract>> watchAllRecords() => Stream.value(const []);
}

// ── Tests ─────────────────────────────────────────────────────────────

void main() {
  test('KetiDataService.loadData parses via fake keti port and uses spy',
      () async {
    final fakeKeti = _FakeKeti();
    final service = KetiDataService(keti: fakeKeti);

    expect(fakeKeti.loadKetiDataCallCount, 0);

    await service.loadData();
    expect(fakeKeti.loadKetiDataCallCount, 1);

    // loadData is idempotent, second call returns early.
    await service.loadData();
    expect(fakeKeti.loadKetiDataCallCount, 1);
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

    expect(fakeOfficial.loadYuDingDataCallCount, 0);
    expect(fakeOfficial.loadJuMapperDataCallCount, 0);
    expect(fakeOfficial.loadYangPanDataCallCount, 0);
    expect(fakeOfficial.loadYinPanDataCallCount, 0);
    expect(fakeKeti.loadKetiDataCallCount, 0);

    // Initial load
    await repo.loadDivinationData();

    expect(fakeOfficial.loadYuDingDataCallCount, 1);
    expect(fakeOfficial.loadJuMapperDataCallCount, 1);
    expect(fakeOfficial.loadYangPanDataCallCount, 1);
    expect(fakeOfficial.loadYinPanDataCallCount, 1);
    expect(fakeKeti.loadKetiDataCallCount, 1);

    // Second load should use cache for official/mapper/keti data,
    // but pan data is reloaded every time in DaLiuRenRepositoryImpl.
    await repo.loadDivinationData();

    expect(fakeOfficial.loadYuDingDataCallCount, 1);
    expect(fakeOfficial.loadJuMapperDataCallCount, 1);
    expect(fakeOfficial.loadYangPanDataCallCount, 2);
    expect(fakeOfficial.loadYinPanDataCallCount, 2);
    expect(fakeKeti.loadKetiDataCallCount, 1);
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

    expect(fakeSchool.loadEntriesCallCount, 0);
    expect(fakeSchool.loadEntriesParams, isEmpty);

    await yudingSchool.loadData();

    expect(fakeSchool.loadEntriesCallCount, 1);
    expect(fakeSchool.loadEntriesParams, equals(['yuding']));

    // Second call is cached, count remains 1
    await yudingSchool.loadData();
    expect(fakeSchool.loadEntriesCallCount, 1);
    expect(fakeSchool.loadEntriesParams, equals(['yuding']));
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

