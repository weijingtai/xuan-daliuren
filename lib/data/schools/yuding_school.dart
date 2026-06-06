// lib/data/schools/yuding_school.dart

import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:daliuren/domain/interfaces/da_liu_ren_school.dart';
import 'package:daliuren/domain/interfaces/school_entry.dart';

/// 御定大六壬流派实现
/// 这是第一个实现的流派，作为示例
class YudingSchool implements DaLiuRenSchool {
  final DaLiuRenSchoolDataRepository schoolData;
  YudingSchool({required this.schoolData});

  List<SchoolEntryContract>? _entries;
  bool _isLoaded = false;
  
  @override
  String get id => 'yuding';
  
  @override
  String get displayName => '御定大六壬';
  
  @override
  String get description => '清代康熙年间宫廷编撰的官方大六壬版本，体系最为完整规范';
  
  @override
  String get representativeBook => '《御定大六壬直指》';
  
  @override
  List<String> get tags => ['官方', '规范', '完整', '清代'];
  
  @override
  String get era => '清代';
  
  @override
  bool get isLoaded => _isLoaded;
  
  @override
  Future<void> loadData() async {
    if (_isLoaded) return;
    try {
      _entries = await schoolData.loadEntries('yuding');
      _isLoaded = true;
    } catch (e) {
      _entries = const [];
      _isLoaded = true;
    }
  }
  
  @override
  Future<List<SchoolEntry>> matchEntries(String dayJiaZi, String juName) async {
    if (!_isLoaded) await loadData();
    return (_entries ?? const [])
        .where((e) => e.dayJiaZi == dayJiaZi && e.juName == juName)
        .map(YudingEntry.fromContract)
        .toList();
  }
  
  @override
  Future<List<SchoolEntry>> getEntriesByDay(String dayJiaZi) async {
    if (!_isLoaded) await loadData();
    return (_entries ?? const [])
        .where((e) => e.dayJiaZi == dayJiaZi)
        .map(YudingEntry.fromContract)
        .toList();
  }
  
  @override
  Future<int> get entryCount async {
    if (!_isLoaded) await loadData();
    return _entries?.length ?? 0;
  }
  
  @override
  Future<List<String>> get supportedDays async {
    if (!_isLoaded) await loadData();
    final days = <String>{};
    for (final e in (_entries ?? const [])) {
      if (e.dayJiaZi.isNotEmpty) days.add(e.dayJiaZi);
    }
    return days.toList();
  }
}

/// 御定六壬条目实现
class YudingEntry implements SchoolEntry {
  @override
  final String title;
  @override
  final String dayJiaZi;
  @override
  final String juName;
  @override
  final int juNumber;
  @override
  final List<String> keTiNames;
  @override
  final String meaning;
  @override
  final String explanation;
  @override
  final String prediction;
  @override
  final Map<String, String> details;
  @override
  final Map<String, String> bookReferences;
  
  @override
  String get schoolId => 'yuding';
  
  const YudingEntry({
    required this.title,
    required this.dayJiaZi,
    required this.juName,
    required this.juNumber,
    required this.keTiNames,
    required this.meaning,
    required this.explanation,
    required this.prediction,
    required this.details,
    required this.bookReferences,
  });

  factory YudingEntry.fromContract(SchoolEntryContract c) {
    return YudingEntry(
      title: c.title,
      dayJiaZi: c.dayJiaZi,
      juName: c.juName,
      juNumber: c.juNumber,
      keTiNames: c.keTiNames,
      meaning: c.meaning,
      explanation: c.explanation,
      prediction: c.prediction,
      details: c.details,
      bookReferences: c.bookReferences,
    );
  }
}
