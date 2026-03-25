import 'package:flutter/material.dart';
import 'package:daliuren/domain/entities/liu_ren_pan_model.dart';

class PanDisplayWidget extends StatelessWidget {
  final LiuRenPanModel? liuRenPan;

  const PanDisplayWidget({Key? key, required this.liuRenPan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (liuRenPan == null) {
      return const Center(child: Text("请先排盘"));
    }

    // TODO: Reconstruct the detailed Pan UI here based on liuRenPan data
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text("日干支: ${liuRenPan!.dayJiaZi}"),
          Text("时干支: ${liuRenPan!.timeGanZhi}"),
          Text("月将: ${liuRenPan!.monthGeneral}"),
          Text("贵人: ${liuRenPan!.timeGanZhi}"),
          const SizedBox(height: 16),
          Text("课体: ${liuRenPan!.keTiComplement.join(', ')}"),
          const SizedBox(height: 16),
          const Text("天地盘 (Placeholder):",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("四课 (Placeholder):",
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...liuRenPan!.fourClasses.map((ke) =>
              Text(" - ${ke.toString()}")),
          const SizedBox(height: 16),
          const Text("三传 (Placeholder):",
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...liuRenPan!.threeChuans.map((chuan) =>
              Text(" - ${chuan.toString()}")),
        ],
      ),
    );
  }
}
