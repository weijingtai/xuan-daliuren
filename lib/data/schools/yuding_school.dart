// lib/data/schools/yuding_school.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:daliuren/domain/interfaces/da_liu_ren_school.dart';
import 'package:daliuren/domain/interfaces/school_entry.dart';

/// 御定大六壬流派实现
/// 这是第一个实现的流派，作为示例
class YudingSchool implements DaLiuRenSchool {
  List<Map<String, dynamic>>? _rawData;
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
      final jsonString = await rootBundle.loadString(
        'packages/daliuren/assets/da_liu_ren/御定大六壬.json'
      );
      final decoded = jsonDecode(jsonString);
      _rawData = List<Map<String, dynamic>>.from(
        (decoded as List).map((item) => Map<String, dynamic>.from(item))
      );
      _isLoaded = true;
    } catch (e) {
      _rawData = [];
      _isLoaded = true;
    }
  }
  
  @override
  Future<List<SchoolEntry>> matchEntries(String dayJiaZi, String juName) async {
    if (!_isLoaded) await loadData();
    
    final matches = _rawData?.where((item) {
      return item['dayJiaZi'] == dayJiaZi && item['juName'] == juName;
    }).toList() ?? [];
    
    return matches.map((item) => YudingEntry.fromMap(item)).toList();
  }
  
  @override
  Future<List<SchoolEntry>> getEntriesByDay(String dayJiaZi) async {
    if (!_isLoaded) await loadData();
    
    final matches = _rawData?.where((item) {
      return item['dayJiaZi'] == dayJiaZi;
    }).toList() ?? [];
    
    return matches.map((item) => YudingEntry.fromMap(item)).toList();
  }
  
  @override
  Future<int> get entryCount async {
    if (!_isLoaded) await loadData();
    return _rawData?.length ?? 0;
  }
  
  @override
  Future<List<String>> get supportedDays async {
    if (!_isLoaded) await loadData();
    
    final days = <String>{};
    _rawData?.forEach((item) {
      if (item['dayJiaZi'] != null) {
        days.add(item['dayJiaZi'] as String);
      }
    });
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
  
  /// 从JSON Map创建实例
  factory YudingEntry.fromMap(Map<String, dynamic> map) {
    return YudingEntry(
      title: '${map['dayJiaZi'] ?? ''}日第${map['juNumber'] ?? ''}局干上${map['juName'] ?? ''}',
      dayJiaZi: map['dayJiaZi'] ?? '',
      juName: map['juName'] ?? '',
      juNumber: map['juNumber'] ?? 0,
      keTiNames: List<String>.from(map['body'] ?? []),
      meaning: map['meaning'] ?? '',
      explanation: map['explain'] ?? '',
      prediction: map['predication'] ?? '',
      details: Map<String, String>.from(map['details'] ?? {}),
      bookReferences: Map<String, String>.from(map['books'] ?? {}),
    );
  }
}
