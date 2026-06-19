import 'package:theme/theme.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/da_liu_ren_gong.dart';
import '../../model/da_liu_ren_ke_pan.dart';
import '../../model/enum_gui_ren.dart';

// ignore: must_be_immutable
class KePanInfoCard extends StatelessWidget {
  final DaLiuRenKePan kePan;
  final int? juNumber;
  final List<String> keTiNames;
  final double scaleFactor;
  final String iconsAssetPath;

  KePanInfoCard({
    super.key,
    required this.kePan,
    this.juNumber,
    this.keTiNames = const [],
    this.scaleFactor = 1.0,
    this.iconsAssetPath = "icons",
  });

  // Mutable fields initialized in build() before sub-methods run.
  Color _ink = _defaultInk;
  Color _bg = _defaultBg;
  Color _sealRedBase = _defaultSealRedBase;

  static const _defaultInk = Color.fromRGBO(68, 68, 60, 1);
  static const _defaultBg = Color.fromRGBO(255, 251, 240, 1);
  static const _defaultSealRedBase = Color.fromRGBO(176, 31, 36, 1);

  @override
  Widget build(BuildContext context) {
    final style = XuanThemeData.maybeOf(context)?.component('daliuren_ke_pan_card');
    _ink = style?.border?.color ?? _defaultInk;
    _bg = style?.background ?? _defaultBg;
    _sealRedBase = style?.border?.color ?? _defaultSealRedBase;

    final dayName = kePan.dayJiaZi.name;
    final shichen = kePan.timeJiaZi.diZhi.name;
    final yinyang = kePan.isDayGuiRen ? "阳" : "阴";
    final juStr = juNumber != null
        ? ConstResourcesMapper.chineseNumberMapper[juNumber]!
        : "";
 final firstSky = kePan.fourClass.first.sky.name;

    return Card(
      elevation: 6,
      color: _bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16 * scaleFactor),
        side: BorderSide(color: _ink.withValues(alpha: .12), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16 * scaleFactor, vertical: 14 * scaleFactor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleRow(dayName, shichen, yinyang, juStr, firstSky),
            SizedBox(height: 14 * scaleFactor),
            _buildDivider(),
            SizedBox(height: 14 * scaleFactor),
            _buildEightCharRow(),
            SizedBox(height: 10 * scaleFactor),
            _buildDivider(),
            SizedBox(height: 14 * scaleFactor),
            _buildGodsGrid(),
            if (keTiNames.isNotEmpty) ...[
              SizedBox(height: 14 * scaleFactor),
              _buildDivider(),
              SizedBox(height: 12 * scaleFactor),
              _buildKeGeRow(),
            ],
          ],
        ),
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
            _ink.withValues(alpha: .15),
            _ink.withValues(alpha: .15),
            Colors.transparent,
          ],
          stops: const [0, .3, .7, 1],
        ),
      ),
    );
  }

  Widget _buildTitleRow(
      String day, String shi, String yinyang, String ju, String firstSky) {
 final title = ju.isNotEmpty
 ? "$day日·$shi时·$yinyang$ju局·干上$firstSky"
 : "$day日·$shi时·干上$firstSky";

    return Column(
      children: [
        Container(
          width: 28 * scaleFactor,
          height: 28 * scaleFactor,
          decoration: BoxDecoration(
            color: _sealRedBase.withValues(alpha: .85),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            "盘",
            style: GoogleFonts.maShanZheng(
              fontSize: 18 * scaleFactor,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
        SizedBox(height: 8 * scaleFactor),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.maShanZheng(
            fontSize: 17 * scaleFactor,
            color: _ink,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildEightCharRow() {
    final pan = kePan;
    return Row(
      children: [
        Expanded(
          child: _infoChip(
            label: "年",
            tianGan: pan.yearJiaZi.tianGan.value,
            diZhi: pan.yearJiaZi.diZhi.value,
            ganColor: ConstResourcesMapper.zodiacGanColors[pan.yearJiaZi.tianGan]!,
            zhiColor: ConstResourcesMapper.zodiacZhiColors[pan.yearJiaZi.diZhi]!,
          ),
        ),
        SizedBox(width: 2 * scaleFactor),
        Expanded(
          child: _infoChip(
            label: "月",
            tianGan: pan.monthJiaZi.tianGan.value,
            diZhi: pan.monthJiaZi.diZhi.value,
            ganColor: ConstResourcesMapper.zodiacGanColors[pan.monthJiaZi.tianGan]!,
            zhiColor: ConstResourcesMapper.zodiacZhiColors[pan.monthJiaZi.diZhi]!,
          ),
        ),
        SizedBox(width: 2 * scaleFactor),
        Expanded(
          child: _infoChip(
            label: "日",
            tianGan: pan.dayJiaZi.tianGan.value,
            diZhi: pan.dayJiaZi.diZhi.value,
            ganColor: ConstResourcesMapper.zodiacGanColors[pan.dayJiaZi.tianGan]!,
            zhiColor: ConstResourcesMapper.zodiacZhiColors[pan.dayJiaZi.diZhi]!,
            highlight: true,
          ),
        ),
        SizedBox(width: 2 * scaleFactor),
        Expanded(
          child: _infoChip(
            label: "时",
            tianGan: pan.timeJiaZi.tianGan.value,
            diZhi: pan.timeJiaZi.diZhi.value,
            ganColor: ConstResourcesMapper.zodiacGanColors[pan.timeJiaZi.tianGan]!,
            zhiColor: ConstResourcesMapper.zodiacZhiColors[pan.timeJiaZi.diZhi]!,
          ),
        ),
      ],
    );
  }

  Widget _infoChip({
    required String label,
    required String tianGan,
    required String diZhi,
    required Color ganColor,
    required Color zhiColor,
    bool highlight = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 4 * scaleFactor, vertical: 6 * scaleFactor),
      decoration: BoxDecoration(
        color: highlight
            ? _sealRedBase.withValues(alpha: .06)
            : Colors.white.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(8 * scaleFactor),
        border: Border.all(
          color: highlight
              ? _sealRedBase.withValues(alpha: .25)
              : _ink.withValues(alpha: .08),
          width: highlight ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.maShanZheng(
              fontSize: 10 * scaleFactor,
              color: Colors.grey,
              height: 1,
            ),
          ),
          SizedBox(height: 2 * scaleFactor),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tianGan,
                  style: constUIResourcesMapperTianGanStyle().copyWith(
                    fontSize: 16 * scaleFactor,
                    color: ganColor.withValues(alpha: .7),
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: diZhi,
                  style: constUIResourcesMapperDiZhiStyle().copyWith(
                    fontSize: 16 * scaleFactor,
                    color: zhiColor.withValues(alpha: .8),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGodsGrid() {
    final gongMapper = kePan.gongMapper;
    final dynastyStr = _dynasty();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3 * scaleFactor,
              height: 14 * scaleFactor,
              decoration: BoxDecoration(
                color: _sealRedBase.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 6 * scaleFactor),
            Text(
              "十二神将",
              style: GoogleFonts.maShanZheng(
                fontSize: 14 * scaleFactor,
                color: _ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _buildMiniTag("$dynastyStr贵"),

          ],
        ),

        _buildMiniTag("传辰${kePan.guiRenDiZhi.name}"),

        _buildMiniTag("月将${kePan.monthGeneral.generalZhi.name}"),
        _buildMiniTag(kePan.monthGeneral.name),
        SizedBox(height: 10 * scaleFactor),
        _godsTable(gongMapper),
      ],
    );
  }

  Widget _godsTable(Map<DiZhi, DaLiuRenGong> gongMapper) {
    final diZhiOrder = [
      DiZhi.SI, DiZhi.WU, DiZhi.WEI, DiZhi.SHEN,
      DiZhi.CHEN, DiZhi.YOU,
      DiZhi.MAO, DiZhi.XU,
      DiZhi.YIN, DiZhi.CHOU, DiZhi.ZI, DiZhi.HAI,
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        for (int row = 0; row < 3; row++)
          TableRow(
            children: [
              for (int col = 0; col < 4; col++)
                _godCell(diZhiOrder[row * 4 + col], gongMapper),
            ],
          ),
      ],
    );
  }

 Widget _godCell(DiZhi diZhi, Map<DiZhi, DaLiuRenGong> gongMapper) {
 final gong = gongMapper[diZhi];
 final guiRen = gong?.guiRen;
    final godName = guiRen?.name ?? "—";
    final isGuiRen = guiRen == GuiRen.GUI_REN;
    final isGuiRenPos = diZhi == kePan.guiRenDiZhi;

    return Container(
      margin: EdgeInsets.all(2 * scaleFactor),
      padding: EdgeInsets.symmetric(
          horizontal: 3 * scaleFactor, vertical: 5 * scaleFactor),
      decoration: BoxDecoration(
        color: isGuiRen
            ? _sealRedBase.withValues(alpha: .08)
            : Colors.white.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(6 * scaleFactor),
        border: Border.all(
          color: isGuiRen
              ? _sealRedBase.withValues(alpha: .35)
              : _ink.withValues(alpha: .08),
          width: isGuiRen ? 1.5 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            godName,
            style: GoogleFonts.maShanZheng(
              fontSize: 12 * scaleFactor,
              color: isGuiRen
                  ? _sealRedBase.withValues(alpha: .9)
                  : _ink,
              fontWeight: isGuiRen ? FontWeight.w700 : FontWeight.w400,
              height: 1,
            ),
          ),
          SizedBox(height: 2 * scaleFactor),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 4 * scaleFactor, vertical: 1 * scaleFactor),
            decoration: BoxDecoration(
              color: isGuiRenPos
                  ? _sealRedBase.withValues(alpha: .12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
              border: isGuiRenPos
                  ? Border.all(
                      color: _sealRedBase.withValues(alpha: .25),
                      width: 1)
                  : null,
            ),
            child: Text(
              diZhi.name,
              style: GoogleFonts.maShanZheng(
                fontSize: 9 * scaleFactor,
                color: isGuiRenPos
                    ? _sealRedBase.withValues(alpha: .8)
                    : Colors.grey.shade500,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeGeRow() {
 final jieItem1 = kePan.monthGeneral.jieSegment.item1.name;
 final jieItem2 = kePan.monthGeneral.jieSegment.item2.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3 * scaleFactor,
              height: 14 * scaleFactor,
              decoration: BoxDecoration(
                color: _sealRedBase.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 6 * scaleFactor),
            Text(
              "课格",
              style: GoogleFonts.maShanZheng(
                fontSize: 14 * scaleFactor,
                color: _ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10 * scaleFactor),
            _buildMiniTag("$jieItem1 $jieItem2"),
          ],
        ),
        SizedBox(height: 8 * scaleFactor),
        if (keTiNames.isNotEmpty)
          Wrap(
            spacing: 8 * scaleFactor,
            runSpacing: 6 * scaleFactor,
            children: keTiNames.map((name) {
              return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10 * scaleFactor, vertical: 4 * scaleFactor),
                decoration: BoxDecoration(
                  color: _sealRedBase.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(6 * scaleFactor),
                  border: Border.all(
                    color: _sealRedBase.withValues(alpha: .2),
                    width: 1,
                  ),
                ),
                child: Text(
                  name,
                  style: GoogleFonts.zhiMangXing(
                    fontSize: 14 * scaleFactor,
                    color: _ink,
                    height: 1,
                  ),
                ),
              );
            }).toList(),
          )
        else
          Text(
            "无",
            style: GoogleFonts.zhiMangXing(
              fontSize: 13 * scaleFactor,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  Widget _buildMiniTag(String text) {
    return Container(
      margin: EdgeInsets.only(top: 6 * scaleFactor),
      padding:
          EdgeInsets.symmetric(horizontal: 8 * scaleFactor, vertical: 3 * scaleFactor),
      decoration: BoxDecoration(
        color: _sealRedBase.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(4 * scaleFactor),
        border: Border.all(
          color: _sealRedBase.withValues(alpha: .15),
          width: .5,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.maShanZheng(
          fontSize: 12 * scaleFactor,
          color: _ink.withValues(alpha: .8),
          height: 1,
        ),
      ),
    );
  }

  String _dynasty() {
    final timeDiZhi = kePan.timeJiaZi.diZhi;
    final isDay = const [
      DiZhi.MAO,
      DiZhi.CHEN,
      DiZhi.SI,
      DiZhi.WU,
      DiZhi.WEI,
      DiZhi.SHEN
    ].contains(timeDiZhi);
    return isDay ? "昼" : "夜";
  }
}

TextStyle constUIResourcesMapperTianGanStyle() {
  return GoogleFonts.zhiMangXing(
    color: const Color.fromRGBO(28, 45, 37, 1),
    fontWeight: FontWeight.w200,
    height: 1,
  );
}

TextStyle constUIResourcesMapperDiZhiStyle() {
  return GoogleFonts.longCang(
    color: Colors.black,
    height: 1,
    fontWeight: FontWeight.w500,
  );
}