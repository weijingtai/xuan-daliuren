import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

class FourClassWidget extends StatelessWidget {
  final List<Map<String, dynamic>> fourClasses;

  const FourClassWidget({super.key, required this.fourClasses});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (fourClasses.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${l10n.fourClass}:", style: Theme.of(context).textTheme.titleSmall),
        ...fourClasses.map((ke) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              "上:${ke['sky'] ?? '?'} (${ke['guiRen'] ?? '?'}) / 下:${ke['ground'] ?? '?'} ${ke.containsKey('tianGan') ? '(干:${ke['tianGan']})' : ''}"
            ),
          );
        }),
      ],
    );
  }
}
