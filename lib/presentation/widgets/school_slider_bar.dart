import 'package:flutter/material.dart';

import '../../domain/schools/school_catalog.dart';

/// Horizontally scrollable slider bar that lets the user pick a Da Liu Ren
/// school for the explanation panel.
///
/// The widget is stateless: it renders chips for every [SchoolCatalogEntry]
/// in [schools] (in the order supplied), highlights the one whose `id` matches
/// [selectedSchoolId], and reports user taps through [onChanged]. Planned
/// schools remain interactive — they are visually differentiated (outline +
/// status dot + accessible "正在整理中" label) but never disabled.
///
/// All colors and text styles are read from `Theme.of(context)` so the bar
/// adapts to light / dark themes without hard-coded values.
class SchoolSliderBar extends StatelessWidget {
  /// Catalog entries to render, in display order.
  final List<SchoolCatalogEntry> schools;

  /// The currently selected school's id.
  final String selectedSchoolId;

  /// Invoked with the tapped chip's `id`. Fires for both available and
  /// planned schools.
  final ValueChanged<String> onChanged;

  const SchoolSliderBar({
    super.key,
    required this.schools,
    required this.selectedSchoolId,
    required this.onChanged,
  });

  static const double _chipHeight = 40.0;
  static const double _hitTargetHeight = 48.0;
  static const double _chipSpacing = 8.0;
  static const double _horizontalPadding = 12.0;
  static const double _chipHorizontalPadding = 16.0;
  static const double _chipRadius = 20.0;

  Duration _motionDuration(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < schools.length; i++) ...[
              if (i != 0) const SizedBox(width: _chipSpacing),
              _buildChip(context, schools[i]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, SchoolCatalogEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bool isSelected = entry.id == selectedSchoolId;
    final bool isPlanned = entry.status == SchoolAvailabilityStatus.planned;

    final Color background;
    final Color foreground;
    final Color? borderColor;

    if (isSelected) {
      background = colorScheme.primary;
      foreground = colorScheme.onPrimary;
      borderColor = null;
    } else if (isPlanned) {
      background = colorScheme.surface;
      foreground = colorScheme.onSurfaceVariant;
      borderColor = colorScheme.outlineVariant;
    } else {
      background = colorScheme.surfaceContainerHighest;
      foreground = colorScheme.onSurface;
      borderColor = null;
    }

    final TextStyle labelStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: foreground,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
    );

    final String statusLabel = isPlanned ? '正在整理中' : '当前可用';
    final String semanticsLabel = isSelected
        ? '${entry.displayName}，$statusLabel，已选中'
        : '${entry.displayName}，$statusLabel';

    Widget chip = AnimatedContainer(
      duration: _motionDuration(context),
      curve: Curves.easeOut,
      height: _chipHeight,
      padding: const EdgeInsets.symmetric(horizontal: _chipHorizontalPadding),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(_chipRadius),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: _motionDuration(context),
            curve: Curves.easeOut,
            style: labelStyle,
            child: Text(entry.shortName),
          ),
          if (isPlanned) ...[
            const SizedBox(width: 6),
            _PlannedStatusDot(color: colorScheme.tertiary),
          ],
        ],
      ),
    );

    return Semantics(
      key: Key('school_slider_chip_${entry.id}'),
      button: true,
      selected: isSelected,
      label: semanticsLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_chipRadius),
          ),
          onTap: () => onChanged(entry.id),
          child: SizedBox(
            height: _hitTargetHeight,
            child: Center(
              child: ExcludeSemantics(child: chip),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlannedStatusDot extends StatelessWidget {
  final Color color;

  const _PlannedStatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
