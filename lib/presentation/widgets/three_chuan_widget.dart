import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

class ThreeChuanWidget extends StatelessWidget {
  final List<Map<String, dynamic>> threeChuans;

  const ThreeChuanWidget({super.key, required this.threeChuans});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (threeChuans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${l10n.threeChuan}:", style: Theme.of(context).textTheme.titleSmall),
        ...threeChuans.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, dynamic> chuan = entry.value;
          String chuanName = "";
          if (idx == 0) chuanName = l10n.initialChuan;
          if (idx == 1) chuanName = l10n.middleChuan;
          if (idx == 2) chuanName = l10n.finalChuan;

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
