import 'package:flutter/material.dart';

class FourClassWidget extends StatelessWidget {
  final List<Map<String, dynamic>> fourClasses;

  const FourClassWidget({super.key, required this.fourClasses});

  @override
  Widget build(BuildContext context) {
    if (fourClasses.isEmpty) {
      return const SizedBox.shrink();
    }
    // TODO: Implement the detailed UI for displaying the Four Classes (四课)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("四课:", style: Theme.of(context).textTheme.titleSmall),
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
