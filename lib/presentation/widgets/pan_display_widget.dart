import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:daliuren/domain/entities/liu_ren_pan_model.dart';
import 'package:daliuren/presentation/widgets/keti_detail_widget.dart';

class PanDisplayWidget extends StatelessWidget {
  final LiuRenPanModel? liuRenPan;

  const PanDisplayWidget({super.key, required this.liuRenPan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (liuRenPan == null) {
      return Center(child: Text(l10n.pleaseCalculateFirst));
    }

    // TODO: Reconstruct the detailed Pan UI here based on liuRenPan data
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text("${l10n.dayGanZhi}: ${liuRenPan!.dayJiaZi}"),
          Text("${l10n.timeGanZhi}: ${liuRenPan!.timeGanZhi}"),
          Text("${l10n.monthGeneralLabel} ${liuRenPan!.monthGeneral}"),
          Text("${l10n.guiRenLabel} ${liuRenPan!.timeGanZhi}"),
          const SizedBox(height: 16),
          if (liuRenPan!.matchedLessons.isNotEmpty)
            KetiDetailWidget(lessons: liuRenPan!.matchedLessons)
          else if (liuRenPan!.keTiComplement.isNotEmpty)
            Text("${l10n.keTiLabel} ${liuRenPan!.keTiComplement.join(', ')}"),
          const SizedBox(height: 16),
          Text(l10n.tianDiPanPlaceholder,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(l10n.fourClassPlaceholder,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          ...liuRenPan!.fourClasses.map((ke) =>
              Text(" - ${ke.toString()}")),
          const SizedBox(height: 16),
          Text(l10n.threeChuanPlaceholder,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          ...liuRenPan!.threeChuans.map((chuan) =>
              Text(" - ${chuan.toString()}")),
        ],
      ),
    );
  }
}
