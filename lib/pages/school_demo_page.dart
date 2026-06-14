// lib/pages/school_demo_page.dart

import 'package:flutter/material.dart';
import 'package:daliuren/domain/interfaces/school_entry.dart';
import 'package:daliuren/domain/interfaces/school_registry.dart';
import 'package:daliuren/presentation/widgets/school_selector_widget.dart';
import 'package:daliuren/presentation/widgets/school_entry_display_widget.dart';

/// 流派演示页面
/// 展示如何使用多流派功能
class SchoolDemoPage extends StatefulWidget {
  const SchoolDemoPage({super.key});
  
  @override
  State<SchoolDemoPage> createState() => _SchoolDemoPageState();
}

class _SchoolDemoPageState extends State<SchoolDemoPage> {
  String? _selectedSchoolId;
  List<SchoolEntry> _entries = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _selectedSchoolId = SchoolRegistry.defaultSchool?.id;
    _loadEntries();
  }
  
  Future<void> _loadEntries() async {
    if (_selectedSchoolId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final school = SchoolRegistry.get(_selectedSchoolId!);
      if (school != null) {
        // 加载甲子日的条目作为示例
        final entries = await school.getEntriesByDay('甲子');
        setState(() {
          _entries = entries;
        });
      }
    } catch (e) {
      debugPrint('加载条目失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('大六壬流派演示'),
      ),
      body: Column(
        children: [
          // 流派选择器
          SchoolSelectorWidget(
            selectedSchoolId: _selectedSchoolId,
            onSchoolChanged: (schoolId) {
              setState(() {
                _selectedSchoolId = schoolId;
              });
              _loadEntries();
            },
          ),
          
          // 流派信息
          if (_selectedSchoolId != null) _buildSchoolInfo(),
          
          // 条目列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                    ? const Center(child: Text('暂无数据'))
                    : _buildEntryList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSchoolInfo() {
    final school = SchoolRegistry.get(_selectedSchoolId!);
    if (school == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            school.displayName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            school.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '代表书籍：${school.representativeBook}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '年代：${school.era}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: school.tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Colors.blue[50],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEntryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        return SchoolEntryDisplayWidget(
          entry: _entries[index],
          showDetails: true,
          showBookReferences: true,
        );
      },
    );
  }
}
