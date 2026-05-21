import 'package:flutter/material.dart';
import '../../design/daliuren_colors.dart';
import '../../design/daliuren_spacing.dart';
import '../../design/daliuren_typography.dart';

class CollapsibleSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final double scale;

  const CollapsibleSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.scale = 1.0,
  });

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDivider(),
        SizedBox(height: DaliurenSpacing.lg * widget.scale),
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(DaliurenSpacing.md * widget.scale),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DaliurenSpacing.xs * widget.scale,
              vertical: DaliurenSpacing.xs * widget.scale,
            ),
            child: Row(
              children: [
                Container(
                  width: 3 * widget.scale,
                  height: 16 * widget.scale,
                  decoration: BoxDecoration(
                    color: DaliurenColors.sealRed.withValues(alpha: .6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: DaliurenSpacing.md * widget.scale),
                Expanded(
                  child: Text(
                    widget.title,
                    style: DaliurenTypography.h3(widget.scale),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20 * widget.scale,
                    color: DaliurenColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.only(
                top: DaliurenSpacing.md * widget.scale),
            child: widget.child,
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            DaliurenColors.dividerGradient,
            DaliurenColors.dividerGradient,
            Colors.transparent,
          ],
          stops: const [0, .3, .7, 1],
        ),
      ),
    );
  }
}