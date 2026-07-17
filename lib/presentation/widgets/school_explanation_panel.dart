import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

import 'package:daliuren/domain/schools/school_catalog.dart';
import 'package:daliuren/presentation/widgets/planned_school_roadmap_widget.dart';

/// Test/debug-only override for forcing the panel into a specific state.
///
/// In production, [SchoolExplanationPanel] derives the state from
/// [SchoolCatalog] and the supplied builders. Tests use this enum to exercise
/// the `empty` and `error` branches without instrumenting the catalog.
enum SchoolPanelStateOverride {
  available,
  planned,
  empty,
  error,
}

/// Routes the divination explanation surface to the correct sub-widget for
/// the currently selected school.
///
/// Dispatch order (per
/// docs/superpowers/specs/2026-05-25-story-7-ui-design-contract.md §States):
///  1. `state == empty`          → empty placeholder (test override only).
///  2. `state == error`          → error placeholder (test override only).
///  3. `selectedSchoolId == 'yuding'` and the school is available
///     → delegate to [availableYudingBuilder] so the formal
///       YuDingDisplayWidget path is preserved. Falls through to a generic
///       fallback when no builder is supplied.
///  4. Catalog status `planned`  → [PlannedSchoolRoadmapWidget].
///  5. Unknown school            → fallback message.
class SchoolExplanationPanel extends StatelessWidget {
  static const String emptyPrimary = '暂无匹配解释';
  static const String emptySecondary = '当前盘面在该流派下未找到匹配条目，可尝试切回御定。';
  static const String errorPrimary = '数据不可用';
  static const String unknownSchoolCopy = '暂无该流派的解释数据。';
  static const String yudingFallbackCopy = '请起盘后查看御定流派解释。';

  final String selectedSchoolId;

  /// Builder for the formal YuDingDisplayWidget. Story 7 Task 38 wires this
  /// up from `DivinationDisplayWidget`. Tests may pass a sentinel widget.
  final WidgetBuilder? availableYudingBuilder;

  /// Optional explicit state override for empty/error coverage. Production
  /// callers should leave this as null; the panel will derive the state from
  /// [SchoolCatalog].
  final SchoolPanelStateOverride? state;

  const SchoolExplanationPanel({
    Key? key,
    required this.selectedSchoolId,
    this.availableYudingBuilder,
    this.state,
  }) : super(key: key ?? const Key('school_explanation_panel'));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 1. Explicit empty override.
    if (state == SchoolPanelStateOverride.empty) {
      return _buildEmpty(context, l10n);
    }

    // 2. Explicit error override.
    if (state == SchoolPanelStateOverride.error) {
      return _buildError(context, l10n);
    }

    final entry = SchoolCatalog.byId(selectedSchoolId);

    // 3. Unknown school id — surface a small, unambiguous fallback.
    if (entry == null) {
      return _buildUnknown(context, l10n);
    }

    // 4. Yuding (available) — protect the formal display path.
    if (entry.id == 'yuding' &&
        entry.status == SchoolAvailabilityStatus.available) {
      final builder = availableYudingBuilder;
      if (builder != null) {
        return Semantics(
          container: true,
          label: l10n.schoolExplanation(entry.displayName),
          child: KeyedSubtree(
            key: const Key('school_panel_available_yuding'),
            child: builder(context),
          ),
        );
      }
      return _buildYudingFallback(context, l10n);
    }

    // 5. Any planned school — show the roadmap empty state.
    if (entry.status == SchoolAvailabilityStatus.planned) {
      return KeyedSubtree(
        key: Key('school_panel_planned_${entry.id}'),
        child: PlannedSchoolRoadmapWidget(entry: entry),
      );
    }

    // 6. Other available schools (future extension) — fall back until the
    // unified entry display is supplied. Keep the surface visible.
    return _buildGenericAvailable(context, entry);
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      liveRegion: true,
      label: l10n.noMatchExplanation,
      child: Padding(
        key: const Key('panel_empty'),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 40, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              l10n.noMatchExplanation,
              style: textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noMatchSecondary,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final reason = l10n.schoolDataLoadFailed(selectedSchoolId);
    return Semantics(
      container: true,
      liveRegion: true,
      label: l10n.dataUnavailable,
      child: Padding(
        key: const Key('panel_error'),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              l10n.dataUnavailable,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reason,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYudingFallback(BuildContext context, AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        l10n.yudingFallback,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildUnknown(BuildContext context, AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        l10n.noSchoolData,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildGenericAvailable(
      BuildContext context, SchoolCatalogEntry entry) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      key: const Key('school_panel_available_generic'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.displayName,
            style: textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            entry.description,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
