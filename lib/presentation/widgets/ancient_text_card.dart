import 'package:flutter/material.dart';
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
    return Card(
      elevation: 2,
      color: DaliurenColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DaliurenSpacing.xl * scale),
        side: BorderSide(color: DaliurenColors.ink.withValues(alpha: .12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(DaliurenSpacing.xl * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleRow(),
            _buildDivider(),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildBody(),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildParagraph("课义", yuDing.meaning),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildParagraph("解曰", yuDing.explain),
            SizedBox(height: DaliurenSpacing.lg * scale),
            _buildParagraph("断曰", yuDing.predication),
            if (yuDing.details.isNotEmpty) ...[
              SizedBox(height: DaliurenSpacing.lg * scale),
              _buildDivider(),
              SizedBox(height: DaliurenSpacing.lg * scale),
              ...yuDing.details.entries.map((e) => Padding(
                    padding: EdgeInsets.only(
                        bottom: DaliurenSpacing.md * scale),
                    child: _buildParagraph(e.key, e.value),
                  )),
            ],
            if (yuDing.books.isNotEmpty) ...[
              SizedBox(height: DaliurenSpacing.lg * scale),
              _buildDivider(),
              SizedBox(height: DaliurenSpacing.lg * scale),
              ...yuDing.books.entries.map((e) => Padding(
                    padding: EdgeInsets.only(
                        bottom: DaliurenSpacing.md * scale),
                    child: _buildParagraph(e.key, e.value),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Container(
          width: DaliurenSpacing.xxl * scale,
          height: DaliurenSpacing.xxl * scale,
          decoration: BoxDecoration(
            color: DaliurenColors.sealRed.withValues(alpha: .85),
            borderRadius: BorderRadius.circular(DaliurenSpacing.xs),
          ),
          alignment: Alignment.center,
          child: Text(
            "典",
            style: DaliurenTypography.tag(scale).copyWith(color: Colors.white, fontSize: 16 * scale),
          ),
        ),
        SizedBox(width: DaliurenSpacing.md * scale),
        Expanded(
          child: Text(
            "${yuDing.dayJiaZi.name}日 第${_chineseNumber(yuDing.juNumber)} 干上${yuDing.juName.name}",
            style: DaliurenTypography.h2(scale),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return _highlightedText(yuDing.body.join(" "),
        style: DaliurenTypography.body(scale).copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildParagraph(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label：",
          style: DaliurenTypography.h3(scale)
              .copyWith(color: DaliurenColors.sealRed.withValues(alpha: .8)),
        ),
        SizedBox(height: DaliurenSpacing.xs * scale),
        _highlightedText(text, style: DaliurenTypography.body(scale)),
      ],
    );
  }

  Widget _highlightedText(String text, {required TextStyle style}) {
    final parts = _parseHighlight(text);
    return RichText(
      text: TextSpan(
        style: style,
        children: parts.map((p) {
          if (p.isHighlight) {
            return TextSpan(
              text: p.text,
              style: style.copyWith(
                color: DaliurenColors.sealRed.withValues(alpha: .9),
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

  String _chineseNumber(int n) {
    const mapper = {
      1: '一', 2: '二', 3: '三', 4: '四', 5: '五',
      6: '六', 7: '七', 8: '八', 9: '九', 10: '十',
      11: '十一', 12: '十二'
    };
    return '${mapper[n] ?? n}局';
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