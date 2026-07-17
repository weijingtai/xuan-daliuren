import 'package:theme/theme.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/four_class.dart';

class FourClassCard extends StatelessWidget {
  final FourClass fourClass;
  final Size gongSize;
  final double scaleFactor;

  const FourClassCard({
    super.key,
    required this.fourClass,
    required this.gongSize,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = XuanThemeData.maybeOf(context)?.component('daliuren_four_class_card');
    final bg = style?.background ?? Colors.white;
    final titleColor = style?.border?.color ?? Colors.blueGrey;
    final radius = style?.radius ?? 12;
    final textColor = style?.border?.color ?? const Color.fromRGBO(68, 68, 60, 1);

    return Card(
      elevation: 2,
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: Padding(
        padding: EdgeInsets.all(8 * scaleFactor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.fourClass,
              style: GoogleFonts.maShanZheng(
                fontSize: 18 * scaleFactor,
                color: titleColor,
              ),
            ),
            SizedBox(height: 8 * scaleFactor),
            _buildContent(textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    double diZhiFontSize = gongSize.width * .24;
    final l10n = AppLocalizations.of(context)!;

    TextStyle tianGanStyle = ConstUIResourcesMapper.tianGanTextStyle.copyWith(
      fontSize: diZhiFontSize,
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

    TextStyle guiRenNameStyle = GoogleFonts.maShanZheng(
      fontSize: gongSize.width * .14,
      color: textColor,
      height: 1.0,
      shadows: [
        Shadow(
          color: Colors.grey.withValues(alpha: .5),
          blurRadius: 2,
          offset: const Offset(0, 0),
        ),
      ],
    );

    SizedBox intervalSize = SizedBox(width: 6 * scaleFactor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildClassColumn(
            l10n.fourClassShort, fourClass.fourth.guiRen.name, fourClass.fourth.sky,
            fourClass.fourth.ground, guiRenNameStyle, diZhiStyle),
        intervalSize,
        _buildClassColumn(
            l10n.threeClassShort, fourClass.third.guiRen.name, fourClass.third.sky,
            fourClass.third.ground, guiRenNameStyle, diZhiStyle),
        intervalSize,
        _buildClassColumn(
            l10n.twoClassShort, fourClass.second.guiRen.name, fourClass.second.sky,
            fourClass.second.ground, guiRenNameStyle, diZhiStyle),
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
                    l10n.oneClassShort,
                    style: GoogleFonts.maShanZheng(
                      height: 1,
                      fontSize: 18 * scaleFactor,
                    ),
                  ),
                  Text(fourClass.first.guiRen.name, style: guiRenNameStyle),
                  Center(
                    child: Text(fourClass.first.sky.value,
                        style: diZhiStyle.copyWith(
                            color: ConstResourcesMapper.zodiacZhiColors[
                                fourClass.first.sky]!
                                .withValues(alpha: .8))),
                  ),
                  Center(
                    child: Text(fourClass.first.tianGan.value,
                        style: tianGanStyle.copyWith(
                            color: ConstResourcesMapper.zodiacGanColors[
                                fourClass.first.tianGan]!
                                .withValues(alpha: .6))),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(fourClass.first.ground.value,
                    style: diZhiStyle.copyWith(
                        color: ConstResourcesMapper.zodiacZhiColors[
                            fourClass.first.ground]!
                            .withValues(alpha: .8),
                        fontSize: gongSize.width * .16)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassColumn(
    String numberLabel,
    String guiRenNameStr,
    DiZhi sky,
    DiZhi ground,
    TextStyle guiRenNameStyle,
    TextStyle diZhiStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          numberLabel,
          style: GoogleFonts.maShanZheng(
            height: 1,
            fontSize: 18 * scaleFactor,
          ),
        ),
        Text(guiRenNameStr, style: guiRenNameStyle),
        Text(sky.value,
            style: diZhiStyle.copyWith(
                color: ConstResourcesMapper.zodiacZhiColors[sky]!
                    .withValues(alpha: .8))),
        Text(ground.value,
            style: diZhiStyle.copyWith(
                color: ConstResourcesMapper.zodiacZhiColors[ground]!
                    .withValues(alpha: .8))),
      ],
    );
  }
}