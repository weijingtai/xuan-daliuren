import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

import 'package:daliuren/domain/entities/yuding_entry.dart';

class YuDingDisplayWidget extends StatelessWidget {
  final YuDingEntry yuDingEntry;

  const YuDingDisplayWidget({
    super.key,
    required this.yuDingEntry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          yuDingEntry.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        RichText(
              text: TextSpan(
                  text: yuDingEntry.raw.join(" "),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)
                  )),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: l10n.keYiFull,
              children: [TextSpan(text: yuDingEntry.meaning)]),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: l10n.jieYueFull,
              children: [TextSpan(text: yuDingEntry.explanation)]),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: l10n.duanYueFull,
              children: [TextSpan(text: yuDingEntry.perdiction)]),
        ),
        const SizedBox(
          height: 12,
        ),
        ...yuDingEntry.otherDetails.entries
            .map((entry) => RichText(
                  text: TextSpan(
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      text: "${entry.key}：",
                      children: [TextSpan(text: entry.value)]),
                ))
            ,
        const SizedBox(
          height: 12,
        ),
        ...yuDingEntry.ancientsBookTextMapper.entries
            .map((entry) => RichText(
                  text: TextSpan(
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      text: "${entry.key}：",
                      children: [TextSpan(text: entry.value)]),
                ))
            
      ],
    );
  }
}
