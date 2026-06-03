import 'package:theme/const_resources_mapper.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:xuan_common/widgets/const_ui_resources_mapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/three_chuan.dart';

class ThreeChuanCard extends StatelessWidget {
  final ThreeChuan threeChuan;
  final Size gongSize;
  final double scaleFactor;
  final String iconsAssetPath;

  const ThreeChuanCard({
    super.key,
    required this.threeChuan,
    required this.gongSize,
    required this.scaleFactor,
    this.iconsAssetPath = "icons",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(8 * scaleFactor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "三传",
              style: GoogleFonts.maShanZheng(
                fontSize: 18 * scaleFactor,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 8 * scaleFactor),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    double diZhiFontSize = gongSize.width * .24;
    TextStyle otherStyle = GoogleFonts.maShanZheng(
      fontSize: gongSize.width * .16,
      color: const Color.fromRGBO(68, 68, 60, 1),
      height: 1.0,
      shadows: [
        Shadow(
          color: Colors.grey.withValues(alpha: .5),
          blurRadius: 2,
          offset: const Offset(0, 0),
        ),
      ],
    );

    TextStyle tianGanStyle = ConstUIResourcesMapper.tianGanTextStyle.copyWith(
      fontSize: gongSize.width * .2,
      shadows: [
        Shadow(
          color: Colors.grey.withValues(alpha: .5),
          blurRadius: 2,
          offset: const Offset(0, 0),
        ),
      ],
    );

    TextStyle diZhiStyle = ConstUIResourcesMapper.twelveDiZhiTextStyle.copyWith(
      fontSize: diZhiFontSize,
      shadows: [
        Shadow(
          color: Colors.grey.withValues(alpha: .5),
          blurRadius: 2,
          offset: const Offset(0, 0),
        ),
      ],
    );

    SizedBox offset = SizedBox(width: 4 * scaleFactor);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildChuanRow(
          "初", threeChuan.first, otherStyle, tianGanStyle, diZhiStyle, offset),
        _buildChuanRow(
          "中", threeChuan.second, otherStyle, tianGanStyle, diZhiStyle, offset),
        _buildChuanRow(
          "末", threeChuan.third, otherStyle, tianGanStyle, diZhiStyle, offset),
      ],
    );
  }

  Widget _buildChuanRow(
    String label,
    dynamic chuan,
    TextStyle otherStyle,
    TextStyle tianGanStyle,
    TextStyle diZhiStyle,
    SizedBox offset,
  ) {
    final liuQinName = chuan.liuQin.name as String;
    final tianGan = chuan.tianGan as TianGan?;
    final diZhi = chuan.diZhi as DiZhi;
    final guiRenName = chuan.guiRen.name as String;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: otherStyle),
        offset,
        Text(liuQinName, style: otherStyle),
        offset,
        tianGan == null
            ? _buildKongWangCircle(otherStyle.color, 16 * scaleFactor)
            : Text(tianGan.value,
                style: tianGanStyle.copyWith(
                    color: ConstResourcesMapper.zodiacGanColors[tianGan]!
                        .withValues(alpha: .6))),
        Text(diZhi.value,
            style: diZhiStyle.copyWith(
                color: ConstResourcesMapper.zodiacZhiColors[diZhi]!
                    .withValues(alpha: .8))),
        offset,
        Text(guiRenName, style: otherStyle),
      ],
    );
  }

  Widget _buildKongWangCircle(Color? color, double size) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color ?? Colors.blueGrey, BlendMode.srcIn),
      child: Image.asset(
        "$iconsAssetPath/thin-black-ink-circle.png",
        width: size,
        height: size,
      ),
    );
  }
}