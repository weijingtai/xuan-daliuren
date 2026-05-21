import 'package:flutter/material.dart';

class DaliurenColors {
  DaliurenColors._();

  static const ink = Color.fromRGBO(68, 68, 60, 1);
  static const paper = Color.fromRGBO(255, 251, 240, 1);
  static const sealRed = Color.fromRGBO(176, 31, 36, 1);
  static const sealRedLight = Color.fromRGBO(176, 31, 36, .06);
  static const sealRedBorder = Color.fromRGBO(176, 31, 36, .2);
  static const dividerGradient = Color.fromRGBO(68, 68, 60, .15);

  static const textPrimary = ink;
  static const textSecondary = Color.fromRGBO(68, 68, 60, .6);
  static const textHint = Color.fromRGBO(68, 68, 60, .35);

  static const bgPaper = paper;
  static const bgElevated = Colors.white;
  static const bgCard = Color.fromRGBO(255, 251, 240, .6);

 static Color auspicious(DaliurenOpacity opacity) =>
 Color.fromRGBO(76, 175, 80, opacity.opacity);
 static Color inauspicious(DaliurenOpacity opacity) =>
 Color.fromRGBO(244, 67, 54, opacity.opacity);
 static Color neutral(DaliurenOpacity opacity) =>
 Color.fromRGBO(158, 158, 158, opacity.opacity);
}

class DaliurenOpacity {
 final double opacity;
 const DaliurenOpacity(this.opacity);
 factory DaliurenOpacity.bg() => const DaliurenOpacity(.1);
 factory DaliurenOpacity.border() => const DaliurenOpacity(.3);
 factory DaliurenOpacity.text() => const DaliurenOpacity(.85);
}