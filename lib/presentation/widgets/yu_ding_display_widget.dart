import 'package:flutter/material.dart';

import 'package:daliuren/domain/entities/yuding_entry.dart';

class YuDingDisplayWidget extends StatelessWidget {
  final YuDingEntry yuDingEntry;

  const YuDingDisplayWidget({
    super.key,
    required this.yuDingEntry,
  });

  @override
  Widget build(BuildContext context) {
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
              text: "课义：",
              children: [TextSpan(text: yuDingEntry.meaning)]),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: "解曰：",
              children: [TextSpan(text: yuDingEntry.explanation)]),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              text: "断曰：",
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
