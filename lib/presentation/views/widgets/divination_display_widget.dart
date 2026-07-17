import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:xuan_common_ui/xuan_common_ui.dart';
import 'package:daliuren/domain/schools/school_catalog.dart';
import 'package:daliuren/presentation/viewmodels/da_liu_ren_viewmodel.dart';
import 'package:daliuren/presentation/widgets/keti_detail_widget.dart';
import 'package:daliuren/presentation/widgets/school_explanation_panel.dart';
import 'package:daliuren/presentation/widgets/school_slider_bar.dart';
import 'package:daliuren/presentation/widgets/shen_sha_display_widget.dart';

class DivinationDisplayWidget extends StatelessWidget {
  const DivinationDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<DaLiuRenViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.currentDivination == null) {
          return Center(
            child: Text(l10n.pleaseSelectTimeToDivine),
          );
        }

        final divination = viewModel.currentDivination!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoCard(context, divination, l10n),
              const SizedBox(height: 16),
              _buildJiaZiInfoCard(context, viewModel, l10n),
              const SizedBox(height: 16),
              _buildDivinationPanel(context, divination, l10n),
              const SizedBox(height: 16),
              if (viewModel.matchedLessons.isNotEmpty)
                KetiDetailWidget(lessons: viewModel.matchedLessons),
              if (viewModel.matchedLessons.isNotEmpty)
                const SizedBox(height: 16),
              ShenShaDisplayWidget(shenShaResults: viewModel.shenShaResults),
              const SizedBox(height: 12),
              const _SchoolSwitcherSection(
                key: Key('school_switcher_section'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, dynamic divination, AppLocalizations l10n) {
    return XuanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.basicInfo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(l10n.timeLabel(divination.panDateTime)),
          if (divination.question != null)
            Text(l10n.questionLabel(divination.question)),
          Text(l10n.eightCharLabel(divination.eightChatStr)),
        ],
      ),
    );
  }

  Widget _buildJiaZiInfoCard(BuildContext context, DaLiuRenViewModel viewModel, AppLocalizations l10n) {
    return XuanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ganZhiInfo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (viewModel.yearJiaZi != null)
            Text('${l10n.yearGanZhi}: ${viewModel.yearJiaZi!.name}'),
          if (viewModel.monthJiaZi != null)
            Text('${l10n.monthGanZhi}: ${viewModel.monthJiaZi!.name}'),
          if (viewModel.dayJiaZi != null)
            Text('${l10n.dayGanZhi}: ${viewModel.dayJiaZi!.name}'),
          if (viewModel.timeJiaZi != null)
            Text('${l10n.timeGanZhi}: ${viewModel.timeJiaZi!.name}'),
        ],
      ),
    );
  }

  Widget _buildDivinationPanel(BuildContext context, dynamic divination, AppLocalizations l10n) {
    return XuanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.divinationPanel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _buildFourClassSection(context, divination, l10n),
          const SizedBox(height: 16),
          _buildThreeChuanSection(context, divination, l10n),
          const SizedBox(height: 16),
          _buildTwelvePalacesSection(context, divination, l10n),
        ],
      ),
    );
  }

  Widget _buildFourClassSection(BuildContext context, dynamic divination, AppLocalizations l10n) {
    final fourClass = divination.fourClass;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.fourClass,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildClassItem(l10n.firstClass, fourClass.first.sky.name, fourClass.first.ground.name),
                  _buildClassItem(l10n.secondClass, fourClass.second.sky.name, fourClass.second.ground.name),
                  _buildClassItem(l10n.thirdClass, fourClass.third.sky.name, fourClass.third.ground.name),
                  _buildClassItem(l10n.fourthClass, fourClass.fourth.sky.name, fourClass.fourth.ground.name),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  if (fourClass.isFuYin)
                    Chip(label: Text(l10n.fuYin), backgroundColor: Colors.blue[100]),
                  if (fourClass.isFanYin)
                    Chip(label: Text(l10n.fanYin), backgroundColor: Colors.orange[100]),
                  if (fourClass.isFullClass)
                    Chip(label: Text(l10n.fourClassComplete), backgroundColor: Colors.green[100]),
                  if (fourClass.isThreeClassOnly)
                    Chip(label: Text(l10n.threeClassOnly), backgroundColor: Colors.purple[100]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassItem(String title, String sky, String ground) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Text(sky, style: const TextStyle(fontWeight: FontWeight.bold)),
              const XuanDivider.horizontal(),
              Text(ground),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThreeChuanSection(BuildContext context, dynamic divination, AppLocalizations l10n) {
    final threeChuan = divination.threeChuan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.threeChuan,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Chip(
                label: Text('${l10n.nineZongMen}: ${threeChuan.nineZongMen.name}'),
                backgroundColor: Colors.amber[100],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildChuanItem(l10n.initialChuan, threeChuan.first),
                  _buildChuanItem(l10n.middleChuan, threeChuan.second),
                  _buildChuanItem(l10n.finalChuan, threeChuan.third),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChuanItem(String title, dynamic chuan) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrange, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (chuan.tianGan != null)
                Text('${chuan.tianGan.name}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                chuan.diZhi.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text('${chuan.guiRen.name}', style: const TextStyle(fontSize: 10)),
              Text('${chuan.liuQin.name}', style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTwelvePalacesSection(BuildContext context, dynamic divination, AppLocalizations l10n) {
    final gongMapper = divination.gongMapper;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.twelvePalaces,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final diZhi = divination.gongMapper.keys.elementAt(index);
              final gong = gongMapper[diZhi];
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gong.skyPanDiZhi.name,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const XuanDivider.horizontal(),
                    Text(
                      gong.groundPanDiZhi.name,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SchoolSwitcherSection extends StatefulWidget {
  const _SchoolSwitcherSection({super.key});

  @override
  State<_SchoolSwitcherSection> createState() => _SchoolSwitcherSectionState();
}

class _SchoolSwitcherSectionState extends State<_SchoolSwitcherSection> {
  String _selectedSchoolId = 'yuding';

  void _handleSchoolChanged(String id) {
    if (id == _selectedSchoolId) return;
    setState(() {
      _selectedSchoolId = id;
    });
  }

  Duration _motionDuration(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SchoolSliderBar(
          key: const Key('divination_school_slider_bar'),
          schools: SchoolCatalog.all,
          selectedSchoolId: _selectedSchoolId,
          onChanged: _handleSchoolChanged,
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: _motionDuration(context),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: SchoolExplanationPanel(
            key: ValueKey<String>(
                'school_explanation_panel_$_selectedSchoolId'),
            selectedSchoolId: _selectedSchoolId,
          ),
        ),
      ],
    );
  }
}
