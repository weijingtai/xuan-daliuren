// lib/presentation/widgets/school_entry_display_widget.dart

import 'package:flutter/material.dart';
import 'package:xuan_common_ui/xuan_common_ui.dart';
import 'package:daliuren/domain/interfaces/school_entry.dart';

/// 通用流派条目显示组件
/// 可以显示任何实现了 SchoolEntry 接口的条目
class SchoolEntryDisplayWidget extends StatelessWidget {
  final SchoolEntry entry;
  final bool showDetails;
  final bool showBookReferences;
  
  const SchoolEntryDisplayWidget({
    super.key,
    required this.entry,
    this.showDetails = true,
    this.showBookReferences = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return XuanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和流派标签
          _buildHeader(context),
          const XuanDivider.horizontal(),
            
            // 课体名称
            if (entry.keTiNames.isNotEmpty) ...[
              _buildKeTiSection(context),
              const SizedBox(height: 12),
            ],
            
            // 课义
            _buildSection(
              context,
              '课义',
              entry.meaning,
            ),
            const SizedBox(height: 12),
            
            // 解曰
            _buildSection(
              context,
              '解曰',
              entry.explanation,
            ),
            const SizedBox(height: 12),
            
            // 断曰
            _buildSection(
              context,
              '断曰',
              entry.prediction,
            ),
            
            // 杂占详情
            if (showDetails && entry.details.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildDetailsSection(context),
            ],
            
            // 经典引用
            if (showBookReferences && entry.bookReferences.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildBookReferencesSection(context),
            ],
          ],
        ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            entry.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            entry.schoolId,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildKeTiSection(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: entry.keTiNames.map((name) {
        return Chip(
          label: Text(
            name,
            style: const TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.blue[50],
          padding: const EdgeInsets.symmetric(horizontal: 4),
        );
      }).toList(),
    );
  }
  
  Widget _buildSection(BuildContext context, String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title：',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '杂占：',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...entry.details.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    '${e.key}：',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(e.value),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildBookReferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '经典引用：',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...entry.bookReferences.entries.map((e) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e.value,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
