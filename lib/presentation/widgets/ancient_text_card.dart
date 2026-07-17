import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:theme/theme.dart';
import '../../data/models/yu_ding_da_liu_ren_data_model.dart';
import '../../design/daliuren_colors.dart';
import '../../design/daliuren_spacing.dart';
import '../../design/daliuren_typography.dart';

class AncientTextCard extends StatelessWidget {
  final YuDingDaLiuRenDataModel yuDing;
  final double scale;

  const AncientTextCard({
    super.key,
    required this.yuDing,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = XuanThemeData.maybeOf(context)?.component('daliuren_ancient_text_card');
    final bg = style?.background ?? DaliurenColors.paper;
    final borderColor = style?.border?.color ?? DaliurenColors.ink.withValues(alpha: .12);
    final sealBg = style?.border?.color ?? DaliurenColors.sealRed.withValues(alpha: .85);
    final radius = style?.radius != null ? BorderRadius.all(Radius.circular(style!.radius!)) : BorderRadius.circular(DaliurenSpacing.xl * scale);
    final shadow = style?.shadow;
    final labelColor = style?.border?.color != null
        ? style!.border!.color.withValues(alpha: .8)
        : DaliurenColors.sealRed.withValues(alpha: .8);
    final highlightColor = style?.border?.color != null
        ? style!.border!.color.withValues(alpha: .9)
        : DaliurenColors.sealRed.withValues(alpha: .9);

    return Card(
      elevation: shadow != null ? null : 2,
      color: bg,
      shadowColor: shadow?.color,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(DaliurenSpacing.xl * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleRow(sealBg, l10n),
            _buildDivider(),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildBody(highlightColor),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildParagraph(l10n.keYi, yuDing.meaning, labelColor, highlightColor),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildParagraph(l10n.jieYue, yuDing.explain, labelColor, highlightColor),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildParagraph(l10n.duanYue, yuDing.predication, labelColor, highlightColor),
            if (yuDing.details.isNotEmpty) ...[
              SizedBox(height: DaliurenSpacing.lg * scale),
              _buildDivider(),
              SizedBox(height: DaliurenSpacing.lg * scale),
              ...yuDing.details.entries.map((e) => Padding(
                    padding: EdgeInsets.only(
                        bottom: DaliurenSpacing.md * scale),
                    child: _buildParagraph(e.key, e.value, labelColor, highlightColor),
                  )),
            ],
            if (yuDing.books.isNotEmpty) ...[
              SizedBox(height: DaliurenSpacing.lg * scale),
              _buildDivider(),
              SizedBox(height: DaliurenSpacing.lg * scale),
              ...yuDing.books.entries.map((e) => Padding(
                    padding: EdgeInsets.only(
                        bottom: DaliurenSpacing.md * scale),
                    child: _buildParagraph(e.key, e.value, labelColor, highlightColor),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(Color sealBg, AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          width: DaliurenSpacing.xxl * scale,
          height: DaliurenSpacing.xxl * scale,
          decoration: BoxDecoration(
            color: sealBg,
            borderRadius: BorderRadius.circular(DaliurenSpacing.xs),
          ),
          alignment: Alignment.center,
          child: Text(
            l10n.ancientTextSeal,
            style: DaliurenTypography.tag(scale).copyWith(color: Colors.white, fontSize: 16 * scale),
          ),
        ),
        SizedBox(width: DaliurenSpacing.md * scale),
        Expanded(
          child: Text(
            l10n.ancientTextTitle(yuDing.dayJiaZi.name, _chineseNumber(yuDing.juNumber, l10n), yuDing.juName.name),
            style: DaliurenTypography.h2(scale),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(Color highlightColor) {
    return _highlightedText(yuDing.body.join(" "),
        style: DaliurenTypography.body(scale).copyWith(fontWeight: FontWeight.bold),
        highlightColor: highlightColor);
  }

  Widget _buildParagraph(String label, String text, Color labelColor, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label：",
          style: DaliurenTypography.h3(scale)
              .copyWith(color: labelColor),
        ),
        SizedBox(height: DaliurenSpacing.xs * scale),
        _highlightedText(text, style: DaliurenTypography.body(scale), highlightColor: highlightColor),
      ],
    );
  }

  Widget _highlightedText(String text, {required TextStyle style, Color? highlightColor}) {
    final parts = _parseHighlight(text);
    final hColor = highlightColor ?? DaliurenColors.sealRed.withValues(alpha: .9);
    return RichText(
      text: TextSpan(
        style: style,
        children: parts.map((p) {
          if (p.isHighlight) {
            return TextSpan(
              text: p.text,
              style: style.copyWith(
                color: hColor,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return TextSpan(text: p.text);
        }).toList(),
      ),
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

  String _chineseNumber(int n, AppLocalizations l10n) {
    const mapper = {
      1: '一', 2: '二', 3: '三', 4: '四', 5: '五',
      6: '六', 7: '七', 8: '八', 9: '九', 10: '十',
      11: '十一', 12: '十二'
    };
    return '${mapper[n] ?? n}${l10n.chineseNumberUnit}';
  }

  static const _highlightPatterns = ['吉', '凶', '利', '害', '宜', '忌', '克',
    '生', '合', '冲', '刑', '害', '破', '败', '成', '得', '失', '祸', '福'];

  List<_TextPart> _parseHighlight(String text) {
    if (text.isEmpty) return [_TextPart(text, false)];
    final parts = <_TextPart>[];
    int i = 0;
    while (i < text.length) {
      final substr = text.substring(i);
      bool matched = false;
      for (final key in _highlightPatterns) {
        if (substr.startsWith(key)) {
          parts.add(_TextPart(key, true));
          i += key.length;
          matched = true;
          break;
        }
      }
      if (!matched) {
        int end = i + 1;
        while (end < text.length) {
          final between = text.substring(i, end + 1);
          bool willMatch = false;
          for (final key in _highlightPatterns) {
            if (between.contains(key)) {
              willMatch = true;
              break;
            }
          }
          if (willMatch) break;
          end++;
        }
        parts.add(_TextPart(text.substring(i, end), false));
        i = end;
      }
    }
    return parts;
  }
}

class _TextPart {
  final String text;
  final bool isHighlight;
  _TextPart(this.text, this.isHighlight);
}