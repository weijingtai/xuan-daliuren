import 'package:daliuren/model/three_chuan.dart';
import 'package:daliuren/model/three_chuan_detail_type.dart';
import 'package:json_annotation/json_annotation.dart';

import 'each_chuan.dart';
import 'enum_nine_zong_men.dart';
part 'three_chuan_she_hai.g.dart';

@JsonSerializable()
class ThreeChuanSheHai extends ThreeChuan {
  SheHaiType type;
  ThreeChuanSheHai({
    required this.type,
    required super.first,
    required super.second,
    required super.third,
  }) : super(
            nineZongMen: NineZongMen.SHE_HAI);

  factory ThreeChuanSheHai.fromJson(Map<String, dynamic> json) =>
      _$ThreeChuanSheHaiFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ThreeChuanSheHaiToJson(this);
}
