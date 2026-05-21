import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daliuren_colors.dart';

abstract class DaliurenTypography {
  DaliurenTypography._();

  static TextStyle h1(double scale) => GoogleFonts.maShanZheng(
        fontSize: 22 * scale,
        color: DaliurenColors.ink,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle h2(double scale) => GoogleFonts.maShanZheng(
        fontSize: 18 * scale,
        color: DaliurenColors.ink,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle h3(double scale) => GoogleFonts.maShanZheng(
        fontSize: 14 * scale,
        color: DaliurenColors.ink,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle body(double scale) => GoogleFonts.zhiMangXing(
        fontSize: 14 * scale,
        color: DaliurenColors.ink,
        height: 1.7,
      );

  static TextStyle caption(double scale) => GoogleFonts.maShanZheng(
        fontSize: 11 * scale,
        color: DaliurenColors.textHint,
        height: 1.2,
      );

  static TextStyle tag(double scale) => GoogleFonts.maShanZheng(
        fontSize: 12 * scale,
        color: DaliurenColors.ink,
        height: 1,
      );

  static TextStyle ganZiTianGan(double scale) => GoogleFonts.zhiMangXing(
        color: const Color.fromRGBO(28, 45, 37, 1),
        fontWeight: FontWeight.w200,
        fontSize: 16 * scale,
        height: 1,
      );

  static TextStyle ganZiDiZhi(double scale) => GoogleFonts.longCang(
        color: Colors.black,
        fontSize: 16 * scale,
        height: 1,
        fontWeight: FontWeight.w500,
      );

  static TextStyle sectionLabel(double scale) => GoogleFonts.maShanZheng(
        fontSize: 13 * scale,
        color: DaliurenColors.textSecondary,
        height: 1,
      );
}