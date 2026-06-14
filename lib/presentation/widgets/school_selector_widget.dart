// lib/presentation/widgets/school_selector_widget.dart

import 'package:flutter/material.dart';
import 'package:daliuren/domain/interfaces/da_liu_ren_school.dart';
import 'package:daliuren/domain/interfaces/school_registry.dart';

/// 流派选择器组件
/// 用于在UI中选择不同的大六壬流派
class SchoolSelectorWidget extends StatefulWidget {
  final String? selectedSchoolId;
  final ValueChanged<String>? onSchoolChanged;
  
  const SchoolSelectorWidget({
    super.key,
    this.selectedSchoolId,
    this.onSchoolChanged,
  });
  
  @override
  State<SchoolSelectorWidget> createState() => _SchoolSelectorWidgetState();
}

class _SchoolSelectorWidgetState extends State<SchoolSelectorWidget> {
  String? _selectedId;
  
  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedSchoolId ?? SchoolRegistry.defaultSchool?.id;
  }
  
  @override
  Widget build(BuildContext context) {
    final schools = SchoolRegistry.all;
    
    if (schools.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '选择流派',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final school = schools[index];
              final isSelected = school.id == _selectedId;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _SchoolCard(
                  school: school,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedId = school.id;
                    });
                    widget.onSchoolChanged?.call(school.id);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 流派卡片组件
class _SchoolCard extends StatelessWidget {
  final DaLiuRenSchool school;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _SchoolCard({
    required this.school,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              school.displayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              school.era,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 4,
              children: school.tags.take(2).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white24 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
