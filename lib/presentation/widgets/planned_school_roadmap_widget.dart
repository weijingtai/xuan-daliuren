import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

import 'package:daliuren/domain/schools/school_catalog.dart';

/// Roadmap-style empty state shown when a school is catalog-listed but the
/// data source is still being curated.
///
/// Display contract — see
/// docs/superpowers/specs/2026-05-25-story-7-ui-design-contract.md
/// §"States" (planned row) and §"PlannedSchoolRoadmapWidget":
///  - displayName as title
///  - representativeBook as subtitle
///  - era + tags as chip row
///  - description body
///  - "正在整理中" status badge with tertiary status dot
class PlannedSchoolRoadmapWidget extends StatelessWidget {
  static const String statusLabel = '正在整理中';
  static const String supportingCopy =
      '该流派正在整理中，后续版本将解锁完整解释。当前可继续在御定流派下查看本盘解释。';

  final SchoolCatalogEntry entry;

  PlannedSchoolRoadmapWidget({
    required this.entry,
  }) : super(key: Key('planned_roadmap_${entry.id}'));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tertiary = colorScheme.tertiary;
    final statusText = l10n.schoolStatusPreparing;

    return Semantics(
      container: true,
      label: l10n.schoolRoadmapLabel(entry.displayName, statusText),
      child: Card(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      entry.displayName,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(label: statusText, color: tertiary),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      entry.representativeBook,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    entry.era,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                entry.description,
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.tags
                    .map(
                      (tag) => Chip(
                        label: Text(
                          tag,
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.transparent,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.schoolRoadmapSupporting,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
