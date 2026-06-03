import 'package:theme/const_resources_mapper.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:xuan_common/module.dart';
import 'package:xuan_common/widgets/const_ui_resources_mapper.dart';
import 'package:daliuren/domain/interfaces/school_entry.dart';
import 'package:daliuren/domain/schools/school_catalog.dart';
import 'package:daliuren/model/each_class.dart';
import 'package:daliuren/model/enum_gui_ren.dart';
import 'package:daliuren/model/first_class.dart';
import 'package:daliuren/model/four_class.dart';
import 'package:daliuren/presentation/widgets/school_entry_display_widget.dart';
import 'package:daliuren/presentation/widgets/school_explanation_panel.dart';
import 'package:daliuren/presentation/widgets/school_slider_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 调试用 section 类型；仅在 DevPage 内部使用。
enum _DevSection { fourKe, multiSchool }

class DevMyWidget extends StatefulWidget {
  const DevMyWidget({super.key});

  @override
  State<DevMyWidget> createState() => _DevMyWidgetState();
}

class _DevMyWidgetState extends State<DevMyWidget> {
  _DevSection _section = _DevSection.fourKe;
  String _devSelectedSchoolId = 'yuding';

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    '调试入口',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<_DevSection>(
                segments: const [
                  ButtonSegment<_DevSection>(
                    value: _DevSection.fourKe,
                    label: Text('四课调试'),
                  ),
                  ButtonSegment<_DevSection>(
                    value: _DevSection.multiSchool,
                    label: Text('多流派调试'),
                  ),
                ],
                selected: <_DevSection>{_section},
                onSelectionChanged: (Set<_DevSection> next) {
                  setState(() {
                    _section = next.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _section == _DevSection.fourKe
                  ? Center(child: build_four_ke(generateFourClass()))
                  : _buildMultiSchoolSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSchoolSection(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      key: const Key('dev_multi_school_section'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '多流派调试 (统一组件展示路径)',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SchoolSliderBar(
            key: const Key('dev_school_slider_bar'),
            schools: SchoolCatalog.all,
            selectedSchoolId: _devSelectedSchoolId,
            onChanged: (String id) {
              setState(() {
                _devSelectedSchoolId = id;
              });
            },
          ),
          const SizedBox(height: 8),
          SchoolExplanationPanel(
            key: const Key('dev_school_explanation_panel'),
            selectedSchoolId: _devSelectedSchoolId,
            availableYudingBuilder: (BuildContext ctx) =>
                SchoolEntryDisplayWidget(entry: _devSampleYudingEntry),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// DevPage 专用的内联示例 SchoolEntry，仅用于验证统一组件的渲染路径。
  /// 严禁作为正式数据来源。
  static const SchoolEntry _devSampleYudingEntry = _DevSampleSchoolEntry();

  FourClass generateFourClass() {
    final fourClass = FourClass(
      first: FirstClass(
          sky: DiZhi.CHOU,
          ground: DiZhi.SHEN,
          guiRen: GuiRen.TIAN_KONG,
          tianGan: TianGan.GENG),
      second: EachClass(
          order: 1, sky: DiZhi.WU, ground: DiZhi.CHEN, guiRen: GuiRen.TIAN_HOU),
      third: EachClass(
          order: 2, sky: DiZhi.SI, ground: DiZhi.ZI, guiRen: GuiRen.TAI_YIN),
      fourth: EachClass(
          order: 3, sky: DiZhi.XU, ground: DiZhi.SI, guiRen: GuiRen.LIU_HE),
      isFanYin: false,
      isFuYin: false,
      isFullClass: true,
      isThreeClassOnly: false,
    );
    return fourClass;
  }

  Size gongSize = const Size(400 * .25, 400 * .25);
  TextStyle guiRenNameTextStyle = GoogleFonts.maShanZheng(
      fontSize: 24,
      color: const Color.fromRGBO(68, 68, 60, 1), // 墨染
      // color: Color.fromRGBO(255, 229, 248, 1), // 墨染
      height: 1.0,
      shadows: [
        Shadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 2,
            offset: const Offset(0, 0))
      ]);

  Widget build_four_ke(FourClass fourClass) {
    double diZhiFontSize = gongSize.width * .24;
    double otherFontSize = gongSize.width * .24;
    TextStyle tianGanStyle = ConstUIResourcesMapper.tianGanTextStyle
        .copyWith(fontSize: diZhiFontSize, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    TextStyle diZhiStyle = ConstUIResourcesMapper.twelveDiZhiTextStyle
        .copyWith(fontSize: diZhiFontSize, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    TextStyle guiRenName =
        guiRenNameTextStyle.copyWith(fontSize: gongSize.width * .14, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    SizedBox intervalSize = const SizedBox(width: 6);
    double height = gongSize.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "四",
              style: GoogleFonts.maShanZheng(height: 1, fontSize: 18),
            ),
            Text(fourClass.fourth.guiRen.name, style: guiRenName),
            Text(fourClass.fourth.sky.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.fourth.sky))),
            Text(fourClass.fourth.ground.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.fourth.ground)))
          ],
        ),
        intervalSize,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "三",
              style: GoogleFonts.maShanZheng(height: 1, fontSize: 18),
            ),
            Text(fourClass.third.guiRen.name, style: guiRenName),
            Text(fourClass.third.sky.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.third.sky))),
            Text(fourClass.third.ground.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.third.ground)))
          ],
        ),
        intervalSize,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "二",
              style: GoogleFonts.maShanZheng(height: 1, fontSize: 18),
            ),
            Text(fourClass.second.guiRen.name, style: guiRenName),
            Text(fourClass.second.sky.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.second.sky))),
            Text(fourClass.second.ground.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.second.ground)))
          ],
        ),
        intervalSize,
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "一",
                    style: GoogleFonts.maShanZheng(height: 1, fontSize: 18),
                  ),
                  Text(fourClass.first.guiRen.name, style: guiRenName),
                  Center(
                    child: Text(fourClass.first.sky.value,
                        style: diZhiStyle.copyWith(
                            color: getZhiColor(fourClass.first.sky))),
                  ),
                  Center(
                    child: Text(fourClass.first.tianGan.value,
                        style: tianGanStyle.copyWith(
                            color: getGanColor(fourClass.first.tianGan))),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(fourClass.first.ground.value,
                    style: diZhiStyle.copyWith(
                        color: getZhiColor(fourClass.first.ground),
                        fontSize: gongSize.width * .16)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Color getZhiColor(DiZhi zhi) {
    return ConstResourcesMapper.zodiacZhiColors[zhi]!.withOpacity(.8);
  }

  Color getGanColor(TianGan gan) {
    return ConstResourcesMapper.zodiacGanColors[gan]!.withOpacity(.6);
  }
}

/// DevPage 专用的内联示例 SchoolEntry 实现。
///
/// 仅用于验证 [SchoolEntryDisplayWidget] 的统一展示路径在 DevPage 中可以被
/// 调用并渲染所有字段；**禁止**在正式客盘流程中使用。所有字段为静态文案，
/// 不依赖任何起盘计算或数据源。
class _DevSampleSchoolEntry implements SchoolEntry {
  const _DevSampleSchoolEntry();

  @override
  String get title => '调试样例：御定第一局示例条目';

  @override
  String get dayJiaZi => '甲子';

  @override
  String get juName => '子';

  @override
  int get juNumber => 1;

  @override
  List<String> get keTiNames => const ['伏吟', '元胎'];

  @override
  String get meaning => '此为 DevPage 验证用样例课义文本，仅展示统一组件渲染路径。';

  @override
  String get explanation => '此为 DevPage 验证用样例解曰文本，覆盖 explanation 字段的渲染。';

  @override
  String get prediction => '此为 DevPage 验证用样例断曰文本，覆盖 prediction 字段的渲染。';

  @override
  Map<String, String> get details => const {
        '求财': '样例求财说明，仅供 DevPage 渲染验证。',
        '出行': '样例出行说明，仅供 DevPage 渲染验证。',
      };

  @override
  Map<String, String> get bookReferences => const {
        '《御定大六壬直指》样例引文': '此处为样例经典引文文本，仅供 DevPage 验证 bookReferences 渲染。',
      };

  @override
  String get schoolId => 'yuding';
}
