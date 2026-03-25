// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaLiuRenPanConfig _$DaLiuRenPanConfigFromJson(Map<String, dynamic> json) =>
    DaLiuRenPanConfig(
      monthGeneralType: $enumDecode(
          _$CalculateMonthGeneralTypeEnumMap, json['monthGeneralType']),
      dayNightBoundaryType: $enumDecode(
          _$DayNightBoundaryTypeEnumMap, json['dayNightBoundaryType']),
      guiRenType: $enumDecode(_$GuiRenTypeEnumMap, json['guiRenType']),
      dayNight: $enumDecodeNullable(_$EnumDayNightEnumMap, json['dayNight']),
    );

Map<String, dynamic> _$DaLiuRenPanConfigToJson(DaLiuRenPanConfig instance) =>
    <String, dynamic>{
      'monthGeneralType':
          _$CalculateMonthGeneralTypeEnumMap[instance.monthGeneralType],
      'dayNightBoundaryType':
          _$DayNightBoundaryTypeEnumMap[instance.dayNightBoundaryType],
      'dayNight': _$EnumDayNightEnumMap[instance.dayNight],
      'guiRenType': _$GuiRenTypeEnumMap[instance.guiRenType]!,
    };

const _$CalculateMonthGeneralTypeEnumMap = {
  CalculateMonthGeneralType.monthJian: null,
  CalculateMonthGeneralType.monthHe: null,
  CalculateMonthGeneralType.middleQi: null,
  CalculateMonthGeneralType.chaoShen: null,
};

const _$DayNightBoundaryTypeEnumMap = {
  DayNightBoundaryType.maoYou: null,
  DayNightBoundaryType.season4: null,
  DayNightBoundaryType.sunRiseSet: null,
  DayNightBoundaryType.manual: null,
};

const _$GuiRenTypeEnumMap = {
  GuiRenType.Jia_Wu_Geng_Niu_Yang: '甲戊庚牛羊',
  GuiRenType.Jia_Wu_Jian_Niu_Yang: '甲戊兼牛羊',
  GuiRenType.Jia_Yang_Wu_Geng_Niu: '甲羊戊庚牛',
};

const _$EnumDayNightEnumMap = {
  EnumDayNight.day: '昼',
  EnumDayNight.night: '夜',
};
