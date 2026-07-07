import 'package:flutter/widgets.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:theme/const_resources_mapper.dart';
import 'package:daliuren/design/daliuren_colors.dart';
import 'package:daliuren/design/daliuren_spacing.dart';
import 'package:daliuren/design/daliuren_typography.dart';
import 'package:daliuren/model/da_liu_ren_gong.dart';
import 'package:daliuren/presentation/models/wang_shuai_config.dart';
import 'package:daliuren/presentation/widgets/gong_hint_mapper.dart';
import 'package:daliuren/presentation/widgets/wang_shuai_badge.dart';

/// 大六壬宫格单元格 Widget
///
/// 每个宫格独立渲染天将、天盘支、天干、地盘支四个符号，
/// 各自显示自己的旺衰 hint（月令旺衰 + 宫内十二长生）。
class GongCellWidget extends StatelessWidget {
  const GongCellWidget({
    super.key,
    required this.diZhi,
    required this.gong,
    this.showWangShuai = false,
    this.monthJiaZi,
    this.wangShuaiConfig = const WangShuaiConfig(),
    this.scale = 1.0,
  });

  /// 地盘地支（宫位标识）
  final DiZhi diZhi;

  /// 宫格数据
  final DaLiuRenGong gong;

  /// 是否显示旺衰 hint
  final bool showWangShuai;

  /// 月柱干支（旺衰计算必需）
  final JiaZi? monthJiaZi;

  /// 旺衰显示配置
  final WangShuaiConfig wangShuaiConfig;

  /// 缩放比例
  final double scale;

  @override
  Widget build(BuildContext context) {
    final sf = scale;
    final skyDiZhi = gong.skyPanDiZhi;
    final groundDiZhi = gong.groundPanDiZhi;
    final tianGan = gong.tianGan;

    final showWs = showWangShuai && monthJiaZi != null;
    final wsResult = showWs
        ? GongHintMapper.map(
            diZhi: diZhi,
            gong: gong,
            monthJiaZi: monthJiaZi!,
            wangShuaiConfig: wangShuaiConfig,
          )
        : null;

    return Container(
      margin: EdgeInsets.all(1 * sf),
      decoration: BoxDecoration(
        border: Border.all(color: DaliurenColors.ink.withValues(alpha: .06)),
        borderRadius: BorderRadius.circular(DaliurenSpacing.xs * sf),
      ),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 第一行：天将名 + 天将自己的旺衰 badge
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(gong.guiRen.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DaliurenTypography.tag(sf).copyWith(
                    fontSize: 18 * sf,
                    color: DaliurenColors.textSecondary,
                  )),
              WangShuaiBadge(
                hint: wsResult?.tianJiangHint ?? const WangShuaiHint(),
                visible: showWs,
                fontSize: 8 * sf,
                badgeHeight: 10 * sf,
                badgeWidth: 12 * sf,
                borderRadius: 2 * sf,
              ),
            ],
          ),
          SizedBox(height: 1 * sf),
          // 第二行：天盘地支 + 天干（各自独立显示）
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 天盘支 + 自己的旺衰 badge
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(skyDiZhi.value,
                      style: DaliurenTypography.ganZiDiZhi(sf).copyWith(
                        fontSize: 18 * sf,
                        color: ConstResourcesMapper.zodiacZhiColors[skyDiZhi]!
                            .withValues(alpha: .7),
                      )),
                  WangShuaiBadge(
                    hint: wsResult?.skyDiZhiHint ?? const WangShuaiHint(),
                    visible: showWs,
                    fontSize: 8 * sf,
                    badgeHeight: 10 * sf,
                    badgeWidth: 12 * sf,
                    borderRadius: 2 * sf,
                  ),
                ],
              ),
              SizedBox(width: 4 * sf),
              // 天干 + 自己的旺衰 badge
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tianGan != null)
                    Text(tianGan.value,
                        style: DaliurenTypography.ganZiTianGan(sf).copyWith(
                          fontSize: 14 * sf,
                          color: ConstResourcesMapper
                              .zodiacGanColors[tianGan]!
                              .withValues(alpha: .6),
                        ))
                  else
                    CustomPaint(
                      size: Size(10 * sf, 10 * sf),
                      painter: _CirclePainter(DaliurenColors.textHint),
                    ),
                  WangShuaiBadge(
                    hint: wsResult?.tianGanHint ?? const WangShuaiHint(),
                    visible: showWs && tianGan != null,
                    fontSize: 8 * sf,
                    badgeHeight: 10 * sf,
                    badgeWidth: 12 * sf,
                    borderRadius: 2 * sf,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1 * sf),
          // 第三行：宫位名（灰色浅色透明）
          Text(groundDiZhi.value,
              style: DaliurenTypography.caption(sf).copyWith(
                fontSize: 16 * sf,
                color: DaliurenColors.textHint,
              )),
        ],
      ),
    );
  }
}

/// 空亡/无寄干时的圆圈占位
class _CirclePainter extends CustomPainter {
  final Color color;
  _CirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter old) => old.color != color;
}
