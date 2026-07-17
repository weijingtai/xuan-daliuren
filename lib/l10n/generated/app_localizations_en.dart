// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Da Liu Ren';

  @override
  String get daliurenOld => 'Da Liu Ren (Legacy)';

  @override
  String get daliurenUnknownPage => 'Da Liu Ren_Unknown Page';

  @override
  String get taiyiShenshu => 'Tai Yi Shen Shu';

  @override
  String registeredSchoolCount(int count) {
    return '$count Da Liu Ren schools registered';
  }

  @override
  String get selectTime => 'Select Time';

  @override
  String get pleaseSelectTimeToDivine => 'Please select a time to divine';

  @override
  String get pleaseCalculateFirst => 'Please calculate first';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String timeLabel(String time) {
    return 'Time: $time';
  }

  @override
  String questionLabel(String question) {
    return 'Question: $question';
  }

  @override
  String eightCharLabel(String eightChar) {
    return 'Eight Char: $eightChar';
  }

  @override
  String get ganZhiInfo => 'Gan-Zhi Info';

  @override
  String get yearGanZhi => 'Year GZ';

  @override
  String get monthGanZhi => 'Month GZ';

  @override
  String get dayGanZhi => 'Day GZ';

  @override
  String get timeGanZhi => 'Hour GZ';

  @override
  String get divinationPanel => 'Divination Panel';

  @override
  String get fourClass => 'Four Classes';

  @override
  String get firstClass => 'Class 1';

  @override
  String get secondClass => 'Class 2';

  @override
  String get thirdClass => 'Class 3';

  @override
  String get fourthClass => 'Class 4';

  @override
  String get fuYin => 'Fu Yin';

  @override
  String get fanYin => 'Fan Yin';

  @override
  String get fourClassComplete => 'Full 4 Classes';

  @override
  String get threeClassOnly => '3 Classes';

  @override
  String get threeChuan => 'Three Transmissions';

  @override
  String get nineZongMen => 'Nine Zong Men';

  @override
  String get initialChuan => '1st';

  @override
  String get middleChuan => '2nd';

  @override
  String get finalChuan => '3rd';

  @override
  String get twelvePalaces => 'Twelve Palaces';

  @override
  String get errorOccurred => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get questionOptional => 'Question (optional)';

  @override
  String get questionHint => 'Enter your divination question';

  @override
  String panTitle(
    String day,
    String time,
    String yinyang,
    String ju,
    String firstSky,
  ) {
    return '${day}Day·${time}Hr·$yinyang${ju}Ju·Above:$firstSky';
  }

  @override
  String panTitleShort(String day, String time, String firstSky) {
    return '${day}Day·${time}Hr·Above:$firstSky';
  }

  @override
  String get panSeal => 'P';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get day => 'Day';

  @override
  String get hour => 'Hour';

  @override
  String get twelveGods => 'Twelve Gods';

  @override
  String dayNightGui(String dynasty) {
    return '$dynasty Gui';
  }

  @override
  String chuanChen(String diZhi) {
    return 'Chuan $diZhi';
  }

  @override
  String monthGeneral(String diZhi) {
    return 'Month Gen $diZhi';
  }

  @override
  String get keGe => 'Ke Ge';

  @override
  String get none => 'None';

  @override
  String get daytime => 'Day';

  @override
  String get nighttime => 'Night';

  @override
  String get shenSha => 'Shen Sha';

  @override
  String get sortByType => 'By Type';

  @override
  String get sortByPosition => 'By Position';

  @override
  String get auspicious => 'Ji';

  @override
  String get inauspicious => 'Xiong';

  @override
  String typeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String positionLabel(String position) {
    return 'Position: $position';
  }

  @override
  String get selectSchool => 'Select School';

  @override
  String schoolExplanation(String school) {
    return '$school Explanation';
  }

  @override
  String get noMatchExplanation => 'No matching explanation';

  @override
  String get noMatchSecondary =>
      'No matching entry found. Try switching to YuDing.';

  @override
  String get dataUnavailable => 'Data Unavailable';

  @override
  String schoolDataLoadFailed(String schoolId) {
    return 'School data load failed: $schoolId';
  }

  @override
  String get noSchoolData => 'No explanation data for this school.';

  @override
  String get yudingFallback =>
      'Please calculate first to view YuDing explanation.';

  @override
  String get schoolStatusPreparing => 'Preparing';

  @override
  String get schoolStatusAvailable => 'Available';

  @override
  String schoolRoadmapLabel(String school, String status) {
    return 'Roadmap: $school, $status';
  }

  @override
  String get schoolRoadmapSupporting =>
      'This school is being prepared. Full explanations will be available in a future version.';

  @override
  String schoolSelectedLabel(String school, String status) {
    return '$school, $status, selected';
  }

  @override
  String schoolDeselectedLabel(String school, String status) {
    return '$school, $status';
  }

  @override
  String get keTi => 'Lesson Type';

  @override
  String get conditions => 'Conditions';

  @override
  String get nameExplanation => 'Name';

  @override
  String get introduction => 'Overview';

  @override
  String get explanation => 'Detail';

  @override
  String get notes => 'Notes';

  @override
  String get subKeti => 'Sub-Lessons';

  @override
  String get pattern => 'Pattern';

  @override
  String get keYi => 'Ke Yi';

  @override
  String get jieYue => 'Jie Yue';

  @override
  String get duanYue => 'Duan Yue';

  @override
  String get keYiFull => 'Ke Yi: ';

  @override
  String get jieYueFull => 'Jie Yue: ';

  @override
  String get duanYueFull => 'Duan Yue: ';

  @override
  String get ancientTextSeal => 'C';

  @override
  String ancientTextTitle(String day, String num, String juname) {
    return '$day Day #$num Above $juname';
  }

  @override
  String get chineseNumberUnit => '';

  @override
  String get mixedDivination => 'Misc: ';

  @override
  String get classicReferences => 'References: ';

  @override
  String get timeColon => 'Time: ';

  @override
  String get lunarLabel => 'Lunar: ';

  @override
  String lunarDate(String year, String month, String day, String time) {
    return '$year $month $day $time';
  }

  @override
  String divinationTime(String day, String time, String yinyang, String ju) {
    return '${day}D·${time}H·$yinyang${ju}J';
  }

  @override
  String get selectTimeAction => 'Select Time';

  @override
  String get nowAction => 'Now';

  @override
  String get calculateAction => 'Calculate';

  @override
  String get cannotRepeat => 'Cannot repeat';

  @override
  String get ganZhiCalculateAction => 'GZ Calculate';

  @override
  String get clearAction => 'Clear';

  @override
  String get showAnnotations => 'Show Notes';

  @override
  String get hideAnnotations => 'Hide Notes';

  @override
  String get newVersionUi => 'New UI';

  @override
  String get dayGanZhiLabel => 'Day GZ:';

  @override
  String get timeGanZhiLabel => 'Hour GZ:';

  @override
  String get monthGeneralLabel => 'Month Gen:';

  @override
  String get guiRenLabel => 'Gui Ren:';

  @override
  String get keTiLabel => 'Ke Ti:';

  @override
  String get tianDiPanPlaceholder => 'Sky-Earth Pan (Placeholder):';

  @override
  String get fourClassPlaceholder => 'Four Classes (Placeholder):';

  @override
  String get threeChuanPlaceholder => 'Three Transmissions (Placeholder):';

  @override
  String get renDun => 'Yin-Yang Dun';

  @override
  String get yang => 'Yang';

  @override
  String get yin => 'Yin';

  @override
  String get juNumberLabel => 'Ju';

  @override
  String get singleGongDetail => 'Palace Detail';

  @override
  String get fullPanOverview => 'Full Pan Overview';

  @override
  String get diZhiGround => 'Di Zhi (Ground)';

  @override
  String get tianPan => 'Sky Pan';

  @override
  String get tianGanLabel => 'Tian Gan';

  @override
  String get jiGan => 'Ji Gan';

  @override
  String get wuLabel => '(none)';

  @override
  String get gongLayoutDev => 'Gong Layout Dev';

  @override
  String get showHideAnnotations => 'Hide Notes';

  @override
  String get tianPanZhi => 'Sky Pan Zhi';

  @override
  String get tianGanShort => 'Tian Gan';

  @override
  String get tianJiang => 'Tian Jiang';

  @override
  String get gongGeZoom => 'Gong Zoom';

  @override
  String get panSize => 'Pan Size';

  @override
  String get fourClassShort => '4';

  @override
  String get threeClassShort => '3';

  @override
  String get twoClassShort => '2';

  @override
  String get oneClassShort => '1';

  @override
  String get schoolDemoTitle => 'Da Liu Ren Schools Demo';

  @override
  String get noData => 'No data';

  @override
  String get representativeBook => 'Book: ';

  @override
  String get era => 'Era: ';

  @override
  String get debugEntry => 'Debug';

  @override
  String get fourClassDebug => '4-Class Debug';

  @override
  String get multiSchoolDebug => 'Multi-School Debug';

  @override
  String get multiSchoolDebugUnified => 'Multi-School Debug (Unified)';

  @override
  String get loadEntriesFailed => 'Failed to load entries';
}
