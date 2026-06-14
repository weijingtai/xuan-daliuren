import 'dart:async';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:theme/const_resources_mapper.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:metaphysics_core/models/shen_sha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';
import 'package:provider/provider.dart';

import '../../data/models/yu_ding_da_liu_ren_data_model.dart';
import '../../design/daliuren_colors.dart';
import '../../design/daliuren_spacing.dart';
import '../../design/daliuren_typography.dart';
import '../../domain/entities/daliuren_lesson.dart';
import '../../model/da_liu_ren_ke_pan.dart';
import '../../model/da_liu_ren_gong.dart';
import '../../model/each_chuan.dart';
import '../../model/four_class.dart';
import '../../domain/entities/shen_sha_entity.dart';
import '../../presentation/viewmodels/da_liu_ren_viewmodel.dart';
import '../../presentation/widgets/ancient_text_card.dart';
import '../../presentation/widgets/collapsible_section.dart';
import '../../presentation/widgets/ke_pan_info_card.dart';
import '../../presentation/widgets/keti_detail_widget.dart';
import '../../presentation/widgets/responsive_layout.dart';
import '../../presentation/widgets/shen_sha_display_widget.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  static const double normalPanSize = 400.0;

  final renYearGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  final renMonthGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  final renDayGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  final renTimeGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  final renDunGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  final renJuNumberShakeKey = GlobalKey<ShakeWidgetState>();
  final renMonthGeneralShakeKey = GlobalKey<ShakeWidgetState>();

  JiaZi? yearJiaZi;
  JiaZi? monthJiaZi;
  JiaZi? dayJiaZi;
  JiaZi? timeJiaZi;
  MonthGeneral? monthGeneral;
  YinYang? yinYangDun;
  int? juNumber;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DaLiuRenViewModel>().initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DaLiuRenViewModel>();
    final pan = viewModel.currentDivination;
    final juNumberFromVm = viewModel.juNumber;

    return Scaffold(
      backgroundColor: DaliurenColors.paper,
 appBar: AppBar(
 backgroundColor: DaliurenColors.paper,
 elevation: 0,
 leading: IconButton(
 icon: Icon(Icons.arrow_back, color: DaliurenColors.ink),
 onPressed: () => Navigator.of(context).maybePop(),
 ),
 title: pan != null && juNumberFromVm != null
 ? Text(
 "${pan.dayJiaZi.name}日·${pan.timeJiaZi.diZhi.name}时·"
 "${pan.isDayGuiRen ? "阳" : "阴"}"
 "${ConstResourcesMapper.chineseNumberMapper[juNumberFromVm]}局",
 style: DaliurenTypography.h1(0.9),
 )
 : Text("大六壬", style: DaliurenTypography.h1(0.9)),
 centerTitle: true,
 ),
      body:
          pan == null ? _buildEmptyState(viewModel) : _buildContent(viewModel),
    );
  }

  Widget _buildEmptyState(DaLiuRenViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButtons(viewModel),
            SizedBox(height: DaliurenSpacing.xxl),
            _buildManualInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(DaLiuRenViewModel viewModel) {
    final pan = viewModel.currentDivination!;
    final shenSha = viewModel.shenShaResults;
    final matchedLessons = viewModel.matchedLessons;
    final matchedKetiResults = viewModel.matchedKetiResults;
    final lessonSubLessons = <String, List<String>>{};
    for (final r in matchedKetiResults) {
      if (r.matchedSubLesson != null) {
        lessonSubLessons
            .putIfAbsent(r.lesson.name, () => [])
            .add(r.matchedSubLesson!.name);
      }
    }

    return ResponsiveLayout(
      mobile: _buildMobileLayout(
          viewModel, pan, shenSha, matchedLessons, lessonSubLessons),
      tablet: _buildTabletLayout(
          viewModel, pan, shenSha, matchedLessons, lessonSubLessons),
      desktop: _buildDesktopLayout(
          viewModel, pan, shenSha, matchedLessons, lessonSubLessons),
    );
  }

  Widget _buildMobileLayout(
    DaLiuRenViewModel viewModel,
    DaLiuRenKePan pan,
    Map<DiZhi, List<ShenShaResult>>? shenSha,
    List<DaliurenLesson> matchedLessons,
    Map<String, List<String>> lessonSubLessons,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: DaliurenSpacing.md),
      child: Column(
        children: [
          _buildActionButtons(viewModel),
          SizedBox(height: DaliurenSpacing.lg),
          _buildPanArea(pan),
          SizedBox(height: DaliurenSpacing.lg),
          _buildKePanInfoSection(pan, viewModel),
          SizedBox(height: DaliurenSpacing.lg),
          _buildSanChuanSection(pan),
          if (shenSha != null && shenSha.isNotEmpty) ...[
            SizedBox(height: DaliurenSpacing.lg),
            _buildShenShaSection(shenSha),
          ],
          SizedBox(height: DaliurenSpacing.lg),
          _buildAncientTextSection(pan),
          if (matchedLessons.isNotEmpty) ...[
            SizedBox(height: DaliurenSpacing.lg),
            KetiDetailWidget(
              lessons: matchedLessons,
              highlightedSubLessons: lessonSubLessons,
            ),
          ],
          SizedBox(height: DaliurenSpacing.xxl),
          _buildManualInput(),
          SizedBox(height: DaliurenSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    DaLiuRenViewModel viewModel,
    DaLiuRenKePan pan,
    Map<DiZhi, List<ShenShaResult>>? shenSha,
    List<DaliurenLesson> matchedLessons,
    Map<String, List<String>> lessonSubLessons,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: DaliurenSpacing.xl),
      child: Column(
        children: [
          _buildActionButtons(viewModel),
          SizedBox(height: DaliurenSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildPanArea(pan),
                    SizedBox(height: DaliurenSpacing.lg),
                    _buildKePanInfoSection(pan, viewModel),
                    SizedBox(height: DaliurenSpacing.lg),
                    _buildSanChuanSection(pan),
                  ],
                ),
              ),
              SizedBox(width: DaliurenSpacing.xl),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    if (shenSha != null && shenSha.isNotEmpty) ...[
                      _buildShenShaSection(shenSha),
                      SizedBox(height: DaliurenSpacing.lg),
                    ],
                    _buildAncientTextSection(pan),
                    if (matchedLessons.isNotEmpty) ...[
                      SizedBox(height: DaliurenSpacing.lg),
                      KetiDetailWidget(
                        lessons: matchedLessons,
                        highlightedSubLessons: lessonSubLessons,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: DaliurenSpacing.xxl),
          _buildManualInput(),
          SizedBox(height: DaliurenSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    DaLiuRenViewModel viewModel,
    DaLiuRenKePan pan,
    Map<DiZhi, List<ShenShaResult>>? shenSha,
    List<DaliurenLesson> matchedLessons,
    Map<String, List<String>> lessonSubLessons,
  ) {
    return Column(children: [
      _buildActionButtons(viewModel),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: DaliurenSpacing.xxl,
                  top: DaliurenSpacing.xl,
                  right: DaliurenSpacing.md,
                  bottom: DaliurenSpacing.xxxl,
                ),
                child: Column(
                  children: [
                    _buildPanArea(pan),
                    SizedBox(height: DaliurenSpacing.lg),
                    _buildKePanInfoSection(pan, viewModel),
                    SizedBox(height: DaliurenSpacing.lg),
                    _buildSanChuanSection(pan),
                    SizedBox(height: DaliurenSpacing.xl),
                    _buildManualInput(),
                  ],
                ),
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.symmetric(vertical: DaliurenSpacing.xl),
              color: DaliurenColors.dividerGradient,
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: DaliurenSpacing.md,
                  top: DaliurenSpacing.xl,
                  right: DaliurenSpacing.xxl,
                  bottom: DaliurenSpacing.xxxl,
                ),
                child: Column(
                  children: [
                    if (shenSha != null && shenSha.isNotEmpty) ...[
                      _buildShenShaSection(shenSha),
                      SizedBox(height: DaliurenSpacing.lg),
                    ],
                    _buildAncientTextSection(pan),
                    if (matchedLessons.isNotEmpty) ...[
                      SizedBox(height: DaliurenSpacing.lg),
                      KetiDetailWidget(
                        lessons: matchedLessons,
                        highlightedSubLessons: lessonSubLessons,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildActionButtons(DaLiuRenViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.all(DaliurenSpacing.xl),
      child: Wrap(
        spacing: DaliurenSpacing.md,
        runSpacing: DaliurenSpacing.md,
        alignment: WrapAlignment.center,
        children: [
          _actionButton("选择时间", Icons.calendar_today, () async {
            final result = await showBoardDateTimePicker(
                context: context, pickerType: DateTimePickerType.datetime);
            if (result != null) viewModel.updateDateTime(result);
          }),
          _actionButton("现在", Icons.schedule, () {
            viewModel.updateDateTime(DateTime.now());
          }),
          _actionButton("排盘", Icons.auto_awesome, () async {
            if (viewModel.currentDivination == null) {
              viewModel.updateDateTime(viewModel.selectedDateTime);
            } else {
              _toast("不能重复");
            }
          }),
          _actionButton("干支排盘", Icons.edit_note, () async {
            if (viewModel.currentDivination == null) {
              if ([yearJiaZi, monthJiaZi, dayJiaZi, yinYangDun]
                      .any((e) => e == null) ||
                  (timeJiaZi == null && juNumber == null)) {
                _shakeMissing();
              } else {
                viewModel.updateManualJu(
                  yearJiaZi: yearJiaZi!,
                  monthJiaZi: monthJiaZi!,
                  dayJiaZi: dayJiaZi!,
                  yinYangDun: yinYangDun!,
                  monthGeneral: monthGeneral!,
                  timeJiaZi: timeJiaZi,
                  juNumber: juNumber,
                );
              }
            } else {
              _toast("不能重复");
            }
          }),
          _actionButton("清除", Icons.clear, () {
            viewModel.clear();
            yearJiaZi = null;
            monthJiaZi = null;
            dayJiaZi = null;
            timeJiaZi = null;
            monthGeneral = null;
            juNumber = null;
            yinYangDun = null;
          }),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: DaliurenTypography.caption(1)),
      style: OutlinedButton.styleFrom(
        foregroundColor: DaliurenColors.ink,
        side: BorderSide(color: DaliurenColors.ink.withValues(alpha: .2)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DaliurenSpacing.lg)),
      ),
    );
  }

  Widget _buildPanArea(DaLiuRenKePan pan) {
    final gongSize = Size(normalPanSize * .25, normalPanSize * .25);
    return Center(
      child: Container(
        width: normalPanSize,
        height: normalPanSize,
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
                return SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: diZhi != null
                      ? _buildGongCell(diZhi, gongMapper[diZhi]!, gongSize, sf)
                      : const SizedBox(),
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
      DiZhi diZhi, DaLiuRenGong gong, Size gongSize, double sf) {
    final skyDiZhi = gong.skyPanDiZhi;
    final groundDiZhi = gong.groundPanDiZhi;
    final guiRen = gong.guiRen;
    final tianGan = gong.tianGan;

    return Container(
      margin: EdgeInsets.all(1 * sf),
      decoration: BoxDecoration(
        border: Border.all(color: DaliurenColors.ink.withValues(alpha: .06)),
        borderRadius: BorderRadius.circular(DaliurenSpacing.xs * sf),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: gongSize.width * .36 * sf,
            height: gongSize.width * .36 * sf,
            child: FittedBox(
              child: Text(skyDiZhi.value,
                  style: DaliurenTypography.ganZiDiZhi(sf).copyWith(
                      color: ConstResourcesMapper.zodiacZhiColors[skyDiZhi]!
                          .withValues(alpha: .7))),
            ),
          ),
          SizedBox(height: 1 * sf),
          Text(guiRen.name,
              style: DaliurenTypography.caption(sf * .8)
                  .copyWith(color: DaliurenColors.textSecondary)),
          SizedBox(height: 1 * sf),
          if (tianGan != null)
            SizedBox(
              width: gongSize.width * .2 * sf,
              height: gongSize.width * .2 * sf,
              child: FittedBox(
                child: Text(tianGan.value,
                    style: DaliurenTypography.ganZiTianGan(sf).copyWith(
                        color: ConstResourcesMapper.zodiacGanColors[tianGan]!
                            .withValues(alpha: .6))),
              ),
            )
          else
            SizedBox(
              width: gongSize.width * .2 * sf,
              height: gongSize.width * .2 * sf,
              child: CustomPaint(
                painter: _CirclePainter(DaliurenColors.textHint),
              ),
            ),
          SizedBox(height: 1 * sf),
          SizedBox(
            width: gongSize.width * .16 * sf,
            height: gongSize.width * .16 * sf,
            child: FittedBox(
              child: Text(groundDiZhi.value,
                  style: DaliurenTypography.caption(sf * .8)
                      .copyWith(color: DaliurenColors.textSecondary)),
            ),
          ),
        ],
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

  Widget _buildKePanInfoSection(
      DaLiuRenKePan pan, DaLiuRenViewModel viewModel) {
    return KePanInfoCard(
      kePan: pan,
      juNumber: viewModel.juNumber,
      keTiNames: viewModel.matchedKeTiNames,
    );
  }

  Widget _buildSanChuanSection(DaLiuRenKePan pan) {
    final chuan = pan.getThreeChuan();

    final items = [
      {"l": "初传", "o": chuan.first},
      {"l": "中传", "o": chuan.second},
      {"l": "末传", "o": chuan.third},
    ];

    return Card(
      elevation: 2,
      color: DaliurenColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DaliurenSpacing.xl),
        side: BorderSide(color: DaliurenColors.ink.withValues(alpha: .12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(DaliurenSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                Text("三传", style: DaliurenTypography.h3(1)),
              ],
            ),
            SizedBox(height: DaliurenSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items.map((item) {
                final obj = item["o"]! as EachChuan;
                final liuQin = obj.liuQin.name;
                final tianGan = obj.tianGan;
                final diZhi = obj.diZhi;
                final guiRen = obj.guiRen.name;

                return Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: DaliurenSpacing.xs),
                    padding: EdgeInsets.symmetric(
                        horizontal: DaliurenSpacing.md,
                        vertical: DaliurenSpacing.lg),
                    decoration: BoxDecoration(
                      color: DaliurenColors.bgCard,
                      borderRadius: BorderRadius.circular(DaliurenSpacing.lg),
                      border: Border.all(
                          color: DaliurenColors.ink.withValues(alpha: .06)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item["l"]! as String,
                            style: DaliurenTypography.caption(1)),
                        SizedBox(height: DaliurenSpacing.xs),
                        Text(liuQin,
                            style: DaliurenTypography.tag(1)
                                .copyWith(color: DaliurenColors.textSecondary)),
                        SizedBox(height: DaliurenSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (tianGan != null)
                              Text(tianGan.value,
                                  style: DaliurenTypography.ganZiTianGan(1)
                                      .copyWith(
                                          color: ConstResourcesMapper
                                              .zodiacGanColors[tianGan]!
                                              .withValues(alpha: .6)))
                            else
                              Icon(Icons.circle_outlined,
                                  size: 14, color: DaliurenColors.textHint),
                            SizedBox(width: DaliurenSpacing.xs),
                            Text(diZhi.value,
                                style: DaliurenTypography.ganZiDiZhi(1)
                                    .copyWith(
                                        color: ConstResourcesMapper
                                            .zodiacZhiColors[diZhi]!
                                            .withValues(alpha: .7))),
                          ],
                        ),
                        SizedBox(height: DaliurenSpacing.xs),
                        Text(guiRen,
                            style: DaliurenTypography.tag(1)
                                .copyWith(color: DaliurenColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShenShaSection(Map<DiZhi, List<ShenShaResult>> shenShaResults) {
    return CollapsibleSection(
      title: "神煞",
      child: ShenShaDisplayWidget(shenShaResults: shenShaResults),
    );
  }

  Widget _buildAncientTextSection(DaLiuRenKePan pan) {
    return FutureBuilder<YuDingDaLiuRenDataModel>(
      future: _loadYuDing(pan),
      builder: (ctx, snap) {
        if (snap.hasError || !snap.hasData) {
          return const SizedBox.shrink();
        }
        return CollapsibleSection(
          title: "古籍释义",
          child: AncientTextCard(yuDing: snap.data!),
        );
      },
    );
  }

  Future<YuDingDaLiuRenDataModel> _loadYuDing(DaLiuRenKePan pan) async {
    final List<dynamic> res = await context.read<DaLiuRenViewModel>().loadYuDingData();
    final List<YuDingDaLiuRenDataModel> all =
        List<YuDingDaLiuRenDataModel>.from(
            res.map((m) => YuDingDaLiuRenDataModel.fromJson(m)));
    return all.firstWhere((y) =>
        y.dayJiaZi == pan.dayJiaZi && y.juName == pan.fourClass.first.sky);
  }

  Widget _buildManualInput() {
    return Card(
      elevation: 1,
      color: DaliurenColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DaliurenSpacing.xl),
        side: BorderSide(color: DaliurenColors.ink.withValues(alpha: .08)),
      ),
      child: Padding(
        padding: EdgeInsets.all(DaliurenSpacing.xl),
        child: Wrap(
          spacing: DaliurenSpacing.md,
          runSpacing: DaliurenSpacing.md,
          alignment: WrapAlignment.center,
          children: [
            _dropdown(
                "年干支",
                renYearGanZhiShakeKey,
                JiaZi.listAll.map((e) => e.name).toList(),
                (v) =>
                    yearJiaZi = v != null ? JiaZi.getFromGanZhiValue(v) : null),
            _dropdown(
                "月干支",
                renMonthGanZhiShakeKey,
                JiaZi.listAll.map((e) => e.name).toList(),
                (v) => monthJiaZi =
                    v != null ? JiaZi.getFromGanZhiValue(v) : null),
            _dropdown(
                "日干支",
                renDayGanZhiShakeKey,
                JiaZi.listAll.map((e) => e.name).toList(),
                (v) =>
                    dayJiaZi = v != null ? JiaZi.getFromGanZhiValue(v) : null),
            _dropdown("时干支", renTimeGanZhiShakeKey,
                JiaZi.listAll.map((e) => e.name).toList(), (v) {
              if (v != null) {
                timeJiaZi = JiaZi.getFromGanZhiValue(v);
                juNumber = null;
              } else {
                timeJiaZi = null;
              }
            }),
            _dropdown("阴阳遁", renDunGanZhiShakeKey, ["阳", "阴"],
                (v) => yinYangDun = v == "阳" ? YinYang.YANG : YinYang.YIN),
            _dropdown("月将", renMonthGeneralShakeKey,
                MonthGeneral.values.map((e) => e.name).toList(), (v) {
              monthGeneral = v != null
                  ? MonthGeneral.values.firstWhere((m) => m.name == v)
                  : null;
            }),
            _dropdown(
                "局数", renJuNumberShakeKey, List.generate(12, (i) => "${i + 1}"),
                (v) {
              if (v != null) {
                juNumber = int.tryParse(v);
                timeJiaZi = null;
              } else {
                juNumber = null;
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String hint, GlobalKey<ShakeWidgetState> shakeKey,
      List<String> items, ValueChanged<String?> onChanged) {
    return ShakeMe(
      key: shakeKey,
      shakeCount: 3,
      shakeOffset: 6,
      shakeDuration: const Duration(milliseconds: 400),
      child: SizedBox(
        width: 100,
        height: 42,
        child: CustomDropdown<String>.search(
          hintText: hint,
          items: items,
          onChanged: onChanged,
          decoration: CustomDropdownDecoration(
            closedShadow: [
              BoxShadow(
                  color: Colors.grey.withValues(alpha: .15),
                  spreadRadius: 1,
                  blurRadius: 2)
            ],
            closedBorderRadius: BorderRadius.circular(DaliurenSpacing.md),
            expandedBorderRadius: BorderRadius.circular(DaliurenSpacing.md),
            searchFieldDecoration:
                const SearchFieldDecoration(prefixIcon: null),
          ),
        ),
      ),
    );
  }

  void _shakeMissing() {
    if (yearJiaZi == null) renYearGanZhiShakeKey.currentState?.shake();
    if (monthJiaZi == null) renMonthGanZhiShakeKey.currentState?.shake();
    if (dayJiaZi == null) renDayGanZhiShakeKey.currentState?.shake();
    if (yinYangDun == null) renDunGanZhiShakeKey.currentState?.shake();
    if (monthGeneral == null) {
      renMonthGeneralShakeKey.currentState?.shake();
    }
    if (timeJiaZi == null && juNumber == null) {
      renTimeGanZhiShakeKey.currentState?.shake();
      renJuNumberShakeKey.currentState?.shake();
    }
  }

  void _toast(String msg) {
    InteractiveToast.slide(
      context: context,
      title: Text(msg),
      toastStyle: const ToastStyle(titleLeadingGap: 10),
      toastSetting: const SlidingToastSetting(
        animationDuration: Duration(seconds: 1),
        displayDuration: Duration(seconds: 2),
        toastStartPosition: ToastPosition.top,
        toastAlignment: Alignment.topCenter,
      ),
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
