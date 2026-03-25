/// Represents the complete Liu Ren divination盤 (Pan).
/// This is a core domain entity holding all calculated and contextual information of a divination.
import 'package:common/enums.dart';
import 'package:daliuren/domain/entities/raw_pan_info_model.dart';
import 'package:daliuren/model/da_liu_ren_gong.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:daliuren/model/each_chuan.dart';
import 'package:daliuren/model/enum_nine_zong_men.dart';
import 'package:daliuren/domain/enums/pan_type.dart';

part 'liu_ren_pan_model.g.dart';

@JsonSerializable()

/// Core domain entity representing a fully calculated Liu Ren Pan.
class LiuRenPanModel {
  /// Name of the Day JiaZi (e.g., "甲子").
  final JiaZi dayJiaZi;

  /// Full GanZhi of the time (e.g., "丙寅").
  final JiaZi timeGanZhi;

  /// Name of the ShiChen DiZhi (e.g., "子").
  DiZhi get timeChen => timeGanZhi.zhi;

  PanType panType;

  /// Name of the YueJiang (Month General, e.g., "登明").
  final MonthGeneral monthGeneral;

  /// Type of GuiRen used (e.g., "阳贵人", "昼贵", "夜贵").
  final EnumDayNight dayNight;

  /// List of the Four Classes (四课).
  final List<RawEachClass> fourClasses;

  /// List of the Three Transmissions (三传).
  final List<EachChuan> threeChuans;

  /// The primary KeTi (课体) determined by NineZongMen rules.
  final NineZongMen nineZongMen;

  /// Additional descriptive KeTi names (e.g., "伏吟", "八专").
  final List<String> keTiComplement;

  final Map<DiZhi, DaLiuRenGong> gongMapper;

  /// The Ju (局数) used or calculated for this pan, if applicable.
  final int ju;
  final List<String> patternName;

  final DiZhi guiRenLocation;

  LiuRenPanModel({
    required this.dayJiaZi,
    required this.timeGanZhi,
    required this.fourClasses,
    required this.threeChuans,
    required this.nineZongMen,
    required this.monthGeneral,
    required this.dayNight,
    this.keTiComplement = const [],
    required this.ju,
    required this.panType,
    required this.guiRenLocation,
    required this.gongMapper,
    required this.patternName,
  });

  factory LiuRenPanModel.fromJson(Map<String, dynamic> json) =>
      _$LiuRenPanModelFromJson(json);
  Map<String, dynamic> toJson() => _$LiuRenPanModelToJson(this);
}
