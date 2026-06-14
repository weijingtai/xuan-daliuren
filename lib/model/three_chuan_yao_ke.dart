import 'package:daliuren/model/three_chuan.dart';
import 'package:daliuren/model/three_chuan_detail_type.dart';
import 'package:json_annotation/json_annotation.dart';

import 'each_chuan.dart';
import 'enum_nine_zong_men.dart';
part 'three_chuan_yao_ke.g.dart';

@JsonSerializable()
class ThreeChuanYaoKe extends ThreeChuan {
  YaoKeType? type;
  bool? isBiYong;
  SheHaiType? sheHaiType;
  ThreeChuanYaoKe(
      {this.type,
      required super.first,
      required super.second,
      required super.third,
      this.isBiYong,
      this.sheHaiType})
      : super(
            nineZongMen: NineZongMen.YAO_KE);
  factory ThreeChuanYaoKe.fromJson(Map<String, dynamic> json) =>
      _$ThreeChuanYaoKeFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ThreeChuanYaoKeToJson(this);
}
