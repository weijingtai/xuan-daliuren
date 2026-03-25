import 'package:json_annotation/json_annotation.dart';

/// 贵人口诀类型（从 calculate_month_general_service.dart 提取）
enum GuiRenType {
  // 甲戊庚牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸蛇兔藏，六辛逢虎马，此是贵人方

  @JsonValue("甲戊庚牛羊")
  Jia_Wu_Geng_Niu_Yang(
      number: 1,
      name: "甲戊庚牛羊",
      details: "甲戊庚牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸蛇兔藏，六辛逢虎马，此是贵人方。",
      specification: "干系统一规则，卯酉分昼夜（卯时日出为昼始，酉时日落为夜始）。",
      description: "历史最久，占验案例丰富（如宋代邵彦和《断案》）;"),

// 甲戊兼牛羊，乙己鼠猴鄉，丙丁豬雞位，壬癸兔蛇藏，庚辛逢馬虎，此是貴人方。
  @JsonValue("甲戊兼牛羊")
  Jia_Wu_Jian_Niu_Yang(
      number: 2,
      name: "甲戊兼牛羊",
      specification: "将庚日并入辛日规则，形成“庚辛逢马虎”，其他与第一口诀一致。",
      details: "甲戊兼牛羊，乙己鼠猴鄉，丙丁豬雞位，壬癸兔蛇藏，庚辛逢馬虎，此是貴人方。",
      description:
          "此口诀最早见于唐代《太白阴经》，但属后世调整：为使十干分配均匀，强行将庚日贵人移至午/寅，缺乏早期占例支持;在八字命理中流传较广，但六壬体系较少采用"),

// 甲羊戊庚牛，乙猴己鼠游，丙鸡丁猪位，壬兔癸蛇头，六辛逢虎上，阳贵此中求。
  @JsonValue("甲羊戊庚牛")
  Jia_Yang_Wu_Geng_Niu(
      number: 3,
      name: "甲羊戊庚牛",
      specification: "干系独立定位，子午分阴阳（子至巳为阳时，午至亥为阴时），以“干合理论”推导。",
      details: "甲羊戊庚牛，乙猴己鼠游，丙鸡丁猪位，壬兔癸蛇头，六辛逢虎上，阳贵此中求。",
      description:
          "清代官方修订（《御定六壬直指》），以“岁差修正”为名，但未解决岁差实际影响（如未修正汉代分野）；需配套子午分界规则，不可与传统派混用");

  final int number;
  final String name;
  final String details;
  final String specification;
  final String description;
  const GuiRenType(
      {required this.number,
      required this.name,
      required this.details,
      required this.specification,
      required this.description});
}
