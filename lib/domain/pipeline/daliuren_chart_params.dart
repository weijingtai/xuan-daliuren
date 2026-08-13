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

  /// JSON 解码器（与 [toJson] 严格互逆）。
  ///
  /// - 缺字段套默认：`uuid` 空串、`question` null、`createdAt` epoch（1970-01-01），不抛错。
  /// - 字段存在但类型不合法（如 `uuid: 123`、`createdAt: 42`、`question: 7`）抛
  ///   [FormatException]，不静默兜底。
  factory DaliurenChartParams.fromJson(Map<String, dynamic> json) {
    final uuidRaw = json['uuid'];
    if (uuidRaw != null && uuidRaw is! String) {
      throw FormatException('uuid 类型不合法: $uuidRaw');
    }
    final questionRaw = json['question'];
    if (questionRaw != null && questionRaw is! String) {
      throw FormatException('question 类型不合法: $questionRaw');
    }
    final createdAtRaw = json['createdAt'];
    if (createdAtRaw != null && createdAtRaw is! String) {
      throw FormatException('createdAt 类型不合法: $createdAtRaw');
    }

    return DaliurenChartParams(
      uuid: (uuidRaw as String?) ?? '',
      question: questionRaw as String?,
      createdAt: _parseDateTime(createdAtRaw),
    );
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
      throw FormatException('createdAt 非合法 ISO-8601 时间串: $value');
    }
    if (value is DateTime) return value;
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    throw FormatException('createdAt 类型不合法: $value');
  }

  @override
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        if (question != null) 'question': question,
        'createdAt': createdAt.toIso8601String(),
      };
}
