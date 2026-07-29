import 'package:repository_interface_divination_pipeline/repository_interface_divination_pipeline.dart';

final class DaliurenChartParams implements ModuleParams {
  final String uuid;
  final String? question;
  final DateTime createdAt;

  const DaliurenChartParams({
    required this.uuid,
    this.question,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'question': question,
        'createdAt': createdAt.toIso8601String(),
      };
}
