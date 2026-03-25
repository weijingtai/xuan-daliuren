import 'package:flutter/material.dart';

class ThreeChuanWidget extends StatelessWidget {
  final List<Map<String, dynamic>> threeChuans;

  const ThreeChuanWidget({Key? key, required this.threeChuans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (threeChuans.isEmpty) {
      return const SizedBox.shrink();
    }

    // TODO: Implement the detailed UI for displaying the Three Chuans (三传)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("三传:", style: Theme.of(context).textTheme.titleSmall),
        ...threeChuans.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, dynamic> chuan = entry.value;
          String chuanName = "";
          if (idx == 0) chuanName = "初传";
          if (idx == 1) chuanName = "中传";
          if (idx == 2) chuanName = "末传";

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              "$chuanName: ${chuan['diZhi'] ?? '?'} (${chuan['tianGan'] ?? '空'}) - ${chuan['guiRen'] ?? '?'} - ${chuan['liuQin'] ?? '?'}"
            ),
          );
        }),
      ],
    );
  }
}
