import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import '../../design/daliuren_colors.dart';
import '../../design/daliuren_spacing.dart';
import '../../design/daliuren_typography.dart';

class SemanticChip extends StatelessWidget {
  final String label;
  final ChipSemantic semantic;
  final double scale;
  final VoidCallback? onTap;

  const SemanticChip({
    super.key,
    required this.label,
    this.semantic = ChipSemantic.neutral,
    this.scale = 1.0,
    this.onTap,
  });

 Color get _bgColor => switch (semantic) {
 ChipSemantic.auspicious => DaliurenColors.auspicious(DaliurenOpacity.bg()),
 ChipSemantic.inauspicious => DaliurenColors.inauspicious(DaliurenOpacity.bg()),
 ChipSemantic.neutral => DaliurenColors.neutral(DaliurenOpacity.bg()),
 ChipSemantic.highlight => DaliurenColors.sealRedLight,
 };

 Color get _textColor => switch (semantic) {
 ChipSemantic.auspicious => DaliurenColors.auspicious(DaliurenOpacity.text()),
 ChipSemantic.inauspicious => DaliurenColors.inauspicious(DaliurenOpacity.text()),
 ChipSemantic.neutral => DaliurenColors.neutral(DaliurenOpacity.text()),
 ChipSemantic.highlight => DaliurenColors.sealRed,
 };

 Color get _borderColor => switch (semantic) {
 ChipSemantic.auspicious =>
 DaliurenColors.auspicious(DaliurenOpacity.border()),
 ChipSemantic.inauspicious =>
 DaliurenColors.inauspicious(DaliurenOpacity.border()),
 ChipSemantic.neutral => DaliurenColors.neutral(DaliurenOpacity.border()),
 ChipSemantic.highlight => DaliurenColors.sealRedBorder,
 };

  @override
  Widget build(BuildContext context) {
    final style = XuanThemeData.maybeOf(context)?.component('daliuren_semantic_chip');
    final variant = style?.variant(semantic == ChipSemantic.auspicious ? 'auspicious'
        : semantic == ChipSemantic.inauspicious ? 'inauspicious'
        : semantic == ChipSemantic.highlight ? 'highlight' : 'neutral');
    final bg = variant?.background ?? _bgColor;
    final textC = variant?.border?.color ?? _textColor;
    final borderC = variant?.border?.color ?? _borderColor;
    final radius = style?.radius ?? DaliurenSpacing.xs * scale;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: DaliurenSpacing.md * scale,
            vertical: 3 * scale,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderC, width: 1),
          ),
          child: Text(label, style: DaliurenTypography.tag(scale).copyWith(color: textC)),
        ),
      ),
    );
  }
}

enum ChipSemantic { auspicious, inauspicious, neutral, highlight }