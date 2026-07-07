import 'package:flutter/widgets.dart';
import 'package:daliuren/presentation/models/wang_shuai_config.dart';

/// 宫格内单个符号的旺衰 badge（仿奇门遁甲 _buildWangShuaiWidget 模式）
///
/// 显示两个小 badge：[宫内旺衰] + [月令旺衰]，紧凑排列。
class WangShuaiBadge extends StatelessWidget {
  const WangShuaiBadge({
    super.key,
    required this.hint,
    required this.visible,
    this.fontSize = 8,
    this.badgeHeight = 12,
    this.badgeWidth = 14,
    this.borderRadius = 3,
  });

  final WangShuaiHint hint;
  final bool visible;
  final double fontSize;
  final double badgeHeight;
  final double badgeWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!visible || !hint.hasData) {
      return SizedBox(height: 0, width: 0);
    }

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        height: badgeHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hint.gongLabel != null)
              _badge(
                text: _truncateLabel(hint.gongLabel!),
                colorHex: hint.gongColorHex,
                isFirst: true,
                isLast: hint.monthLabel == null,
              ),
            if (hint.monthLabel != null)
              _badge(
                text: _truncateLabel(hint.monthLabel!),
                colorHex: hint.monthColorHex,
                isFirst: false,
                isLast: true,
              ),
          ],
        ),
      ),
    );
  }

  String _truncateLabel(String label) {
    // "帝旺" → "帝", "长生" → "长", "墓库" → "墓"
    if (label.length > 1) return label.substring(0, 1);
    return label;
  }

  Widget _badge({
    required String text,
    String? colorHex,
    required bool isFirst,
    required bool isLast,
  }) {
    final color = colorHex != null
        ? Color(int.parse(colorHex))
        : const Color(0xFF888780);

    return Container(
      height: badgeHeight,
      width: badgeWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(borderRadius) : Radius.zero,
          bottomLeft: isFirst ? Radius.circular(borderRadius) : Radius.zero,
          topRight: isLast ? Radius.circular(borderRadius) : Radius.zero,
          bottomRight: isLast ? Radius.circular(borderRadius) : Radius.zero,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          height: 1.0,
        ),
      ),
    );
  }
}
