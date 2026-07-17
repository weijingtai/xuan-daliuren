import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'大六壬'**
  String get appTitle;

  /// No description provided for @daliurenOld.
  ///
  /// In zh, this message translates to:
  /// **'大六壬(旧版)'**
  String get daliurenOld;

  /// No description provided for @daliurenUnknownPage.
  ///
  /// In zh, this message translates to:
  /// **'大六壬_未知页面'**
  String get daliurenUnknownPage;

  /// No description provided for @taiyiShenshu.
  ///
  /// In zh, this message translates to:
  /// **'太乙神数'**
  String get taiyiShenshu;

  /// No description provided for @registeredSchoolCount.
  ///
  /// In zh, this message translates to:
  /// **'已注册 {count} 个大六壬流派'**
  String registeredSchoolCount(int count);

  /// No description provided for @selectTime.
  ///
  /// In zh, this message translates to:
  /// **'选择时间'**
  String get selectTime;

  /// No description provided for @pleaseSelectTimeToDivine.
  ///
  /// In zh, this message translates to:
  /// **'请选择时间进行占卜'**
  String get pleaseSelectTimeToDivine;

  /// No description provided for @pleaseCalculateFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先排盘'**
  String get pleaseCalculateFirst;

  /// No description provided for @basicInfo.
  ///
  /// In zh, this message translates to:
  /// **'基本信息'**
  String get basicInfo;

  /// No description provided for @timeLabel.
  ///
  /// In zh, this message translates to:
  /// **'时间: {time}'**
  String timeLabel(String time);

  /// No description provided for @questionLabel.
  ///
  /// In zh, this message translates to:
  /// **'问题: {question}'**
  String questionLabel(String question);

  /// No description provided for @eightCharLabel.
  ///
  /// In zh, this message translates to:
  /// **'八字: {eightChar}'**
  String eightCharLabel(String eightChar);

  /// No description provided for @ganZhiInfo.
  ///
  /// In zh, this message translates to:
  /// **'干支信息'**
  String get ganZhiInfo;

  /// No description provided for @yearGanZhi.
  ///
  /// In zh, this message translates to:
  /// **'年干支'**
  String get yearGanZhi;

  /// No description provided for @monthGanZhi.
  ///
  /// In zh, this message translates to:
  /// **'月干支'**
  String get monthGanZhi;

  /// No description provided for @dayGanZhi.
  ///
  /// In zh, this message translates to:
  /// **'日干支'**
  String get dayGanZhi;

  /// No description provided for @timeGanZhi.
  ///
  /// In zh, this message translates to:
  /// **'时干支'**
  String get timeGanZhi;

  /// No description provided for @divinationPanel.
  ///
  /// In zh, this message translates to:
  /// **'占卜盘'**
  String get divinationPanel;

  /// No description provided for @fourClass.
  ///
  /// In zh, this message translates to:
  /// **'四课'**
  String get fourClass;

  /// No description provided for @firstClass.
  ///
  /// In zh, this message translates to:
  /// **'第一课'**
  String get firstClass;

  /// No description provided for @secondClass.
  ///
  /// In zh, this message translates to:
  /// **'第二课'**
  String get secondClass;

  /// No description provided for @thirdClass.
  ///
  /// In zh, this message translates to:
  /// **'第三课'**
  String get thirdClass;

  /// No description provided for @fourthClass.
  ///
  /// In zh, this message translates to:
  /// **'第四课'**
  String get fourthClass;

  /// No description provided for @fuYin.
  ///
  /// In zh, this message translates to:
  /// **'伏吟'**
  String get fuYin;

  /// No description provided for @fanYin.
  ///
  /// In zh, this message translates to:
  /// **'反吟'**
  String get fanYin;

  /// No description provided for @fourClassComplete.
  ///
  /// In zh, this message translates to:
  /// **'四课齐备'**
  String get fourClassComplete;

  /// No description provided for @threeClassOnly.
  ///
  /// In zh, this message translates to:
  /// **'三课'**
  String get threeClassOnly;

  /// No description provided for @threeChuan.
  ///
  /// In zh, this message translates to:
  /// **'三传'**
  String get threeChuan;

  /// No description provided for @nineZongMen.
  ///
  /// In zh, this message translates to:
  /// **'九宗门'**
  String get nineZongMen;

  /// No description provided for @initialChuan.
  ///
  /// In zh, this message translates to:
  /// **'初传'**
  String get initialChuan;

  /// No description provided for @middleChuan.
  ///
  /// In zh, this message translates to:
  /// **'中传'**
  String get middleChuan;

  /// No description provided for @finalChuan.
  ///
  /// In zh, this message translates to:
  /// **'末传'**
  String get finalChuan;

  /// No description provided for @twelvePalaces.
  ///
  /// In zh, this message translates to:
  /// **'十二宫位'**
  String get twelvePalaces;

  /// No description provided for @errorOccurred.
  ///
  /// In zh, this message translates to:
  /// **'出错了'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get loading;

  /// No description provided for @questionOptional.
  ///
  /// In zh, this message translates to:
  /// **'问题（可选）'**
  String get questionOptional;

  /// No description provided for @questionHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入您想要占卜的问题'**
  String get questionHint;

  /// No description provided for @panTitle.
  ///
  /// In zh, this message translates to:
  /// **'{day}日·{time}时·{yinyang}{ju}局·干上{firstSky}'**
  String panTitle(
    String day,
    String time,
    String yinyang,
    String ju,
    String firstSky,
  );

  /// No description provided for @panTitleShort.
  ///
  /// In zh, this message translates to:
  /// **'{day}日·{time}时·干上{firstSky}'**
  String panTitleShort(String day, String time, String firstSky);

  /// No description provided for @panSeal.
  ///
  /// In zh, this message translates to:
  /// **'盘'**
  String get panSeal;

  /// No description provided for @year.
  ///
  /// In zh, this message translates to:
  /// **'年'**
  String get year;

  /// No description provided for @month.
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get month;

  /// No description provided for @day.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In zh, this message translates to:
  /// **'时'**
  String get hour;

  /// No description provided for @twelveGods.
  ///
  /// In zh, this message translates to:
  /// **'十二神将'**
  String get twelveGods;

  /// No description provided for @dayNightGui.
  ///
  /// In zh, this message translates to:
  /// **'{dynasty}贵'**
  String dayNightGui(String dynasty);

  /// No description provided for @chuanChen.
  ///
  /// In zh, this message translates to:
  /// **'传辰{diZhi}'**
  String chuanChen(String diZhi);

  /// No description provided for @monthGeneral.
  ///
  /// In zh, this message translates to:
  /// **'月将{diZhi}'**
  String monthGeneral(String diZhi);

  /// No description provided for @keGe.
  ///
  /// In zh, this message translates to:
  /// **'课格'**
  String get keGe;

  /// No description provided for @none.
  ///
  /// In zh, this message translates to:
  /// **'无'**
  String get none;

  /// No description provided for @daytime.
  ///
  /// In zh, this message translates to:
  /// **'昼'**
  String get daytime;

  /// No description provided for @nighttime.
  ///
  /// In zh, this message translates to:
  /// **'夜'**
  String get nighttime;

  /// No description provided for @shenSha.
  ///
  /// In zh, this message translates to:
  /// **'神煞'**
  String get shenSha;

  /// No description provided for @sortByType.
  ///
  /// In zh, this message translates to:
  /// **'按类型'**
  String get sortByType;

  /// No description provided for @sortByPosition.
  ///
  /// In zh, this message translates to:
  /// **'按宫位'**
  String get sortByPosition;

  /// No description provided for @auspicious.
  ///
  /// In zh, this message translates to:
  /// **'吉'**
  String get auspicious;

  /// No description provided for @inauspicious.
  ///
  /// In zh, this message translates to:
  /// **'凶'**
  String get inauspicious;

  /// No description provided for @typeLabel.
  ///
  /// In zh, this message translates to:
  /// **'类型: {type}'**
  String typeLabel(String type);

  /// No description provided for @positionLabel.
  ///
  /// In zh, this message translates to:
  /// **'位置: {position}'**
  String positionLabel(String position);

  /// No description provided for @selectSchool.
  ///
  /// In zh, this message translates to:
  /// **'选择流派'**
  String get selectSchool;

  /// No description provided for @schoolExplanation.
  ///
  /// In zh, this message translates to:
  /// **'{school} 解释'**
  String schoolExplanation(String school);

  /// No description provided for @noMatchExplanation.
  ///
  /// In zh, this message translates to:
  /// **'暂无匹配解释'**
  String get noMatchExplanation;

  /// No description provided for @noMatchSecondary.
  ///
  /// In zh, this message translates to:
  /// **'当前盘面在该流派下未找到匹配条目，可尝试切回御定。'**
  String get noMatchSecondary;

  /// No description provided for @dataUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'数据不可用'**
  String get dataUnavailable;

  /// No description provided for @schoolDataLoadFailed.
  ///
  /// In zh, this message translates to:
  /// **'流派数据加载失败: {schoolId}'**
  String schoolDataLoadFailed(String schoolId);

  /// No description provided for @noSchoolData.
  ///
  /// In zh, this message translates to:
  /// **'暂无该流派的解释数据。'**
  String get noSchoolData;

  /// No description provided for @yudingFallback.
  ///
  /// In zh, this message translates to:
  /// **'请起盘后查看御定流派解释。'**
  String get yudingFallback;

  /// No description provided for @schoolStatusPreparing.
  ///
  /// In zh, this message translates to:
  /// **'正在整理中'**
  String get schoolStatusPreparing;

  /// No description provided for @schoolStatusAvailable.
  ///
  /// In zh, this message translates to:
  /// **'当前可用'**
  String get schoolStatusAvailable;

  /// No description provided for @schoolRoadmapLabel.
  ///
  /// In zh, this message translates to:
  /// **'流派路线图: {school}，{status}'**
  String schoolRoadmapLabel(String school, String status);

  /// No description provided for @schoolRoadmapSupporting.
  ///
  /// In zh, this message translates to:
  /// **'该流派正在整理中，后续版本将解锁完整解释。当前可继续在御定流派下查看本盘解释。'**
  String get schoolRoadmapSupporting;

  /// No description provided for @schoolSelectedLabel.
  ///
  /// In zh, this message translates to:
  /// **'{school}，{status}，已选中'**
  String schoolSelectedLabel(String school, String status);

  /// No description provided for @schoolDeselectedLabel.
  ///
  /// In zh, this message translates to:
  /// **'{school}，{status}'**
  String schoolDeselectedLabel(String school, String status);

  /// No description provided for @keTi.
  ///
  /// In zh, this message translates to:
  /// **'课体'**
  String get keTi;

  /// No description provided for @conditions.
  ///
  /// In zh, this message translates to:
  /// **'条件'**
  String get conditions;

  /// No description provided for @nameExplanation.
  ///
  /// In zh, this message translates to:
  /// **'释名'**
  String get nameExplanation;

  /// No description provided for @introduction.
  ///
  /// In zh, this message translates to:
  /// **'总论'**
  String get introduction;

  /// No description provided for @explanation.
  ///
  /// In zh, this message translates to:
  /// **'详解'**
  String get explanation;

  /// No description provided for @notes.
  ///
  /// In zh, this message translates to:
  /// **'注意'**
  String get notes;

  /// No description provided for @subKeti.
  ///
  /// In zh, this message translates to:
  /// **'子课体'**
  String get subKeti;

  /// No description provided for @pattern.
  ///
  /// In zh, this message translates to:
  /// **'格'**
  String get pattern;

  /// No description provided for @keYi.
  ///
  /// In zh, this message translates to:
  /// **'课义'**
  String get keYi;

  /// No description provided for @jieYue.
  ///
  /// In zh, this message translates to:
  /// **'解曰'**
  String get jieYue;

  /// No description provided for @duanYue.
  ///
  /// In zh, this message translates to:
  /// **'断曰'**
  String get duanYue;

  /// No description provided for @keYiFull.
  ///
  /// In zh, this message translates to:
  /// **'课义：'**
  String get keYiFull;

  /// No description provided for @jieYueFull.
  ///
  /// In zh, this message translates to:
  /// **'解曰：'**
  String get jieYueFull;

  /// No description provided for @duanYueFull.
  ///
  /// In zh, this message translates to:
  /// **'断曰：'**
  String get duanYueFull;

  /// No description provided for @ancientTextSeal.
  ///
  /// In zh, this message translates to:
  /// **'典'**
  String get ancientTextSeal;

  /// No description provided for @ancientTextTitle.
  ///
  /// In zh, this message translates to:
  /// **'{day}日 第{num} 干上{juname}'**
  String ancientTextTitle(String day, String num, String juname);

  /// No description provided for @chineseNumberUnit.
  ///
  /// In zh, this message translates to:
  /// **'局'**
  String get chineseNumberUnit;

  /// No description provided for @mixedDivination.
  ///
  /// In zh, this message translates to:
  /// **'杂占：'**
  String get mixedDivination;

  /// No description provided for @classicReferences.
  ///
  /// In zh, this message translates to:
  /// **'经典引用：'**
  String get classicReferences;

  /// No description provided for @timeColon.
  ///
  /// In zh, this message translates to:
  /// **'时间：'**
  String get timeColon;

  /// No description provided for @lunarLabel.
  ///
  /// In zh, this message translates to:
  /// **'农历：'**
  String get lunarLabel;

  /// No description provided for @lunarDate.
  ///
  /// In zh, this message translates to:
  /// **'{year}年 {month}月 {day} {time}'**
  String lunarDate(String year, String month, String day, String time);

  /// No description provided for @divinationTime.
  ///
  /// In zh, this message translates to:
  /// **'{day}日·{time}时·{yinyang}{ju}局'**
  String divinationTime(String day, String time, String yinyang, String ju);

  /// No description provided for @selectTimeAction.
  ///
  /// In zh, this message translates to:
  /// **'选择时间'**
  String get selectTimeAction;

  /// No description provided for @nowAction.
  ///
  /// In zh, this message translates to:
  /// **'现在'**
  String get nowAction;

  /// No description provided for @calculateAction.
  ///
  /// In zh, this message translates to:
  /// **'排盘'**
  String get calculateAction;

  /// No description provided for @cannotRepeat.
  ///
  /// In zh, this message translates to:
  /// **'不能重复'**
  String get cannotRepeat;

  /// No description provided for @ganZhiCalculateAction.
  ///
  /// In zh, this message translates to:
  /// **'干支排盘'**
  String get ganZhiCalculateAction;

  /// No description provided for @clearAction.
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get clearAction;

  /// No description provided for @showAnnotations.
  ///
  /// In zh, this message translates to:
  /// **'显示注解'**
  String get showAnnotations;

  /// No description provided for @hideAnnotations.
  ///
  /// In zh, this message translates to:
  /// **'隐藏注解'**
  String get hideAnnotations;

  /// No description provided for @newVersionUi.
  ///
  /// In zh, this message translates to:
  /// **'新版UI'**
  String get newVersionUi;

  /// No description provided for @dayGanZhiLabel.
  ///
  /// In zh, this message translates to:
  /// **'日干支:'**
  String get dayGanZhiLabel;

  /// No description provided for @timeGanZhiLabel.
  ///
  /// In zh, this message translates to:
  /// **'时干支:'**
  String get timeGanZhiLabel;

  /// No description provided for @monthGeneralLabel.
  ///
  /// In zh, this message translates to:
  /// **'月将:'**
  String get monthGeneralLabel;

  /// No description provided for @guiRenLabel.
  ///
  /// In zh, this message translates to:
  /// **'贵人:'**
  String get guiRenLabel;

  /// No description provided for @keTiLabel.
  ///
  /// In zh, this message translates to:
  /// **'课体:'**
  String get keTiLabel;

  /// No description provided for @tianDiPanPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'天地盘 (Placeholder):'**
  String get tianDiPanPlaceholder;

  /// No description provided for @fourClassPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'四课 (Placeholder):'**
  String get fourClassPlaceholder;

  /// No description provided for @threeChuanPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'三传 (Placeholder):'**
  String get threeChuanPlaceholder;

  /// No description provided for @renDun.
  ///
  /// In zh, this message translates to:
  /// **'阴阳遁'**
  String get renDun;

  /// No description provided for @yang.
  ///
  /// In zh, this message translates to:
  /// **'阳'**
  String get yang;

  /// No description provided for @yin.
  ///
  /// In zh, this message translates to:
  /// **'阴'**
  String get yin;

  /// No description provided for @juNumberLabel.
  ///
  /// In zh, this message translates to:
  /// **'局数'**
  String get juNumberLabel;

  /// No description provided for @singleGongDetail.
  ///
  /// In zh, this message translates to:
  /// **'单宫详情'**
  String get singleGongDetail;

  /// No description provided for @fullPanOverview.
  ///
  /// In zh, this message translates to:
  /// **'全盘概览'**
  String get fullPanOverview;

  /// No description provided for @diZhiGround.
  ///
  /// In zh, this message translates to:
  /// **'地支（地盘）'**
  String get diZhiGround;

  /// No description provided for @tianPan.
  ///
  /// In zh, this message translates to:
  /// **'天盘'**
  String get tianPan;

  /// No description provided for @tianGanLabel.
  ///
  /// In zh, this message translates to:
  /// **'天干'**
  String get tianGanLabel;

  /// No description provided for @jiGan.
  ///
  /// In zh, this message translates to:
  /// **'寄干'**
  String get jiGan;

  /// No description provided for @wuLabel.
  ///
  /// In zh, this message translates to:
  /// **'（无）'**
  String get wuLabel;

  /// No description provided for @gongLayoutDev.
  ///
  /// In zh, this message translates to:
  /// **'宫位布局开发'**
  String get gongLayoutDev;

  /// No description provided for @showHideAnnotations.
  ///
  /// In zh, this message translates to:
  /// **'隐藏注解'**
  String get showHideAnnotations;

  /// No description provided for @tianPanZhi.
  ///
  /// In zh, this message translates to:
  /// **'天盘支'**
  String get tianPanZhi;

  /// No description provided for @tianGanShort.
  ///
  /// In zh, this message translates to:
  /// **'天干'**
  String get tianGanShort;

  /// No description provided for @tianJiang.
  ///
  /// In zh, this message translates to:
  /// **'天将'**
  String get tianJiang;

  /// No description provided for @gongGeZoom.
  ///
  /// In zh, this message translates to:
  /// **'宫格缩放'**
  String get gongGeZoom;

  /// No description provided for @panSize.
  ///
  /// In zh, this message translates to:
  /// **'盘面尺寸'**
  String get panSize;

  /// No description provided for @fourClassShort.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get fourClassShort;

  /// No description provided for @threeClassShort.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get threeClassShort;

  /// No description provided for @twoClassShort.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get twoClassShort;

  /// No description provided for @oneClassShort.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get oneClassShort;

  /// No description provided for @schoolDemoTitle.
  ///
  /// In zh, this message translates to:
  /// **'大六壬流派演示'**
  String get schoolDemoTitle;

  /// No description provided for @noData.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get noData;

  /// No description provided for @representativeBook.
  ///
  /// In zh, this message translates to:
  /// **'代表书籍：'**
  String get representativeBook;

  /// No description provided for @era.
  ///
  /// In zh, this message translates to:
  /// **'年代：'**
  String get era;

  /// No description provided for @debugEntry.
  ///
  /// In zh, this message translates to:
  /// **'调试入口'**
  String get debugEntry;

  /// No description provided for @fourClassDebug.
  ///
  /// In zh, this message translates to:
  /// **'四课调试'**
  String get fourClassDebug;

  /// No description provided for @multiSchoolDebug.
  ///
  /// In zh, this message translates to:
  /// **'多流派调试'**
  String get multiSchoolDebug;

  /// No description provided for @multiSchoolDebugUnified.
  ///
  /// In zh, this message translates to:
  /// **'多流派调试 (统一组件展示路径)'**
  String get multiSchoolDebugUnified;

  /// No description provided for @loadEntriesFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载条目失败'**
  String get loadEntriesFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
