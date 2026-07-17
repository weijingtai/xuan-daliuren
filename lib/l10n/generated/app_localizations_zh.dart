// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '大六壬';

  @override
  String get daliurenOld => '大六壬(旧版)';

  @override
  String get daliurenUnknownPage => '大六壬_未知页面';

  @override
  String get taiyiShenshu => '太乙神数';

  @override
  String registeredSchoolCount(int count) {
    return '已注册 $count 个大六壬流派';
  }

  @override
  String get selectTime => '选择时间';

  @override
  String get pleaseSelectTimeToDivine => '请选择时间进行占卜';

  @override
  String get pleaseCalculateFirst => '请先排盘';

  @override
  String get basicInfo => '基本信息';

  @override
  String timeLabel(String time) {
    return '时间: $time';
  }

  @override
  String questionLabel(String question) {
    return '问题: $question';
  }

  @override
  String eightCharLabel(String eightChar) {
    return '八字: $eightChar';
  }

  @override
  String get ganZhiInfo => '干支信息';

  @override
  String get yearGanZhi => '年干支';

  @override
  String get monthGanZhi => '月干支';

  @override
  String get dayGanZhi => '日干支';

  @override
  String get timeGanZhi => '时干支';

  @override
  String get divinationPanel => '占卜盘';

  @override
  String get fourClass => '四课';

  @override
  String get firstClass => '第一课';

  @override
  String get secondClass => '第二课';

  @override
  String get thirdClass => '第三课';

  @override
  String get fourthClass => '第四课';

  @override
  String get fuYin => '伏吟';

  @override
  String get fanYin => '反吟';

  @override
  String get fourClassComplete => '四课齐备';

  @override
  String get threeClassOnly => '三课';

  @override
  String get threeChuan => '三传';

  @override
  String get nineZongMen => '九宗门';

  @override
  String get initialChuan => '初传';

  @override
  String get middleChuan => '中传';

  @override
  String get finalChuan => '末传';

  @override
  String get twelvePalaces => '十二宫位';

  @override
  String get errorOccurred => '出错了';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中...';

  @override
  String get questionOptional => '问题（可选）';

  @override
  String get questionHint => '请输入您想要占卜的问题';

  @override
  String panTitle(
    String day,
    String time,
    String yinyang,
    String ju,
    String firstSky,
  ) {
    return '$day日·$time时·$yinyang$ju局·干上$firstSky';
  }

  @override
  String panTitleShort(String day, String time, String firstSky) {
    return '$day日·$time时·干上$firstSky';
  }

  @override
  String get panSeal => '盘';

  @override
  String get year => '年';

  @override
  String get month => '月';

  @override
  String get day => '日';

  @override
  String get hour => '时';

  @override
  String get twelveGods => '十二神将';

  @override
  String dayNightGui(String dynasty) {
    return '$dynasty贵';
  }

  @override
  String chuanChen(String diZhi) {
    return '传辰$diZhi';
  }

  @override
  String monthGeneral(String diZhi) {
    return '月将$diZhi';
  }

  @override
  String get keGe => '课格';

  @override
  String get none => '无';

  @override
  String get daytime => '昼';

  @override
  String get nighttime => '夜';

  @override
  String get shenSha => '神煞';

  @override
  String get sortByType => '按类型';

  @override
  String get sortByPosition => '按宫位';

  @override
  String get auspicious => '吉';

  @override
  String get inauspicious => '凶';

  @override
  String typeLabel(String type) {
    return '类型: $type';
  }

  @override
  String positionLabel(String position) {
    return '位置: $position';
  }

  @override
  String get selectSchool => '选择流派';

  @override
  String schoolExplanation(String school) {
    return '$school 解释';
  }

  @override
  String get noMatchExplanation => '暂无匹配解释';

  @override
  String get noMatchSecondary => '当前盘面在该流派下未找到匹配条目，可尝试切回御定。';

  @override
  String get dataUnavailable => '数据不可用';

  @override
  String schoolDataLoadFailed(String schoolId) {
    return '流派数据加载失败: $schoolId';
  }

  @override
  String get noSchoolData => '暂无该流派的解释数据。';

  @override
  String get yudingFallback => '请起盘后查看御定流派解释。';

  @override
  String get schoolStatusPreparing => '正在整理中';

  @override
  String get schoolStatusAvailable => '当前可用';

  @override
  String schoolRoadmapLabel(String school, String status) {
    return '流派路线图: $school，$status';
  }

  @override
  String get schoolRoadmapSupporting =>
      '该流派正在整理中，后续版本将解锁完整解释。当前可继续在御定流派下查看本盘解释。';

  @override
  String schoolSelectedLabel(String school, String status) {
    return '$school，$status，已选中';
  }

  @override
  String schoolDeselectedLabel(String school, String status) {
    return '$school，$status';
  }

  @override
  String get keTi => '课体';

  @override
  String get conditions => '条件';

  @override
  String get nameExplanation => '释名';

  @override
  String get introduction => '总论';

  @override
  String get explanation => '详解';

  @override
  String get notes => '注意';

  @override
  String get subKeti => '子课体';

  @override
  String get pattern => '格';

  @override
  String get keYi => '课义';

  @override
  String get jieYue => '解曰';

  @override
  String get duanYue => '断曰';

  @override
  String get keYiFull => '课义：';

  @override
  String get jieYueFull => '解曰：';

  @override
  String get duanYueFull => '断曰：';

  @override
  String get ancientTextSeal => '典';

  @override
  String ancientTextTitle(String day, String num, String juname) {
    return '$day日 第$num 干上$juname';
  }

  @override
  String get chineseNumberUnit => '局';

  @override
  String get mixedDivination => '杂占：';

  @override
  String get classicReferences => '经典引用：';

  @override
  String get timeColon => '时间：';

  @override
  String get lunarLabel => '农历：';

  @override
  String lunarDate(String year, String month, String day, String time) {
    return '$year年 $month月 $day $time';
  }

  @override
  String divinationTime(String day, String time, String yinyang, String ju) {
    return '$day日·$time时·$yinyang$ju局';
  }

  @override
  String get selectTimeAction => '选择时间';

  @override
  String get nowAction => '现在';

  @override
  String get calculateAction => '排盘';

  @override
  String get cannotRepeat => '不能重复';

  @override
  String get ganZhiCalculateAction => '干支排盘';

  @override
  String get clearAction => '清除';

  @override
  String get showAnnotations => '显示注解';

  @override
  String get hideAnnotations => '隐藏注解';

  @override
  String get newVersionUi => '新版UI';

  @override
  String get dayGanZhiLabel => '日干支:';

  @override
  String get timeGanZhiLabel => '时干支:';

  @override
  String get monthGeneralLabel => '月将:';

  @override
  String get guiRenLabel => '贵人:';

  @override
  String get keTiLabel => '课体:';

  @override
  String get tianDiPanPlaceholder => '天地盘 (Placeholder):';

  @override
  String get fourClassPlaceholder => '四课 (Placeholder):';

  @override
  String get threeChuanPlaceholder => '三传 (Placeholder):';

  @override
  String get renDun => '阴阳遁';

  @override
  String get yang => '阳';

  @override
  String get yin => '阴';

  @override
  String get juNumberLabel => '局数';

  @override
  String get singleGongDetail => '单宫详情';

  @override
  String get fullPanOverview => '全盘概览';

  @override
  String get diZhiGround => '地支（地盘）';

  @override
  String get tianPan => '天盘';

  @override
  String get tianGanLabel => '天干';

  @override
  String get jiGan => '寄干';

  @override
  String get wuLabel => '（无）';

  @override
  String get gongLayoutDev => '宫位布局开发';

  @override
  String get showHideAnnotations => '隐藏注解';

  @override
  String get tianPanZhi => '天盘支';

  @override
  String get tianGanShort => '天干';

  @override
  String get tianJiang => '天将';

  @override
  String get gongGeZoom => '宫格缩放';

  @override
  String get panSize => '盘面尺寸';

  @override
  String get fourClassShort => '四';

  @override
  String get threeClassShort => '三';

  @override
  String get twoClassShort => '二';

  @override
  String get oneClassShort => '一';

  @override
  String get schoolDemoTitle => '大六壬流派演示';

  @override
  String get noData => '暂无数据';

  @override
  String get representativeBook => '代表书籍：';

  @override
  String get era => '年代：';

  @override
  String get debugEntry => '调试入口';

  @override
  String get fourClassDebug => '四课调试';

  @override
  String get multiSchoolDebug => '多流派调试';

  @override
  String get multiSchoolDebugUnified => '多流派调试 (统一组件展示路径)';

  @override
  String get loadEntriesFailed => '加载条目失败';
}
