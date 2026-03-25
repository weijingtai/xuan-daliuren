import 'package:flutter/material.dart';
import 'package:common/enums.dart';
import 'package:daliuren/domain/entities/shen_sha_entity.dart';

class ShenShaDisplayWidget extends StatefulWidget {
  final Map<DiZhi, List<ShenShaResult>>? shenShaResults;

  const ShenShaDisplayWidget({Key? key, this.shenShaResults}) : super(key: key);

  @override
  State<ShenShaDisplayWidget> createState() => _ShenShaDisplayWidgetState();
}

class _ShenShaDisplayWidgetState extends State<ShenShaDisplayWidget> {
  int _viewIndex = 0; // 0 = by type, 1 = by position

  List<ShenShaResult> get _allResults =>
      widget.shenShaResults?.values.expand((list) => list).toList() ?? [];

  static const List<String> _typeOrder = ['干煞', '年煞', '月煞', '支煞', '季煞', '旬煞'];

  Map<String, List<ShenShaResult>> get _groupedByType {
    final map = <String, List<ShenShaResult>>{};
    for (final type in _typeOrder) {
      map[type] = [];
    }
    for (final r in _allResults) {
      final type = r.shenSha.type;
      map.putIfAbsent(type, () => []);
      map[type]!.add(r);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shenShaResults == null || widget.shenShaResults!.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalCount = _allResults.length;
    if (totalCount == 0) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Text('神煞',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('($totalCount)',
                    style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                // View toggle
                ToggleButtons(
                  isSelected: [_viewIndex == 0, _viewIndex == 1],
                  onPressed: (i) => setState(() => _viewIndex = i),
                  borderRadius: BorderRadius.circular(8),
                  constraints: const BoxConstraints(minHeight: 30, minWidth: 60),
                  textStyle: const TextStyle(fontSize: 12),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('按类型'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('按宫位'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            // Content
            _viewIndex == 0
                ? _buildByTypeView(context)
                : _buildByPositionView(context),
          ],
        ),
      ),
    );
  }

  // ==================== View 1: By Type ====================

  Widget _buildByTypeView(BuildContext context) {
    final grouped = _groupedByType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _typeOrder
          .where((type) => grouped[type]!.isNotEmpty)
          .map((type) => _buildTypeSection(context, type, grouped[type]!))
          .toList(),
    );
  }

  Widget _buildTypeSection(
      BuildContext context, String type, List<ShenShaResult> results) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _typeColor(type).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(type,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _typeColor(type))),
                const SizedBox(width: 6),
                Text('(${results.length})',
                    style: TextStyle(
                        fontSize: 11, color: _typeColor(type).withOpacity(0.7))),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Shen sha list
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: results.map((r) => _buildShenShaChip(context, r, showLocation: true)).toList(),
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case '干煞':
        return Colors.purple;
      case '年煞':
        return Colors.blue;
      case '月煞':
        return Colors.teal;
      case '支煞':
        return Colors.orange;
      case '季煞':
        return Colors.brown;
      case '旬煞':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  // ==================== View 2: By Position ====================

  Widget _buildByPositionView(BuildContext context) {
    final diZhiOrder = DiZhi.values;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.75,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: diZhiOrder.length,
      itemBuilder: (context, index) {
        final diZhi = diZhiOrder[index];
        final results = widget.shenShaResults![diZhi] ?? [];
        return _buildPositionCell(context, diZhi, results);
      },
    );
  }

  Widget _buildPositionCell(
      BuildContext context, DiZhi diZhi, List<ShenShaResult> results) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: results.isEmpty ? Colors.grey.shade50 : Colors.white,
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              diZhi.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(height: 2),
          if (results.isEmpty)
            const Expanded(
                child: Center(
                    child: Text('-',
                        style: TextStyle(color: Colors.grey, fontSize: 12))))
          else
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children:
                      results.map((r) => _buildShenShaChip(context, r, showType: true)).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== Shared Components ====================

  Widget _buildShenShaChip(BuildContext context, ShenShaResult result,
      {bool showLocation = false, bool showType = false}) {
    final jiXiongName = result.shenSha.jiXiong.name;
    Color chipColor;
    Color textColor;
    if (jiXiongName == '吉') {
      chipColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
    } else if (jiXiongName == '凶') {
      chipColor = Colors.red.shade50;
      textColor = Colors.red.shade800;
    } else {
      chipColor = Colors.grey.shade100;
      textColor = Colors.grey.shade700;
    }

    final label = StringBuffer(result.shenSha.name);
    if (showLocation) {
      label.write(' @${result.location.name}');
    }

    final tooltipLines = <String>[
      '${result.shenSha.name} ($jiXiongName)',
      '类型: ${result.shenSha.type}',
      '位置: ${result.location.name}',
    ];
    if (result.shenSha.descriptionList.isNotEmpty) {
      tooltipLines.add(result.shenSha.descriptionList.first);
    }

    return Tooltip(
      message: tooltipLines.join('\n'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Text(
          label.toString(),
          style: TextStyle(fontSize: 11, color: textColor),
        ),
      ),
    );
  }
}
