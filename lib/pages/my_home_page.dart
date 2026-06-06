import 'dart:async';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:theme/const_resources_mapper.dart';
import 'package:metaphysics_core/enums.dart';
import 'package:metaphysics_core/models/shen_sha.dart';
import 'package:xuan_logger/xuan_logger.dart';
import 'package:theme/const_ui_resources_mapper.dart';
import 'package:xuan_four_zhu_card/widgets/four_zhu_eight_char.dart';
import 'package:xuan_four_zhu_card/widgets/twenty_four_jie_qi_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:repository_interface_daliuren/repository_interface_daliuren.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tyme/tyme.dart' hide YinYang;
import 'package:tuple/tuple.dart';

import '../model/da_liu_ren_gong.dart';
import '../model/da_liu_ren_ke_pan.dart';
import '../model/da_liu_ren_pan_model.dart';
import '../model/da_liu_ren_panel.dart';
import '../model/enum_gui_ren.dart';
import '../model/four_class.dart';
import '../model/three_chuan.dart';
import '../presentation/widgets/four_class_card.dart';
import '../presentation/widgets/ke_pan_info_card.dart';
import '../presentation/widgets/keti_detail_widget.dart';
import '../presentation/widgets/shen_sha_display_widget.dart';
import '../presentation/widgets/three_chuan_card.dart';
import '../presentation/viewmodels/da_liu_ren_viewmodel.dart';
import '../domain/services/keti_data_service.dart';
import '../data/models/yu_ding_da_liu_ren_data_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double NORMAL_PAN_SIZE = 400.0;
  static const double SMALL_PAN_SIZE = 280.0;
  static const String ICONS_ASSETS_PATH = "icons";

  GlobalKey renYearGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  GlobalKey renMonthGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  GlobalKey renDayGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  GlobalKey renTimeGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  GlobalKey renDunGanZhiShakeKey = GlobalKey<ShakeWidgetState>();
  GlobalKey renJuNumberShakeKey = GlobalKey<ShakeWidgetState>();
  GlobalKey renMonthGeneralShakeKey = GlobalKey<ShakeWidgetState>();

  JiaZi? yearJiaZi;
  JiaZi? monthJiaZi;
  JiaZi? dayJiaZi;
  JiaZi? timeJiaZi;
  MonthGeneral? monthGeneral;
  YinYang? yinYangDun;
  int? juNumber;

  final ValueNotifier<bool> _showMonthGeneralJieQi = ValueNotifier(false);
  final ValueNotifier<bool> isSmallPanNotifier = ValueNotifier(false);
  final ValueNotifier<bool> showThreeChuanAsCard = ValueNotifier(false);
  final ValueNotifier<bool> showFourClassAsCard = ValueNotifier(false);
  final ValueNotifier<bool> showKePanInfoCard = ValueNotifier(false);

  Timer? _showMonthGeneralJieQiTimer;

  @override
  void dispose() {
    super.dispose();
    _showMonthGeneralJieQi.dispose();
    isSmallPanNotifier.dispose();
    showThreeChuanAsCard.dispose();
    showFourClassAsCard.dispose();
    showKePanInfoCard.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DaLiuRenViewModel>().initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DaLiuRenViewModel>();
    final daLiuRenGong = viewModel.currentDivination;
    final juNumberFromVm = viewModel.juNumber;

    Size panSize = const Size(NORMAL_PAN_SIZE, NORMAL_PAN_SIZE);
    Size gongSize = const Size(NORMAL_PAN_SIZE * .25, NORMAL_PAN_SIZE * .25);

    // dev 三传 九宗门
    return Scaffold(
 appBar: AppBar(
 title: daLiuRenGong != null && juNumberFromVm != null
 ? Text(
 "${daLiuRenGong.dayJiaZi.name}日·${daLiuRenGong.timeJiaZi.diZhi.name}时·${daLiuRenGong.isDayGuiRen ? "阳" : "阴"}${ConstResourcesMapper.chineseNumberMapper[juNumberFromVm]}局")
 : const Text("大六壬"),
 centerTitle: true,
 actions: [
 IconButton(
 icon: const Icon(Icons.auto_awesome),
 tooltip: "新版UI",
 onPressed: () => Navigator.pushNamed(context, '/daliuren/new'),
 ),
 ],
 ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              pan_base_info(viewModel),
              const SizedBox(
                height: 16,
              ),
              // 竖屏是使用Column
              main(viewModel),

              const SizedBox(
                height: 32,
              ),
              manuallyJu(),
              const SizedBox(
                height: 32,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showBoardDateTimePicker(
                        context: context,
                        pickerType: DateTimePickerType.datetime,
                      );
                      if (result != null) {
                        viewModel.updateDateTime(result);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.green, // Background coloronPrimary: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15), // Padding
                      textStyle: const TextStyle(fontSize: 18), // Text style
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('选择时间'),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () => viewModel.updateDateTime(DateTime.now()),
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.green, // Background coloronPrimary: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15), // Padding
                      textStyle: const TextStyle(fontSize: 18), // Text style
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('现在'),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (viewModel.currentDivination == null) {
                        viewModel.updateDateTime(viewModel.selectedDateTime);
                      } else {
                        InteractiveToast.slide(
                          context: context,
                          title: const Text("不能重复"),
                          toastStyle: const ToastStyle(titleLeadingGap: 10),
                          toastSetting: const SlidingToastSetting(
                            animationDuration: Duration(seconds: 1),
                            displayDuration: Duration(seconds: 2),
                            toastStartPosition: ToastPosition.top,
                            toastAlignment: Alignment.topCenter,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.red, // Background coloronPrimary: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15), // Padding
                      textStyle: const TextStyle(
                          fontSize: 18, color: Colors.white), // Text style
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('排盘'),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (viewModel.currentDivination == null) {
                        if ([yearJiaZi, monthJiaZi, dayJiaZi, yinYangDun]
                                .any((e) => e == null) ||
                            (timeJiaZi == null && juNumber == null)) {
                          if (yearJiaZi == null) {
                            (renYearGanZhiShakeKey.currentState!
                                    as ShakeWidgetState)
                                .shake();
                          }
                          if (monthJiaZi == null) {
                            (renMonthGanZhiShakeKey.currentState!
                                    as ShakeWidgetState)
                                .shake();
                          }
                          if (dayJiaZi == null) {
                            (renDayGanZhiShakeKey.currentState!
                                    as ShakeWidgetState)
                                .shake();
                          }
                          if (yinYangDun == null) {
                            (renDunGanZhiShakeKey.currentState!
                                    as ShakeWidgetState)
                                .shake();
                          }
                          if (monthGeneral == null) {
                            (renMonthGeneralShakeKey.currentState!
                                    as ShakeWidgetState)
                                .shake();
                          }
                          if (timeJiaZi == null && juNumber == null) {
                            (renTimeGanZhiShakeKey.currentState!
                                    as ShakeWidgetState)
                                .shake();
                            (renJuNumberShakeKey.currentState!
                                    as ShakeWidgetState)
                                .shake();
                          }
                        } else {
                          viewModel.updateManualJu(
                            yearJiaZi: yearJiaZi!,
                            monthJiaZi: monthJiaZi!,
                            dayJiaZi: dayJiaZi!,
                            yinYangDun: yinYangDun!,
                            monthGeneral: monthGeneral!,
                            timeJiaZi: timeJiaZi,
                            juNumber: juNumber,
                          );
                        }
                      } else {
                        InteractiveToast.slide(
                          context: context,
                          title: const Text("不能重复"),
                          toastStyle: const ToastStyle(titleLeadingGap: 10),
                          toastSetting: const SlidingToastSetting(
                            animationDuration: Duration(seconds: 1),
                            displayDuration: Duration(seconds: 2),
                            toastStartPosition: ToastPosition.top,
                            toastAlignment: Alignment.topCenter,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.red, // Background coloronPrimary: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15), // Padding
                      textStyle: const TextStyle(
                          fontSize: 18, color: Colors.white), // Text style
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('干支排盘'),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () async {
                      viewModel.clear();
                      yearJiaZi = null;
                      monthJiaZi = null;
                      dayJiaZi = null;
                      timeJiaZi = null;
                      monthGeneral = null;
                      juNumber = null;
                      yinYangDun = null;
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle:
                          const TextStyle(fontSize: 18, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('清除'),
                  ),
                ],
              ),
              const SizedBox(
                height: 56,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pan_base_info(DaLiuRenViewModel viewModel) {
    final dateTime = viewModel.selectedDateTime;
    final pan = viewModel.currentDivination;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 240,
            height: 100,
            child: buildCenterPanTime(dateTime),
          ),
          SizedBox(
            width: 260,
            height: 150,
            child: pan != null
                ? buildCenterFourZhu(
                    pan.yearJiaZi, pan.monthJiaZi, pan.dayJiaZi, pan.timeJiaZi)
                : const SizedBox(),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 240,
            height: 100,
            child: buildCenterPanTime(dateTime),
          ),
          SizedBox(
            width: 260,
            height: 150,
            child: pan != null
                ? buildCenterFourZhu(
                    pan.yearJiaZi, pan.monthJiaZi, pan.dayJiaZi, pan.timeJiaZi)
                : const SizedBox(),
          )
        ],
      );
    }
  }

  Widget main(DaLiuRenViewModel viewModel) {
    final pan = viewModel.currentDivination;
    final shenShaResults = viewModel.shenShaResults;
    final matchedLessons = viewModel.matchedLessons;
    final matchedKeTiNames = viewModel.matchedKeTiNames;
    final matchedKetiResults = viewModel.matchedKetiResults;
    final lessonSubLessons = <String, List<String>>{};
    for (final r in matchedKetiResults) {
      if (r.matchedSubLesson != null) {
        lessonSubLessons.putIfAbsent(r.lesson.name, () => []);
        lessonSubLessons[r.lesson.name]!.add(r.matchedSubLesson!.name);
      }
    }

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isSmallPanNotifier,
            builder: (context, isSmall, _) {
              const double normalPanSize = 400.0;
              const double smallPanSize = 280.0;
              return SizedBox(
                  width: normalPanSize,
                  height: normalPanSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutQuart,
                          tween: Tween<double>(
                            begin: isSmall ? normalPanSize : smallPanSize,
                            end: isSmall ? smallPanSize : normalPanSize,
                          ),
                          builder: (context, size, child) {
                            final double currentScaleFactor =
                                size / normalPanSize;
                            final Size currentGongSize =
                                Size(size * 0.25, size * 0.25);
                            return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 251, 240, 1),
                                  borderRadius: BorderRadius.circular(
                                      32 * currentScaleFactor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6 * currentScaleFactor,
                                      spreadRadius: 6 * currentScaleFactor,
                                    )
                                  ]),
                              alignment: Alignment.center,
child: pan == null
                                   ? Container(
                                       width: size,
                                       height: size,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(
                                             32 * currentScaleFactor),
                                       ),
                                     )
                                   : ValueListenableBuilder<bool>(
                                       valueListenable: showThreeChuanAsCard,
                                       builder: (ctx, showThreeAsCard, _) {
                                         return ValueListenableBuilder<bool>(
                                           valueListenable: showFourClassAsCard,
                                           builder: (ctx2, showFourAsCard, __) {
                                             return build_panel(
                                                 pan, currentGongSize,
                                                 currentScaleFactor,
                                                 hideThreeChuan: showThreeAsCard,
                                                 hideFourClass: showFourAsCard);
                                           },
                                         );
                                       },
                                     ),
                            );
                          },
                        ),
                      ),
                    ],
                  ));
            },
          ),
          // zoom toggle button (portrait) - below the pan, centered
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ValueListenableBuilder<bool>(
                valueListenable: isSmallPanNotifier,
                builder: (context, isSmall, _) {
                  return Material(
                    color: Colors.redAccent,
                    elevation: 8,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        isSmall ? Icons.fullscreen : Icons.fullscreen_exit,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () =>
                          isSmallPanNotifier.value = !isSmallPanNotifier.value,
                      tooltip: "切换大小",
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (pan != null) _buildToggleAndCards(pan),
          const SizedBox(
            height: 16,
          ),
          pan == null
              ? const SizedBox()
              : Container(
                  width: 400,
                  height: 480,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                      // color: Colors.blue.withOpacity(.1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 6,
                        )
                      ]),
                  child: SingleChildScrollView(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        FutureBuilder(
                            future:
                                loadBy(pan.dayJiaZi, pan.fourClass.first.sky, context.read<DaLiuRenOfficialDataRepository>()),
                            builder: (ctx, snap) {
                              if (snap.hasError) {
                                logger.e(snap.error.toString());
                              }
                              if (snap.hasData) {
                                return yu_ding(snap.data!);
                              } else {
                                return const SizedBox(
                                    height: 64,
                                    width: 64,
                                    child: CircularProgressIndicator());
                              }
                            }),
                        Positioned(
                          top: -24,
                          right: 0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                // color: Colors.blue.withOpacity(.1),
                                height: 128,
                                width: 64,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "${ICONS_ASSETS_PATH}/tag_virt.png"))),
                                // child:Image.asset("${ICONS_ASSETS_PATH}/tag_virt.png",),
                              ),
                              const Column(
                                children: [Text("元"), Text("首")],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                  .animate()
                  .moveX(
                      delay: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOutQuint,
                      duration: const Duration(milliseconds: 1000),
                      begin: -128,
                      end: 0)
                  .fadeIn(
                      delay: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutQuint,
                      duration: const Duration(milliseconds: 400),
                      begin: 0),
          const SizedBox(height: 16),
          // Shen Sha Display (portrait)
          if (shenShaResults != null && shenShaResults.isNotEmpty)
            ShenShaDisplayWidget(shenShaResults: shenShaResults),
          const SizedBox(height: 16),
          // KeTi Detail Display (portrait)
          if (matchedLessons.isNotEmpty)
            KetiDetailWidget(
                lessons: matchedLessons,
                highlightedSubLessons: lessonSubLessons),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isSmallPanNotifier,
                builder: (context, isSmall, _) {
                  const double normalPanSize = 400.0;
                  const double smallPanSize = 280.0;
                  return SizedBox(
                    width: normalPanSize,
                    height: normalPanSize,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutQuart,
                            tween: Tween<double>(
                              begin: isSmall ? normalPanSize : smallPanSize,
                              end: isSmall ? smallPanSize : normalPanSize,
                            ),
                            builder: (context, size, child) {
                              final double currentScaleFactor =
                                  size / normalPanSize;
                              final Size currentGongSize =
                                  Size(size * 0.25, size * 0.25);
                              return Container(
                                width: size,
                                height: size,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(255, 251, 240, 1),
                                    borderRadius: BorderRadius.circular(
                                        32 * currentScaleFactor),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6 * currentScaleFactor,
                                        spreadRadius: 6 * currentScaleFactor,
                                      )
                                    ]),
                                alignment: Alignment.center,
child: pan == null
                                     ? Container(
                                         width: size,
                                         height: size,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(
                                               32 * currentScaleFactor),
                                         ),
                                       )
                                     : ValueListenableBuilder<bool>(
                                         valueListenable: showThreeChuanAsCard,
                                         builder: (ctx, showThreeAsCard, _) {
                                           return ValueListenableBuilder<bool>(
                                             valueListenable:
                                                 showFourClassAsCard,
                                             builder:
                                                 (ctx2, showFourAsCard, __) {
                                               return build_panel(
                                                   pan, currentGongSize,
                                                   currentScaleFactor,
                                                   hideThreeChuan:
                                                       showThreeAsCard,
                                                   hideFourClass:
                                                       showFourAsCard);
                                             },
                                           );
                                         },
                                       ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isSmallPanNotifier,
                    builder: (context, isSmall, _) {
                      return Material(
                        color: Colors.redAccent,
                        elevation: 8,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: Icon(
                            isSmall ? Icons.fullscreen : Icons.fullscreen_exit,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => isSmallPanNotifier.value =
                              !isSmallPanNotifier.value,
                          tooltip: "切换大小",
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                width: 32,
              ),
              pan == null
                  ? const SizedBox()
                  : Container(
                          width: 400, // panSize.width
                          height: 400, // panSize.height
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                              // color: Colors.blue.withOpacity(.1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  spreadRadius: 6,
                                )
                              ]),
                          child: SingleChildScrollView(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                FutureBuilder(
                                    future: loadBy(
                                        pan.dayJiaZi, pan.fourClass.first.sky, context.read<DaLiuRenOfficialDataRepository>()),
                                    builder: (ctx, snap) {
                                      if (snap.hasError) {
                                        logger.d(snap.error.toString());
                                      }
                                      if (snap.hasData) {
                                        return yu_ding(snap.data!);
                                      } else {
                                        return const SizedBox(
                                            height: 64,
                                            width: 64,
                                            child: CircularProgressIndicator());
                                      }
                                    }),
                                Positioned(
                                  top: -24,
                                  right: 0,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        // color: Colors.blue.withOpacity(.1),
                                        height: 128,
                                        width: 64,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "${ICONS_ASSETS_PATH}/tag_virt.png"))),
                                        // child:Image.asset("${ICONS_ASSETS_PATH}/tag_virt.png",),
                                      ),
                                      const Column(
                                        children: [Text("元"), Text("首")],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .animate()
                      .moveX(
                          delay: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOutQuint,
                          duration: const Duration(milliseconds: 1000),
                          begin: -128,
                          end: 0)
                      .fadeIn(
                          delay: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutQuint,
                          duration: const Duration(milliseconds: 400),
                          begin: 0)
            ],
          ),
          const SizedBox(height: 16),
          if (pan != null) _buildToggleAndCards(pan),
          const SizedBox(height: 16),
          // Shen Sha Display (landscape)
          if (shenShaResults != null && shenShaResults.isNotEmpty)
            ShenShaDisplayWidget(shenShaResults: shenShaResults),
          const SizedBox(height: 16),
          // KeTi Detail Display (landscape)
          if (matchedLessons.isNotEmpty)
            KetiDetailWidget(
                lessons: matchedLessons,
                highlightedSubLessons: lessonSubLessons),
        ],
      );
    }
  }

  Widget _buildToggleAndCards(DaLiuRenKePan pan) {
    final viewModel = context.read<DaLiuRenViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: showThreeChuanAsCard,
              builder: (context, showAsCard, _) {
                return _buildToggleChip(
                  label: "三传Card",
                  selected: showAsCard,
                  onTap: () =>
                      showThreeChuanAsCard.value = !showThreeChuanAsCard.value,
                );
              },
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<bool>(
              valueListenable: showFourClassAsCard,
              builder: (context, showAsCard, _) {
                return _buildToggleChip(
                  label: "四课Card",
                  selected: showAsCard,
                  onTap: () =>
                      showFourClassAsCard.value = !showFourClassAsCard.value,
                );
              },
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<bool>(
              valueListenable: showKePanInfoCard,
              builder: (context, showCard, _) {
                return _buildToggleChip(
                  label: "课盘信息Card",
                  selected: showCard,
                  onTap: () =>
                      showKePanInfoCard.value = !showKePanInfoCard.value,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<bool>(
          valueListenable: showKePanInfoCard,
          builder: (context, showCard, _) {
            if (!showCard) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: KePanInfoCard(
                kePan: pan,
                juNumber: viewModel.juNumber,
                keTiNames: viewModel.matchedKeTiNames,
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: showThreeChuanAsCard,
          builder: (context, showThreeCard, _) {
            if (!showThreeCard) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ThreeChuanCard(
                threeChuan: pan.getThreeChuan(),
                gongSize: Size(NORMAL_PAN_SIZE * .25, NORMAL_PAN_SIZE * .25),
                scaleFactor: 1.0,
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: showFourClassAsCard,
          builder: (context, showFourCard, _) {
            if (!showFourCard) return const SizedBox.shrink();
            return FourClassCard(
              fourClass: pan.getFourClass(),
              gongSize: Size(NORMAL_PAN_SIZE * .25, NORMAL_PAN_SIZE * .25),
              scaleFactor: 1.0,
            );
          },
        ),
      ],
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.card_giftcard : Icons.credit_card_off_outlined,
              size: 16,
              color: selected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.blue : Colors.grey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget manuallyJu() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShakeMe(
            // 4. pass the GlobalKey as an argument
            key: renYearGanZhiShakeKey,
            // 5. configure the animation parameters
            shakeCount: 3,
            shakeOffset: 10,
            shakeDuration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: 128,
              height: 48,
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                    closedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    expandedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    searchFieldDecoration:
                        const SearchFieldDecoration(prefixIcon: null)),

                hintText: "年干支",
                // initialItem: "甲子",
                items: JiaZi.listAll.map((e) => e.name).toList(),
                onChanged: (jiaZiStr) {
                  if (jiaZiStr != null) {
                    yearJiaZi = JiaZi.getFromGanZhiValue(jiaZiStr);
                  } else {
                    yearJiaZi = null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ShakeMe(
            // 4. pass the GlobalKey as an argument
            key: renMonthGanZhiShakeKey,
            // 5. configure the animation parameters
            shakeCount: 3,
            shakeOffset: 10,
            shakeDuration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: 128,
              height: 48,
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                    closedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    expandedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    searchFieldDecoration:
                        const SearchFieldDecoration(prefixIcon: null)),

                hintText: "月干支",
                // initialItem: "甲子",
                items: JiaZi.listAll.map((e) => e.name).toList(),
                onChanged: (jiaZiStr) {
                  if (jiaZiStr != null) {
                    monthJiaZi = JiaZi.getFromGanZhiValue(jiaZiStr);
                  } else {
                    monthJiaZi = null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ShakeMe(
            // 4. pass the GlobalKey as an argument
            key: renDayGanZhiShakeKey,
            // 5. configure the animation parameters
            shakeCount: 3,
            shakeOffset: 10,
            shakeDuration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: 128,
              height: 48,
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                    closedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    expandedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    searchFieldDecoration:
                        const SearchFieldDecoration(prefixIcon: null)),

                hintText: "日干支",
                // initialItem: "甲子",
                items: JiaZi.listAll.map((e) => e.name).toList(),
                onChanged: (jiaZiStr) {
                  if (jiaZiStr != null) {
                    dayJiaZi = JiaZi.getFromGanZhiValue(jiaZiStr);
                  } else {
                    dayJiaZi = null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ShakeMe(
            // 4. pass the GlobalKey as an argument
            key: renTimeGanZhiShakeKey,
            // 5. configure the animation parameters
            shakeCount: 3,
            shakeOffset: 10,
            shakeDuration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: 128,
              height: 48,
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                    closedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    expandedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    searchFieldDecoration:
                        const SearchFieldDecoration(prefixIcon: null)),

                hintText: "时干支",
                // initialItem: "甲子",
                items: JiaZi.listAll.map((e) => e.name).toList(),
                onChanged: (jiaZiStr) {
                  if (jiaZiStr != null) {
                    timeJiaZi = JiaZi.getFromGanZhiValue(jiaZiStr);
                  } else {
                    timeJiaZi = null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ShakeMe(
            // 4. pass the GlobalKey as an argument
            key: renDunGanZhiShakeKey,
            // 5. configure the animation parameters
            shakeCount: 3,
            shakeOffset: 10,
            shakeDuration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: 128,
              height: 48,
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                    closedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    expandedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    searchFieldDecoration:
                        const SearchFieldDecoration(prefixIcon: null)),

                hintText: "阴阳局",
                // initialItem: "甲子",
                // items: List.generate(12, (i)=>"阳遁${ConstResourcesMapper.chineseNumberMapper[i+1]!}局")..addAll(List.generate(12, (i)=>"阴遁${ConstResourcesMapper.chineseNumberMapper[i+1]!}局")),
                items: const ["阳遁", "阴遁"],
                onChanged: (jiaZiStr) {
                  if (jiaZiStr != null) {
                    List<String> splitedList = jiaZiStr.split("");
                    yinYangDun =
                        splitedList.first == "阳" ? YinYang.YANG : YinYang.YIN;
                  } else {
                    yinYangDun = null;
                  }
                  // print(JiaZi.getFromGanZhiValue(jiaZiStr!));
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ShakeMe(
            key: renMonthGeneralShakeKey,
            shakeCount: 3,
            shakeOffset: 10,
            shakeDuration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: 128,
              height: 48,
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                    closedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    expandedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    searchFieldDecoration:
                        const SearchFieldDecoration(prefixIcon: null)),
                hintText: "月将",
                items: MonthGeneral.values.map((e) => e.name).toList(),
                onChanged: (val) {
                  if (val != null) {
                    monthGeneral =
                        MonthGeneral.values.firstWhere((e) => e.name == val);
                  } else {
                    monthGeneral = null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ShakeMe(
            // 4. pass the GlobalKey as an argument
            key: renJuNumberShakeKey,
            // 5. configure the animation parameters
            shakeCount: 3,
            shakeOffset: 10,
            shakeDuration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: 128,
              height: 48,
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                    closedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    expandedShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2)
                    ],
                    searchFieldDecoration:
                        const SearchFieldDecoration(prefixIcon: null)),

                hintText: "局数",
                // initialItem: "甲子",
                items: List.generate(
                    12,
                    (i) =>
                        "${ConstResourcesMapper.chineseNumberMapper[i + 1]!}局"),
                onChanged: (jiaZiStr) {
                  if (jiaZiStr != null) {
                    List<String> splitedList = jiaZiStr.split("");
                    String numStr = splitedList[2];
                    juNumber = ConstResourcesMapper.chineseNumberMapper.entries
                        .firstWhere((e) => e.value == numStr)
                        .key;
                  } else {
                    juNumber = null;
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCenterFourZhu(JiaZi year, JiaZi month, JiaZi day, JiaZi time) {
    return Card(
        child: Align(
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: FourZhuEightChar(
            year: year,
            month: month,
            day: day,
            chen: time,
            isColorful: true,
            zodiacGanColors: ConstResourcesMapper.zodiacGanColors,
            zodiacZhiColors: ConstResourcesMapper.zodiacZhiColors,
          )),
    ));
  }

  Widget buildCenterPanTime(DateTime time) {
    final solarDay = SolarDay.fromYmd(time.year, time.month, time.day);
    final lunarDay = solarDay.getLunarDay();
    final lunarMonth = lunarDay.getLunarMonth();
    final solarTime = SolarTime.fromYmdHms(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
    );
    final lunarHour = solarTime.getLunarHour();
    final eightChar = lunarHour.getEightChar();

    // Get term info
    final term = solarDay.getTerm();
    final termJd = term.getJulianDay();
    final termTime = termJd.getSolarTime();
    final termAt = DateTime(
      termTime.getYear(),
      termTime.getMonth(),
      termTime.getDay(),
      termTime.getHour(),
      termTime.getMinute(),
      termTime.getSecond(),
    );

    String prevTermName;
    String prevTermTimeStr;
    String nextTermName;
    String nextTermTimeStr;

    if (termAt.isAfter(time)) {
      // Term hasn't started
      final prevTerm = term.next(-1);
      final prevJd = prevTerm.getJulianDay();
      final prevSt = prevJd.getSolarTime();
      prevTermName = prevTerm.getName();
      prevTermTimeStr =
          '${prevSt.getYear()}/${_pad(prevSt.getMonth())}/${_pad(prevSt.getDay())} ${_pad(prevSt.getHour())}:${_pad(prevSt.getMinute())}:${_pad(prevSt.getSecond())}';
      nextTermName = term.getName();
      nextTermTimeStr =
          '${termTime.getYear()}/${_pad(termTime.getMonth())}/${_pad(termTime.getDay())} ${_pad(termTime.getHour())}:${_pad(termTime.getMinute())}:${_pad(termTime.getSecond())}';
    } else {
      prevTermName = term.getName();
      prevTermTimeStr =
          '${termTime.getYear()}/${_pad(termTime.getMonth())}/${_pad(termTime.getDay())} ${_pad(termTime.getHour())}:${_pad(termTime.getMinute())}:${_pad(termTime.getSecond())}';
      final nextTerm = term.next(1);
      final nextJd = nextTerm.getJulianDay();
      final nextSt = nextJd.getSolarTime();
      nextTermName = nextTerm.getName();
      nextTermTimeStr =
          '${nextSt.getYear()}/${_pad(nextSt.getMonth())}/${_pad(nextSt.getDay())} ${_pad(nextSt.getHour())}:${_pad(nextSt.getMinute())}:${_pad(nextSt.getSecond())}';
    }

    // Year in GanZhi
    final yearGanZhi = eightChar.getYear().getName();
    // Lunar month/day Chinese
    final monthCn = lunarMonth.getName();
    final dayCn = lunarDay.getName();
    // Time Zhi
    final timeZhi = eightChar.getHour().getName().substring(1);

    return Card(
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(flex: 3, child: Text("时间：")),
                    Flexible(
                        flex: 7,
                        child: Text(
                          DateFormat("yyyy/MM/dd HH:mm").format(time),
                          style: TextStyle(
                              fontSize: 14, color: Colors.blueGrey.shade800),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(flex: 3, child: Text("农历：")),
                    Flexible(
                        flex: 7,
                        child: Text(
                          "${yearGanZhi}年 ${monthCn}月 $dayCn ${timeZhi}时",
                          style: TextStyle(
                              fontSize: 14, color: Colors.blueGrey.shade800),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(flex: 3, child: Text("$prevTermName:")),
                    Flexible(
                        flex: 7,
                        child: Text(
                          prevTermTimeStr,
                          style: TextStyle(
                              fontSize: 14, color: Colors.blueGrey.shade800),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(flex: 3, child: Text("$nextTermName:")),
                    Flexible(
                        flex: 7,
                        child: Text(
                          nextTermTimeStr,
                          style: TextStyle(
                              fontSize: 14, color: Colors.blueGrey.shade800),
                        )),
                  ],
                )
              ]),
            )));
  }

  static String _pad(int v) => v.toString().padLeft(2, '0');

  Widget yu_ding(YuDingDaLiuRenDataModel yuDing) {
    return Column(
      children: [
        Container(
          child: Text(
            "${yuDing.dayJiaZi.name}日 第${ConstResourcesMapper.chineseNumberMapper[yuDing.juNumber]!} 干上${yuDing.juName.name}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          child: RichText(
              text: TextSpan(
                  text: yuDing.body.join(" "),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)
                  // children: yuDing.body.join(" ").map((e)=>TextSpan(text:e)).toList()
                  )),
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: "课义：",
              children: [TextSpan(text: yuDing.meaning)]),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: "解曰：",
              children: [TextSpan(text: yuDing.explain)]),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: "断曰：",
              children: [TextSpan(text: yuDing.predication)]),
        ),
        const SizedBox(
          height: 12,
        ),
        ...yuDing.details.entries
            .map((entry) => RichText(
                  text: TextSpan(
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      text: "${entry.key}：",
                      children: [TextSpan(text: entry.value)]),
                ))
            .toList(),
        const SizedBox(
          height: 12,
        ),
        ...yuDing.books.entries
            .map((entry) => RichText(
                  text: TextSpan(
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      text: "${entry.key}：",
                      children: [TextSpan(text: entry.value)]),
                ))
            .toList()
      ],
    );
  }
  // String numberToStrName(int number){
  //   var res = ["一","二","三","四","五","六","七","八","九","十","十一","十二"][number-1];
  //   return "$res局";
  // }

  Future<YuDingDaLiuRenDataModel> loadBy(
      JiaZi dayJiaZi, DiZhi dayUpperDiZhi,
      DaLiuRenOfficialDataRepository officialData) async {
    try {
      final List<dynamic> res = await officialData.loadYuDingData();
      List<YuDingDaLiuRenDataModel> all = List<YuDingDaLiuRenDataModel>.from(
          res.map((model) => YuDingDaLiuRenDataModel.fromJson(model)));
      var result = all.firstWhere(
          (y) => y.dayJiaZi == dayJiaZi && y.juName == dayUpperDiZhi);
      return result;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Widget build_panel_model(
      DaLiuRenPanModel panModel, Size gongSize, double scaleFactor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        panel_gong(panModel, gongSize, scaleFactor),
        SizedBox(
          width: gongSize.width * 2,
          height: gongSize.height * 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: gongSize.height,
                width: gongSize.width,
                // color: Colors.orange.withOpacity(.2),
                child: build_four_ke(
                    panModel.getFourClass(), gongSize, scaleFactor),
              ),
              Container(
                height: gongSize.height,
                width: gongSize.width,
                alignment: Alignment.center,
                // color: Colors.orange.withOpacity(.4),
                child: build_san_chuan(
                    panModel.getThreeChuan(), gongSize, scaleFactor),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget build_panel(
      DaLiuRenKePan daLiuPan, Size gongSize, double scaleFactor,
      {bool hideThreeChuan = false, bool hideFourClass = false}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        panel_gong(daLiuPan, gongSize, scaleFactor),
        panel_center(daLiuPan, gongSize, scaleFactor,
            hideThreeChuan: hideThreeChuan, hideFourClass: hideFourClass),
      ],
    );
  }

  Widget panel_center(
      DaLiuRenKePan daLiuPan, Size gongSize, double scaleFactor,
      {bool hideThreeChuan = false, bool hideFourClass = false}) {
    double width = gongSize.width * 2;
    double height = gongSize.height * 2;
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // buildMonthGeneral(daLiuPan),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onHover: (isHover) {
                      logger.d("isHover $isHover}");
                    },
                    onTap: () => showMonthlyGeneralJieQi(),
                    onLongPress: () {
                      logger.d("on long press ${_showMonthGeneralJieQi.value}");
                      if (_showMonthGeneralJieQi.value) {
                        logger.d("on long press is true");
                        if (_showMonthGeneralJieQiTimer != null) {
                          logger.d("on long press is with cancel timer");
                          _showMonthGeneralJieQiTimer!.cancel();
                          _showMonthGeneralJieQiTimer = null;
                          isLongSticky = true;
                        } else {
                          logger.d("on long press is with hidden");
                          hideMonthlyGeneralJieQi();
                          isLongSticky = false;
                        }
                      } else {
                        isLongSticky = true;
                        showMonthlyGeneralJieQi(autoHidden: false);
                      }
                    },
                    child: MouseRegion(
                      onEnter: (e) =>
                          !isLongSticky ? showMonthlyGeneralJieQi() : null,
                      onExit: (e) =>
                          !isLongSticky ? hideMonthlyGeneralJieQi() : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "${ICONS_ASSETS_PATH}/chinese-red-ink-seal.png"),
                                    colorFilter: ColorFilter.mode(
                                        Color.fromRGBO(176, 31, 36, .8),
                                        BlendMode.srcIn))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(daLiuPan.monthGeneral.name.split("").first,
                                    style: guiRenNameTextStyle.copyWith(
                                        fontSize: 28 * scaleFactor)),
                                Text(daLiuPan.monthGeneral.name.split("").last,
                                    style: guiRenNameTextStyle.copyWith(
                                        fontSize: 28 * scaleFactor)),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "︹",
                                style: guiRenNameTextStyle.copyWith(
                                    height: 1.0, fontSize: 12 * scaleFactor),
                              ),
                              Text(
                                daLiuPan.monthGeneral.generalZhi.name,
                                style: diZhiTextStyle.copyWith(
                                    height: 1.0,
                                    fontSize: 14,
                                    color: getZhiColor(
                                        daLiuPan.monthGeneral.generalZhi),
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey.withOpacity(.5),
                                        offset: const Offset(0, 0),
                                        blurRadius: 2,
                                      )
                                    ]),
                              ),
                              Text(
                                "将",
                                style: guiRenNameTextStyle.copyWith(
                                    height: 1.0, fontSize: 12 * scaleFactor),
                              ),
                              Text(
                                "︺",
                                style: guiRenNameTextStyle.copyWith(
                                    height: 1.0, fontSize: 12 * scaleFactor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4 * scaleFactor,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _showMonthGeneralJieQi,
                      builder: (ctx, show, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (c, animation) {
                            if ((c.key as ValueKey).value == "jie_qi") {
                              logger.d("display jie_qi");
                              // display jie_qi
                              return c
                                  .animate()
                                  .moveY(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      begin: -2,
                                      end: 0)
                                  .fade(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      begin: 0,
                                      end: 1);
                            } else {
                              logger.d("hidden jie_qi");
                              return c
                                  .animate()
                                  .moveY(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      begin: 0,
                                      end: -1)
                                  .fade(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      begin: 1,
                                      end: 0);
                            }
                          },
                          child: show
                              ? child
                              : const SizedBox(
                                  key: ValueKey("blank"),
                                ),
                        );
                      },
                      child: Column(
                        key: const ValueKey("jie_qi"),
                        children: [
                          SizedBox(
                              width: 30 * scaleFactor,
                              child: TwentyFourJieQiTag(
                                jieQi: daLiuPan.monthGeneral.jieSegment.item1,
                                fontColor: Colors.blueGrey,
                                backgroundColor: ConstResourcesMapper
                                    .Seasons24ColorMapper[daLiuPan
                                        .monthGeneral.jieSegment.item1.name]!
                                    .withOpacity(.2),
                                isHor: true,
                              )),
                          SizedBox(height: 2 * scaleFactor),
                          SizedBox(
                              width: 30 * scaleFactor,
                              child: TwentyFourJieQiTag(
                                  jieQi: daLiuPan.monthGeneral.jieSegment.item2,
                                  fontColor: Colors.blueGrey,
                                  backgroundColor: ConstResourcesMapper
                                      .Seasons24ColorMapper[daLiuPan
                                          .monthGeneral.jieSegment.item2.name]!
                                      .withOpacity(.2),
                                  isHor: true)),
                        ],
                      ))
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.1),
                    borderRadius: BorderRadius.circular(8 * scaleFactor),
                  ),
                  child: buildClassType(daLiuPan))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!hideThreeChuan)
                build_san_chuan(daLiuPan.getThreeChuan(), gongSize, scaleFactor)
              else
                SizedBox(height: gongSize.height * 2 * 0.25),
              if (!hideFourClass)
                build_four_ke(daLiuPan.getFourClass(), gongSize, scaleFactor)
              else
                SizedBox(height: gongSize.height * 2 * 0.25),
            ],
          )
        ],
      ),
    );
  }

  Widget buildMonthGeneral(DaLiuRenKePan daLiuPan) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 24,
                  child: TwentyFourJieQiTag(
                    jieQi: daLiuPan.monthGeneral.jieSegment.item1,
                    fontColor: Colors.blueGrey,
                    backgroundColor: ConstResourcesMapper.Seasons24ColorMapper[
                            daLiuPan.monthGeneral.jieSegment.item1.name]!
                        .withOpacity(.2),
                    isHor: true,
                  )),
              SizedBox(
                  width: 24,
                  child: TwentyFourJieQiTag(
                      jieQi: daLiuPan.monthGeneral.jieSegment.item2,
                      fontColor: Colors.blueGrey,
                      backgroundColor: ConstResourcesMapper
                          .Seasons24ColorMapper[
                              daLiuPan.monthGeneral.jieSegment.item2.name]!
                          .withOpacity(.2),
                      isHor: true)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        "${ICONS_ASSETS_PATH}/chinese-red-ink-seal.png"),
                    colorFilter: ColorFilter.mode(
                        Color.fromRGBO(176, 31, 36, .8), BlendMode.srcIn))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(daLiuPan.monthGeneral.name.split("").first,
                    style: guiRenNameTextStyle.copyWith(fontSize: 28)),
                Text(daLiuPan.monthGeneral.name.split("").last,
                    style: guiRenNameTextStyle.copyWith(fontSize: 28)),
                // Text(daLiuPan.monthGeneral.name.split("").first,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Color.fromRGBO(242,190,69, 1)),),
                // Text(daLiuPan.monthGeneral.name.split("").last,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Color.fromRGBO(242,190,69, 1)),),
                // GoldText(text: daLiuPan.monthGeneral.name.split("").first,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w200)),
                // GoldText(text: daLiuPan.monthGeneral.name.split("").last,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w200)),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "︹",
                style: guiRenNameTextStyle.copyWith(height: 1.0, fontSize: 12),
              ),
              Text(
                daLiuPan.monthGeneral.generalZhi.name,
                style: diZhiTextStyle.copyWith(
                    height: 1.0,
                    fontSize: 14,
                    color: getZhiColor(daLiuPan.monthGeneral.generalZhi),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.grey.withOpacity(.5),
                        offset: const Offset(0, 0),
                        blurRadius: 2,
                      )
                    ]),
              ),
              Text(
                "将",
                style: guiRenNameTextStyle.copyWith(height: 1.0, fontSize: 12),
              ),
              Text(
                "︺",
                style: guiRenNameTextStyle.copyWith(height: 1.0, fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
    return Container(
      alignment: Alignment.center,
      // height: 120,
      // width: 120,
      // color: Colors.black.withOpacity(.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 14,
                        child: TwentyFourJieQiTag(
                          jieQi: daLiuPan.monthGeneral.jieSegment.item1,
                          fontColor: Colors.blueGrey,
                        )),
                    SizedBox(
                        width: 14,
                        child: TwentyFourJieQiTag(
                          jieQi: daLiuPan.monthGeneral.jieSegment.item2,
                          fontColor: Colors.blueGrey,
                        )),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              "${ICONS_ASSETS_PATH}/chinese-red-ink-seal.png"),
                          colorFilter: ColorFilter.mode(
                              Color.fromRGBO(176, 31, 36, .8),
                              BlendMode.srcIn))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(daLiuPan.monthGeneral.name.split("").first,
                          style: guiRenNameTextStyle.copyWith(fontSize: 28)),
                      Text(daLiuPan.monthGeneral.name.split("").last,
                          style: guiRenNameTextStyle.copyWith(fontSize: 28)),
                      // Text(daLiuPan.monthGeneral.name.split("").first,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Color.fromRGBO(242,190,69, 1)),),
                      // Text(daLiuPan.monthGeneral.name.split("").last,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Color.fromRGBO(242,190,69, 1)),),
                      // GoldText(text: daLiuPan.monthGeneral.name.split("").first,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w200)),
                      // GoldText(text: daLiuPan.monthGeneral.name.split("").last,style: guiRenNameTextStyle.copyWith(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w200)),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "︹",
                      style: guiRenNameTextStyle.copyWith(
                          height: 1.0, fontSize: 12),
                    ),
                    Text(
                      daLiuPan.monthGeneral.generalZhi.name,
                      style: diZhiTextStyle.copyWith(
                          height: 1.0,
                          fontSize: 14,
                          color: getZhiColor(daLiuPan.monthGeneral.generalZhi),
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.grey.withOpacity(.5),
                              offset: const Offset(0, 0),
                              blurRadius: 2,
                            )
                          ]),
                    ),
                    Text(
                      "将",
                      style: guiRenNameTextStyle.copyWith(
                          height: 1.0, fontSize: 12),
                    ),
                    Text(
                      "︺",
                      style: guiRenNameTextStyle.copyWith(
                          height: 1.0, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFourZhuEightChar(DaLiuRenKePan daLiuPan) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FourZhuEightChar(
            year: daLiuPan.yearJiaZi,
            month: daLiuPan.monthJiaZi,
            day: daLiuPan.dayJiaZi,
            chen: daLiuPan.timeJiaZi,
            isColorful: true,
            zodiacGanColors: ConstResourcesMapper.zodiacGanColors,
            zodiacZhiColors: ConstResourcesMapper.zodiacZhiColors,
          ),
        ],
      ),
    );
  }

  Widget buildClassType(DaLiuRenKePan daLiuPan) {
    final keTiNames = context.read<DaLiuRenViewModel>().matchedKeTiNames;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '课格',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey),
          ),
          const SizedBox(height: 4),
          if (keTiNames.isNotEmpty)
            ...keTiNames.map((name) => Text(
                  name,
                  style: eightSeasonTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey.shade500),
                  textAlign: TextAlign.center,
                )),
        ]);
  }

  TextStyle diZhiTextStyle = GoogleFonts.maShanZheng(height: 1, fontSize: 32);
  TextStyle godsNameTextStyle =
      GoogleFonts.zhiMangXing(height: 1, fontSize: 18);

  bool withDiZhiColor = true;

  Text wrappedDiZhiText(DiZhi diZhi, TextStyle textStyle) {
    if (withDiZhiColor) {
      return Text(
        diZhi.value,
        style: textStyle.copyWith(
            color: ConstResourcesMapper.zodiacZhiColors[diZhi]!),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        diZhi.value,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget build_four_ke(FourClass fourClass, Size gongSize, double scaleFactor) {
    double diZhiFontSize = gongSize.width * .24;
    // double otherFontSize = gongSize.width * .24; // Removed duplicate variable
    TextStyle tianGanStyle = ConstUIResourcesMapper.tianGanTextStyle
        .copyWith(fontSize: diZhiFontSize, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    TextStyle diZhiStyle = ConstUIResourcesMapper.twelveDiZhiTextStyle
        .copyWith(fontSize: diZhiFontSize, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    TextStyle guiRenName =
        guiRenNameTextStyle.copyWith(fontSize: gongSize.width * .14, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    SizedBox intervalSize = SizedBox(width: 6 * scaleFactor);
    // double height = gongSize.height; // Removed unused variable
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "四",
              style: GoogleFonts.maShanZheng(
                  height: 1, fontSize: 18 * scaleFactor),
            ),
            Text(fourClass.fourth.guiRen.name, style: guiRenName),
            Text(fourClass.fourth.sky.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.fourth.sky))),
            Text(fourClass.fourth.ground.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.fourth.ground)))
          ],
        ),
        intervalSize,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "三",
              style: GoogleFonts.maShanZheng(
                  height: 1, fontSize: 18 * scaleFactor),
            ),
            Text(fourClass.third.guiRen.name, style: guiRenName),
            Text(fourClass.third.sky.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.third.sky))),
            Text(fourClass.third.ground.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.third.ground)))
          ],
        ),
        intervalSize,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "二",
              style: GoogleFonts.maShanZheng(
                  height: 1, fontSize: 18 * scaleFactor),
            ),
            Text(fourClass.second.guiRen.name, style: guiRenName),
            Text(fourClass.second.sky.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.second.sky))),
            Text(fourClass.second.ground.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(fourClass.second.ground)))
          ],
        ),
        intervalSize,
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "一",
                    style: GoogleFonts.maShanZheng(
                        height: 1, fontSize: 18 * scaleFactor),
                  ),
                  Text(fourClass.first.guiRen.name, style: guiRenName),
                  Center(
                    child: Text(fourClass.first.sky.value,
                        style: diZhiStyle.copyWith(
                            color: getZhiColor(fourClass.first.sky))),
                  ),
                  Center(
                    child: Text(fourClass.first.tianGan.value,
                        style: tianGanStyle.copyWith(
                            color: getGanColor(fourClass.first.tianGan))),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(fourClass.first.ground.value,
                    style: diZhiStyle.copyWith(
                        color: getZhiColor(fourClass.first.ground),
                        fontSize: gongSize.width * .16)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget build_san_chuan(ThreeChuan chuan, Size gongSize, double scaleFactor) {
    double diZhiFontSize = gongSize.width * .24;
    TextStyle otherStyle =
        guiRenNameTextStyle.copyWith(fontSize: gongSize.width * .16, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);

    // TextStyle jiaZi = otherStyle.copyWith(fontSize: 20);
    TextStyle tianGanStyle = ConstUIResourcesMapper.tianGanTextStyle
        .copyWith(fontSize: gongSize.width * .2, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    TextStyle diZhiStyle = ConstUIResourcesMapper.twelveDiZhiTextStyle
        .copyWith(fontSize: diZhiFontSize, shadows: [
      Shadow(
          color: Colors.grey.withOpacity(.5),
          blurRadius: 2,
          offset: const Offset(0, 0))
    ]);
    // TextStyle sixQing = guiRenNameTextStyle.copyWith(fontSize: gongSize.width * .16,shadows:[Shadow(color: Colors.grey.withOpacity(.5), blurRadius: 2, offset: Offset(0, 0))]);
    SizedBox offset = SizedBox(width: 4 * scaleFactor);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "初",
              style: otherStyle,
            ),
            offset,
            // Text("兄弟",style: otherStyle),
            Text(chuan.first.liuQin.name, style: otherStyle),
            offset,
            chuan.first.tianGan == null
                ? buildKongWangCircle(otherStyle.color, 16 * scaleFactor)
                : Text(chuan.first.tianGan!.value,
                    style: tianGanStyle.copyWith(
                        color: getGanColor(chuan.first.tianGan!))),
            Text(chuan.first.diZhi.value,
                style:
                    diZhiStyle.copyWith(color: getZhiColor(chuan.first.diZhi))),
            offset,
            Text(chuan.first.guiRen.name, style: otherStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("中", style: otherStyle),
            offset,
            Text(chuan.second.liuQin.name, style: otherStyle),
            offset,
            chuan.second.tianGan == null
                ? buildKongWangCircle(otherStyle.color, 16 * scaleFactor)
                : Text(chuan.second.tianGan!.value,
                    style: tianGanStyle.copyWith(
                        color: getGanColor(chuan.second.tianGan!))),
            Text(chuan.second.diZhi.value,
                style: diZhiStyle.copyWith(
                    color: getZhiColor(chuan.second.diZhi))),
            offset,
            Text(chuan.second.guiRen.name, style: otherStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("末", style: otherStyle),
            offset,
            Text(chuan.third.liuQin.name, style: otherStyle),
            offset,
            chuan.third.tianGan == null
                ? buildKongWangCircle(otherStyle.color, 16 * scaleFactor)
                : Text(chuan.third.tianGan!.value,
                    style: tianGanStyle.copyWith(
                        color: getGanColor(chuan.third.tianGan!))),
            Text(chuan.third.diZhi.value,
                style:
                    diZhiStyle.copyWith(color: getZhiColor(chuan.third.diZhi))),
            offset,
            Text(chuan.third.guiRen.name, style: otherStyle)
          ],
        ),
      ],
    );
  }

  TextStyle normalTextStyle =
      GoogleFonts.zhiMangXing(color: Colors.black87, fontSize: 12, height: 1.0);

  Widget each_zhu(
      String name, JiaZi xunHead, JiaZi jiaZi, Tuple2<DiZhi, DiZhi> kongWang) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: ConstUIResourcesMapper.twelveDiZhiTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.0,
              shadows: []),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          xunHead.ganZhiStr,
          style: normalTextStyle.copyWith(fontSize: 16),
        ),
        Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          child: Text(jiaZi.tianGan.value,
              style: eightSeasonTextStyle.copyWith(
                  fontSize: 28,
                  color: ConstResourcesMapper.zodiacGanColors[jiaZi.tianGan]!,
                  fontWeight: FontWeight.w100)),
        ),
        // SizedBox(height: 2,),
        Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          child: Text(jiaZi.diZhi.value,
              style: ConstUIResourcesMapper.twelveDiZhiTextStyle.copyWith(
                  fontSize: 28,
                  color: ConstResourcesMapper.zodiacZhiColors[jiaZi.diZhi],
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          "${kongWang.item1.value}${kongWang.item2.value}",
          style: normalTextStyle.copyWith(fontSize: 16),
        )
      ],
    );
  }

  Widget panel_gong(DaLiuRenPanel daLiuPan, Size gongSize, double scaleFactor) {
    // double width = 200;
    // double height = 200;
    Map<DiZhi, Widget> gongWidgetMapper = {};
    daLiuPan.getGongMapper().forEach((key, value) {
      gongWidgetMapper[key] =
          content(value.groundPanDiZhi, value, gongSize, scaleFactor);
    });
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.SI]!,
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.WU],
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.WEI],
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.SHEN],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.CHEN]!,
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.YOU],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.MAO],
                ),
                // center blank
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.XU],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.YIN],
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.CHOU],
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.ZI],
                ),
                SizedBox(
                  width: gongSize.width,
                  height: gongSize.height,
                  child: gongWidgetMapper[DiZhi.HAI],
                )
              ],
            ),
          ],
        ));
  }

  Widget content(
      DiZhi diZhi, DaLiuRenGong gong, Size gongSize, double scaleFactor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        backgroundContent(diZhi, gongSize, scaleFactor),
        buildTianGanJiZhi(diZhi, gongSize, scaleFactor),
        eachGong(gong, gongSize, scaleFactor)
      ],
    );
  }

  Widget buildTianGanJiZhi(DiZhi diZhi, Size gongSize, double scaleFactor,
      {bool isSecond = false}) {
    double defaultOpacity = .3;
    BoxDecoration boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(4 * scaleFactor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1 * scaleFactor,
            blurRadius: 1 * scaleFactor,
          ),
        ]);
    TextStyle fontStyle = TextStyle(
        color: Colors.white,
        fontSize: gongSize.width * .12,
        height: 1,
        fontWeight: FontWeight.bold);
    if (diZhi == DiZhi.YIN) {
      TianGan gan = TianGan.JIA;
      return Positioned(
        left: gongSize.width * .1,
        child: Opacity(
          opacity: defaultOpacity,
          child: Container(
            padding: EdgeInsets.all(4 * scaleFactor),
            alignment: Alignment.center,
            decoration: boxDecoration.copyWith(color: getGanColor(gan)),
            child: Text(gan.name, style: fontStyle),
          ),
        ),
      );
    } else if (diZhi == DiZhi.CHEN) {
      TianGan gan = TianGan.YI;
      return Positioned(
        left: gongSize.width * .1,
        child: Opacity(
          opacity: defaultOpacity,
          child: Container(
            padding: EdgeInsets.all(4 * scaleFactor),
            alignment: Alignment.center,
            decoration: boxDecoration.copyWith(color: getGanColor(gan)),
            child: Text(gan.name, style: fontStyle),
          ),
        ),
      );
    } else if (diZhi == DiZhi.CHOU) {
      TianGan gan = TianGan.GUI;
      return Positioned(
        left: gongSize.width * .1,
        child: Opacity(
          opacity: defaultOpacity,
          child: Container(
            padding: EdgeInsets.all(4 * scaleFactor),
            alignment: Alignment.center,
            decoration: boxDecoration.copyWith(color: getGanColor(gan)),
            child: Text(gan.name, style: fontStyle),
          ),
        ),
      );
    } else if (diZhi == DiZhi.HAI) {
      TianGan gan = TianGan.REN;
      return Positioned(
        left: gongSize.width * .1,
        child: Opacity(
          opacity: defaultOpacity,
          child: Container(
            padding: EdgeInsets.all(4 * scaleFactor),
            alignment: Alignment.center,
            decoration: boxDecoration.copyWith(color: getGanColor(gan)),
            child: Text(gan.name, style: fontStyle),
          ),
        ),
      );
    } else if (diZhi == DiZhi.XU) {
      TianGan gan = TianGan.XIN;
      return Positioned(
        left: gongSize.width * .1,
        top: gongSize.width * .1,
        child: Opacity(
          opacity: defaultOpacity,
          child: Container(
            padding: EdgeInsets.all(4 * scaleFactor),
            alignment: Alignment.center,
            decoration: boxDecoration.copyWith(color: getGanColor(gan)),
            child: Text(gan.name, style: fontStyle),
          ),
        ),
      );
    } else if (diZhi == DiZhi.SHEN) {
      TianGan gan = TianGan.GENG;
      return Positioned(
        left: gongSize.width * .1,
        child: Opacity(
          opacity: defaultOpacity,
          child: Container(
            padding: EdgeInsets.all(4 * scaleFactor),
            alignment: Alignment.center,
            decoration: boxDecoration.copyWith(color: getGanColor(gan)),
            child: Text(gan.name, style: fontStyle),
          ),
        ),
      );
    } else if (diZhi == DiZhi.SI) {
      TianGan gan = TianGan.BING;
      TianGan gan1 = TianGan.WU;
      return Positioned(
        left: gongSize.width * .1,
        top: gongSize.width * .2,
        child: Column(
          children: [
            Opacity(
              opacity: defaultOpacity,
              child: Container(
                padding: EdgeInsets.all(4 * scaleFactor),
                alignment: Alignment.center,
                decoration: boxDecoration.copyWith(color: getGanColor(gan)),
                child: Text(gan.name, style: fontStyle),
              ),
            ),
            SizedBox(
              height: 4 * scaleFactor,
            ),
            Opacity(
              opacity: defaultOpacity,
              child: Container(
                padding: EdgeInsets.all(4 * scaleFactor),
                alignment: Alignment.center,
                decoration: boxDecoration.copyWith(color: getGanColor(gan1)),
                child: Text(gan1.name, style: fontStyle),
              ),
            ),
          ],
        ),
      );
    } else if (diZhi == DiZhi.WEI) {
      TianGan gan = TianGan.DING;
      TianGan gan1 = TianGan.JI;
      return Positioned(
        left: gongSize.width * .1,
        top: gongSize.width * .2,
        child: Column(
          children: [
            Opacity(
              opacity: defaultOpacity,
              child: Container(
                padding: EdgeInsets.all(4 * scaleFactor),
                alignment: Alignment.center,
                decoration: boxDecoration.copyWith(color: getGanColor(gan)),
                child: Text(gan.name, style: fontStyle),
              ),
            ),
            SizedBox(
              height: 4 * scaleFactor,
            ),
            Opacity(
              opacity: defaultOpacity,
              child: Container(
                padding: EdgeInsets.all(4 * scaleFactor),
                alignment: Alignment.center,
                decoration: boxDecoration.copyWith(color: getGanColor(gan1)),
                child: Text(gan1.name, style: fontStyle),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget eachGong(DaLiuRenGong gong, Size gongSize, double scaleFactor) {
    return Container(
      width: gongSize.width,
      height: gongSize.height,
      alignment: Alignment.center,
      child: centerContent(gong, gongSize, scaleFactor),
    );
  }

  Widget backgroundContent(DiZhi diZhi, Size gongSize, double scaleFactor) {
    BorderRadius radius = BorderRadius.zero;
    double borderRadiusSize = 32 * scaleFactor;
    Border border = Border.all(color: Colors.grey, width: 1 * scaleFactor);
    BorderSide defaultBorderSide =
        BorderSide(color: Colors.grey, width: 1 * scaleFactor);
    Alignment alignment = Alignment.center;
    switch (diZhi) {
      case DiZhi.ZI:
        border = Border(
            top: defaultBorderSide,
            bottom: defaultBorderSide,
            left: defaultBorderSide);
        alignment = Alignment.topCenter;
        break;
      case DiZhi.CHOU:
        border = Border(top: defaultBorderSide, bottom: defaultBorderSide);
        alignment = Alignment.topCenter;
        break;
      case DiZhi.WU:
        alignment = Alignment.bottomCenter;
        border = Border(
            top: defaultBorderSide,
            bottom: defaultBorderSide,
            right: defaultBorderSide);
        break;
      case DiZhi.WEI:
        alignment = Alignment.bottomCenter;
        border = Border(top: defaultBorderSide, bottom: defaultBorderSide);
        break;

      case DiZhi.CHEN:
        border = Border(left: defaultBorderSide, right: defaultBorderSide);
        alignment = Alignment.centerRight;
        break;
      case DiZhi.YOU:
        border = Border(left: defaultBorderSide, right: defaultBorderSide);
        alignment = Alignment.centerLeft;
        break;
      case DiZhi.XU:
        border = Border(
            left: defaultBorderSide,
            right: defaultBorderSide,
            top: defaultBorderSide);
        alignment = Alignment.centerLeft;
        break;
      case DiZhi.MAO:
        alignment = Alignment.centerRight;
        border = Border(
            left: defaultBorderSide,
            right: defaultBorderSide,
            top: defaultBorderSide);
        break;

      case DiZhi.YIN:
        alignment = Alignment.topRight;
        radius =
            BorderRadius.only(bottomLeft: Radius.circular(borderRadiusSize));
        break;

      case DiZhi.SI:
        alignment = Alignment.bottomRight;
        radius = BorderRadius.only(topLeft: Radius.circular(borderRadiusSize));
        break;
      case DiZhi.SHEN:
        alignment = Alignment.bottomLeft;
        radius = BorderRadius.only(topRight: Radius.circular(borderRadiusSize));
        break;
      case DiZhi.HAI:
        alignment = Alignment.topLeft;
        radius =
            BorderRadius.only(bottomRight: Radius.circular(borderRadiusSize));
        break;
    }
    return Container(
        width: gongSize.width,
        height: gongSize.height,
        alignment: alignment,
        padding: EdgeInsets.all(12 * scaleFactor),
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: Text(
          diZhi.value,
          style: ConstUIResourcesMapper.twelveDiZhiTextStyle.copyWith(
              color: Colors.grey.withOpacity(scaleFactor < 1.0 ? .1 : .2),
              fontSize: gongSize.width * .3),
        ));
  }

  // zhiMangXing
  TextStyle guiRenNameTextStyle = GoogleFonts.maShanZheng(
      fontSize: 24,
      color: const Color.fromRGBO(68, 68, 60, 1), // 墨染
      // color: Color.fromRGBO(255, 229, 248, 1), // 墨染
      height: 1.0,
      shadows: [
        Shadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 2,
            offset: const Offset(0, 0))
      ]);
  TextStyle nineGongNumberTextStyle = GoogleFonts.notoSerif(
    color: Colors.black,
    fontSize: 20,
    height: 1,
  );
  TextStyle eightSkyDoorTextStyle = GoogleFonts.maShanZheng(
    fontSize: 16,
    color: Colors.grey,
    // fontWeight: FontWeight.w600,
  );
  TextStyle twelveDiZhiTextStyle = GoogleFonts.longCang(
      color: Colors.black,
      fontSize: 48,
      height: 1,
      fontWeight: FontWeight.w500,
      shadows: [
        Shadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 2,
            offset: const Offset(0, 0))
      ]);
  TextStyle eightSeasonTextStyle = GoogleFonts.zhiMangXing(
      color: const Color.fromRGBO(28, 45, 37, 1),
      fontWeight: FontWeight.w200,
      fontSize: 26,
      height: 1,
      shadows: [
        Shadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 2,
            offset: const Offset(0, 0))
      ]);

  Widget centerContent(
      DaLiuRenGong daLiuRenGong, Size gongSize, double scaleFactor) {
    double middleHeight = gongSize.height * .5;
    double godFontSize = gongSize.height * .16;
    double jiaZiFontSize = gongSize.height * .16;
    return Container(
      height: gongSize.height,
      width: gongSize.width,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: gongSize.height * .1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: gongSize.height * .16 + (scaleFactor < 1.0 ? 4 : 0),
              width: gongSize.height * .34 + (scaleFactor < 1.0 ? 4 : 0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  daLiuRenGong.guiRen == GuiRen.GUI_REN
                      ? SizedBox(
                          width: gongSize.height * .34 +
                              (scaleFactor < 1.0 ? 4 : 0),
                          child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Color.fromRGBO(176, 31, 36, .7),
                                  BlendMode.srcIn),
                              child: Image.asset(
                                "${ICONS_ASSETS_PATH}/wide-black-ink-radian-line2.png",
                              )))
                      : const SizedBox(),
                  Text(
                    daLiuRenGong.guiRen.name,
                    style: guiRenNameTextStyle.copyWith(
                        fontSize: godFontSize + (scaleFactor < 1.0 ? 2 : 0)),
                  ),
                ],
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: gongSize.width * .2,
              ),
              Container(
                height: gongSize.width * .4,
                alignment: Alignment.center,
                child: Text(
                  daLiuRenGong.skyPanDiZhi.value,
                  style: ConstUIResourcesMapper.twelveDiZhiTextStyle.copyWith(
                      color: ConstResourcesMapper
                          .zodiacZhiColors[daLiuRenGong.skyPanDiZhi]!,
                      fontSize:
                          (gongSize.width * .4) - (scaleFactor < 1.0 ? 2 : 0)),
                ),
              ),
              Container(
                height: middleHeight,
                width: gongSize.width * .2,
                alignment: Alignment.bottomCenter,
                // color: Colors.red.withOpacity(.5),
                // padding: EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(child: SizedBox()),
                    daLiuRenGong.tianGan == null
                        ? buildKongWangCircle(
                            const Color.fromRGBO(25, 44, 59, 1),
                            gongSize.width * .2)
                        : Text(
                            daLiuRenGong.tianGan!.value,
                            style: ConstUIResourcesMapper.tianGanTextStyle
                                .copyWith(
                                    color: getGanColor(daLiuRenGong.tianGan!),
                                    fontSize: gongSize.width * .2),
                          ),
                  ],
                ),
              )
            ],
          ),
          Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              daLiuRenGong.jiaZi != null
                  ? Text(
                      "「${daLiuRenGong.jiaZi?.ganZhiStr}」",
                      style: eightSkyDoorTextStyle.copyWith(
                          fontSize: jiaZiFontSize),
                    )
                  : RichText(
                      text: TextSpan(
                        text: "「",
                        style: eightSkyDoorTextStyle.copyWith(
                            fontSize: jiaZiFontSize),
                        children: [
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: buildKongWangCircle(
                                  eightSkyDoorTextStyle.color, jiaZiFontSize)),
                          TextSpan(
                              text: "${daLiuRenGong.groundPanDiZhi.value}」")
                        ],
                      ),
                    )
            ],
          )),
        ],
      ),
    );
  }

  Widget buildKongWangCircle([Color? color, double size = 32]) {
    return ColorFiltered(
        colorFilter:
            ColorFilter.mode(color ?? Colors.blueGrey, BlendMode.srcIn),
        child: Image.asset(
          "${ICONS_ASSETS_PATH}/thin-black-ink-circle.png",
          width: size,
          height: size,
        ));
  }

  Color getGanColor(TianGan gan) {
    return ConstResourcesMapper.zodiacGanColors[gan]!.withOpacity(.6);
  }

  Color getZhiColor(DiZhi zhi) {
    return ConstResourcesMapper.zodiacZhiColors[zhi]!.withOpacity(.8);
  }

  // 显示神将节气
  bool isLongSticky = false;

  void showMonthlyGeneralJieQi({bool autoHidden = true}) {
    if (!_showMonthGeneralJieQi.value) {
      _showMonthGeneralJieQi.value = true;
      if (autoHidden && _showMonthGeneralJieQiTimer == null) {
        _showMonthGeneralJieQiTimer = Timer(const Duration(seconds: 5), () {
          hideMonthlyGeneralJieQi();
          _showMonthGeneralJieQiTimer = null;
        });
      }
    }
  }

  void hideMonthlyGeneralJieQi() {
    if (_showMonthGeneralJieQi.value) {
      _showMonthGeneralJieQi.value = false;
    }
  }
}
