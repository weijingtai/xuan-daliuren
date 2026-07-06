import 'package:flutter/material.dart';
import 'package:metaphysics_chart_ui/metaphysics_chart_ui.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:provider/provider.dart';
import 'package:theme/const_resources_mapper.dart';
import 'package:xuan_common_ui/xuan_common_ui.dart';

import '../design/daliuren_colors.dart';
import '../design/daliuren_spacing.dart';
import '../design/daliuren_typography.dart';
import '../model/da_liu_ren_gong.dart';
import '../model/da_liu_ren_ke_pan.dart';
import '../model/four_class.dart';
import '../domain/entities/shen_sha_entity.dart';
import '../presentation/viewmodels/da_liu_ren_viewmodel.dart';
import '../presentation/widgets/gong_hint_mapper.dart';

/// 宫位布局开发页面
///
/// 用于独立调试和调整每个宫位内关键信息的布局，
/// 包括天盘地支、贵人（天将）、寄干、地盘地支、注解等。
class GongLayoutDevPage extends StatefulWidget {
  const GongLayoutDevPage({super.key});

  @override
  State<GongLayoutDevPage> createState() => _GongLayoutDevPageState();
}

class _GongLayoutDevPageState extends State<GongLayoutDevPage> {
  bool _showHints = false;
  double _gongScale = 1.0;
  double _panSize = 400.0;
  DiZhi? _selectedDiZhi;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<DaLiuRenViewModel>();
      await vm.initializeData();
      if (vm.currentDivination == null) {
        vm.updateDateTime(DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DaLiuRenViewModel>();
    final pan = viewModel.currentDivination;

    return Scaffold(
      backgroundColor: DaliurenColors.paper,
      appBar: AppBar(
        title: Text("宫位布局开发", style: DaliurenTypography.h2(1)),
        backgroundColor: DaliurenColors.paper,
        foregroundColor: DaliurenColors.ink,
        elevation: 0,
      ),
      body: pan == null
          ? Center(child: Text("请先排盘", style: DaliurenTypography.body(1)))
          : _buildContent(pan, viewModel),
    );
  }

  Widget _buildContent(DaLiuRenKePan pan, DaLiuRenViewModel viewModel) {
    return Column(
      children: [
        _buildControlBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(DaliurenSpacing.xl),
            child: Column(
              children: [
                _buildSingleGongDetail(pan, viewModel),
                SizedBox(height: DaliurenSpacing.xxl),
                _buildPanOverview(pan),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DaliurenSpacing.xl,
        vertical: DaliurenSpacing.md,
      ),
      decoration: BoxDecoration(
        color: DaliurenColors.bgElevated,
        border: Border(
          bottom: BorderSide(color: DaliurenColors.dividerGradient),
        ),
      ),
      child: Wrap(
        spacing: DaliurenSpacing.lg,
        runSpacing: DaliurenSpacing.md,
        alignment: WrapAlignment.center,
        children: [
          _buildToggleChip(
            label: _showHints ? "隐藏注解" : "显示注解",
            icon: _showHints ? Icons.visibility_off : Icons.visibility,
            selected: _showHints,
            onTap: () => setState(() => _showHints = !_showHints),
          ),
          _buildScaleChip(
            label: "宫格缩放",
            value: _gongScale,
            min: 0.5,
            max: 2.0,
            onChanged: (v) => setState(() => _gongScale = v),
          ),
          _buildScaleChip(
            label: "盘面尺寸",
            value: _panSize,
            min: 200,
            max: 600,
            step: 50,
            onChanged: (v) => setState(() => _panSize = v),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DaliurenSpacing.md,
          vertical: DaliurenSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? DaliurenColors.sealRedLight
              : DaliurenColors.bgCard,
          borderRadius: BorderRadius.circular(DaliurenSpacing.sm),
          border: Border.all(
            color: selected
                ? DaliurenColors.sealRedBorder
                : DaliurenColors.dividerGradient,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: DaliurenColors.textSecondary),
            SizedBox(width: DaliurenSpacing.xs),
            Text(label, style: DaliurenTypography.caption(1)),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleChip({
    required String label,
    required double value,
    required double min,
    required double max,
    double step = 0.1,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: DaliurenTypography.caption(1)),
        SizedBox(width: DaliurenSpacing.sm),
        SizedBox(
          width: 120,
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / step).round(),
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
            activeColor: DaliurenColors.sealRed,
            inactiveColor: DaliurenColors.dividerGradient,
          ),
        ),
        Text(
          value.toStringAsFixed(1),
          style: DaliurenTypography.caption(1),
        ),
      ],
    );
  }

  /// 单宫详情：放大展示选中或默认宫位的内部布局
  Widget _buildSingleGongDetail(
      DaLiuRenKePan pan, DaLiuRenViewModel viewModel) {
    final diZhi = _selectedDiZhi ?? DiZhi.SI;
    final gong = pan.gongMapper[diZhi]!;
    final shenSha = viewModel.shenShaResults;
    final gongSize = Size(100 * _gongScale, 100 * _gongScale);

    return XuanCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: DaliurenColors.sealRed.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: DaliurenSpacing.md),
              Text("单宫详情", style: DaliurenTypography.h3(1)),
              Spacer(),
              _buildDiZhiSelector(diZhi),
            ],
          ),
          SizedBox(height: DaliurenSpacing.lg),
          Center(
            child: _buildGongCell(diZhi, gong, gongSize, 1.0, shenSha),
          ),
          SizedBox(height: DaliurenSpacing.lg),
          _buildGongInfoPanel(diZhi, gong, shenSha),
        ],
      ),
    );
  }

  Widget _buildDiZhiSelector(DiZhi current) {
    return DropdownButton<DiZhi>(
      value: current,
      underline: SizedBox(),
      style: DaliurenTypography.caption(1),
      items: DiZhi.listAll
          .map((dz) => DropdownMenuItem(
                value: dz,
                child: Text(dz.value),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => _selectedDiZhi = v);
      },
    );
  }

  Widget _buildGongInfoPanel(
    DiZhi diZhi,
    DaLiuRenGong gong,
    Map<DiZhi, List<ShenShaResult>>? shenSha,
  ) {
    final items = [
      _infoRow("地支（地盘）", diZhi.value),
      _infoRow("天盘", gong.skyPanDiZhi.value),
      _infoRow("贵人", gong.guiRen.name),
      _infoRow("寄干", gong.tianGan?.value ?? "（无）"),
      if (gong.jiaZi != null) _infoRow("甲子", gong.jiaZi!.name),
    ];

    // 神煞信息
    final shenShaList = shenSha?[diZhi];
    if (shenShaList != null && shenShaList.isNotEmpty) {
      items.add(_infoRow("神煞", shenShaList.map((s) => s.shenSha.name).join("、")));
    }

    return Wrap(
      spacing: DaliurenSpacing.lg,
      runSpacing: DaliurenSpacing.xs,
      children: items,
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$label: ", style: DaliurenTypography.caption(1)),
        Text(value, style: DaliurenTypography.tag(1)),
      ],
    );
  }

  /// 全盘概览：缩小展示完整盘面
  Widget _buildPanOverview(DaLiuRenKePan pan) {
    final gongSize = Size(_panSize * .25, _panSize * .25);

    return XuanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: DaliurenColors.sealRed.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: DaliurenSpacing.md),
              Text("全盘概览", style: DaliurenTypography.h3(1)),
            ],
          ),
          SizedBox(height: DaliurenSpacing.lg),
          Center(
            child: Container(
              width: _panSize,
              height: _panSize,
              decoration: BoxDecoration(
                color: DaliurenColors.paper,
                borderRadius: BorderRadius.circular(DaliurenSpacing.xxxl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 12,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: _buildGongGrid(pan, gongSize, 1.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGongGrid(DaLiuRenKePan pan, Size gongSize, double sf) {
    final gongMapper = pan.gongMapper;
    final diZhiRows = [
      [DiZhi.SI, DiZhi.WU, DiZhi.WEI, DiZhi.SHEN],
      [DiZhi.CHEN, null, null, DiZhi.YOU],
      [DiZhi.MAO, null, null, DiZhi.XU],
      [DiZhi.YIN, DiZhi.CHOU, DiZhi.ZI, DiZhi.HAI],
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: diZhiRows.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((diZhi) {
                return GestureDetector(
                  onTap: diZhi != null
                      ? () => setState(() => _selectedDiZhi = diZhi)
                      : null,
                  child: Container(
                    width: gongSize.width,
                    height: gongSize.height,
                    decoration: diZhi == _selectedDiZhi
                        ? BoxDecoration(
                            border: Border.all(
                              color: DaliurenColors.sealRed,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              DaliurenSpacing.xs * sf,
                            ),
                          )
                        : null,
                    child: diZhi != null
                        ? _buildGongCell(
                            diZhi,
                            gongMapper[diZhi]!,
                            gongSize,
                            sf,
                            context.read<DaLiuRenViewModel>().shenShaResults,
                          )
                        : const SizedBox(),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
        _buildCenter(pan, gongSize, sf),
      ],
    );
  }

  Widget _buildGongCell(
    DiZhi diZhi,
    DaLiuRenGong gong,
    Size gongSize,
    double sf,
    Map<DiZhi, List<ShenShaResult>>? shenShaResults,
  ) {
    final skyDiZhi = gong.skyPanDiZhi;
    final groundDiZhi = gong.groundPanDiZhi;
    final tianGan = gong.tianGan;

    // 天盘地支：18px
    final skyDiZhiStyle = DaliurenTypography.ganZiDiZhi(sf).copyWith(
      fontSize: 18 * sf,
      color: ConstResourcesMapper.zodiacZhiColors[skyDiZhi]!
          .withValues(alpha: .7),
    );

    // 天干：14px
    final tianGanStyle = tianGan != null
        ? DaliurenTypography.ganZiTianGan(sf).copyWith(
            fontSize: 14 * sf,
            color: ConstResourcesMapper.zodiacGanColors[tianGan]!
                .withValues(alpha: .6),
          )
        : DaliurenTypography.ganZiTianGan(sf).copyWith(fontSize: 14 * sf);

    // 天将：18px
    final guiRenStyle = DaliurenTypography.tag(sf).copyWith(
      fontSize: 18 * sf,
      color: DaliurenColors.textSecondary,
    );

    return Container(
      margin: EdgeInsets.all(1 * sf),
      decoration: BoxDecoration(
        border: Border.all(color: DaliurenColors.ink.withValues(alpha: .06)),
        borderRadius: BorderRadius.circular(DaliurenSpacing.xs * sf),
      ),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      child: Builder(
        builder: (context) {
          final hints = _showHints
              ? GongHintMapper.map(
                  diZhi: diZhi,
                  gong: gong,
                  shenShaResults: shenShaResults,
                )
              : <VitalityValue>[];

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 第一行：天将名（18px，最顶部）
              SymbolAnnotation.sides(
                symbol: Text(gong.guiRen.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: guiRenStyle),
                values: hints,
                show: _showHints,
                theme: const GongTokenTheme.fallback(),
                axis: VitalityAxis.horizontal,
                symbolShrinkScale: 0.85,
                expandedExtent: 20,
              ),
              SizedBox(height: 2 * sf),
              // 第二行：天盘地支(18px) + 天干(14px)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(skyDiZhi.value, style: skyDiZhiStyle),
                  SizedBox(width: 4 * sf),
                  if (tianGan != null)
                    Text(tianGan.value, style: tianGanStyle)
                  else
                    CustomPaint(
                      size: Size(10 * sf, 10 * sf),
                      painter: _CirclePainter(DaliurenColors.textHint),
                    ),
                ],
              ),
              SizedBox(height: 2 * sf),
              // 第三行：宫位名（16px，灰色浅色透明）
              Text(groundDiZhi.value,
                  style: DaliurenTypography.caption(sf).copyWith(
                    fontSize: 16 * sf,
                    color: DaliurenColors.textHint,
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCenter(DaLiuRenKePan pan, Size gongSize, double sf) {
    final fourClass = pan.getFourClass();
    return SizedBox(
      width: gongSize.width * 2,
      height: gongSize.height * 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMonthGeneralCenter(pan, sf),
          SizedBox(height: DaliurenSpacing.xs * sf),
          Expanded(
            child: FittedBox(
              child: _buildFourKeCompact(fourClass, sf),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGeneralCenter(DaLiuRenKePan pan, double sf) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(pan.monthGeneral.generalZhi.name,
            style: DaliurenTypography.ganZiDiZhi(1.2 * sf).copyWith(
                color: ConstResourcesMapper
                    .zodiacZhiColors[pan.monthGeneral.generalZhi]!
                    .withValues(alpha: .8))),
        SizedBox(height: DaliurenSpacing.xs * sf),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: DaliurenSpacing.md * sf,
              vertical: DaliurenSpacing.xs * sf),
          decoration: BoxDecoration(
            color: DaliurenColors.sealRedLight,
            borderRadius: BorderRadius.circular(DaliurenSpacing.xs),
          ),
          child: Text(pan.monthGeneral.name,
              style: DaliurenTypography.tag(sf).copyWith(
                  color: DaliurenColors.sealRed.withValues(alpha: .8))),
        ),
      ],
    );
  }

  Widget _buildFourKeCompact(FourClass fourClass, double sf) {
    final items = [
      {
        "l": "四",
        "g": fourClass.fourth.guiRen.name,
        "s": fourClass.fourth.sky.value,
        "d": fourClass.fourth.ground.value
      },
      {
        "l": "三",
        "g": fourClass.third.guiRen.name,
        "s": fourClass.third.sky.value,
        "d": fourClass.third.ground.value
      },
      {
        "l": "二",
        "g": fourClass.second.guiRen.name,
        "s": fourClass.second.sky.value,
        "d": fourClass.second.ground.value
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...items.map((item) => Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: DaliurenSpacing.xs * sf),
              child: _keColumn(
                  item["l"]!, item["g"]!, item["s"]!, item["d"]!, null, sf),
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DaliurenSpacing.xs * sf),
          child: _keColumn(
              "一",
              fourClass.first.guiRen.name,
              fourClass.first.sky.value,
              fourClass.first.ground.value,
              fourClass.first.tianGan.value,
              sf),
        ),
      ],
    );
  }

  Widget _keColumn(String label, String guiRen, String sky, String ground,
      String? tianGan, double sf) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: DaliurenTypography.caption(sf)),
        Text(guiRen,
            style: DaliurenTypography.caption(sf * .9)
                .copyWith(color: DaliurenColors.textSecondary)),
        Text(sky, style: DaliurenTypography.ganZiDiZhi(sf * .9)),
        if (tianGan != null)
          Text(tianGan, style: DaliurenTypography.ganZiTianGan(sf * .9))
        else
          Text(ground, style: DaliurenTypography.ganZiDiZhi(sf * .9)),
        if (tianGan != null)
          Text(ground,
              style: DaliurenTypography.caption(sf * .9)
                  .copyWith(color: DaliurenColors.textSecondary)),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;
  _CirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width * .3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
