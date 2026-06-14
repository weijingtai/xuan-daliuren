/// 大六壬输入状态模型
///
/// 封装手动排盘所需的用户输入，用于 ViewModel 层。
/// 使用不可变对象 + copyWith 模式，便于状态管理和测试。
class DaLiuRenInputState {
  /// 年干支（如 "甲子"）
  final String? yearJiaZi;

  /// 月干支（如 "甲子"）
  final String? monthJiaZi;

  /// 日干支（如 "甲子"）
  final String? dayJiaZi;

  /// 时干支（如 "甲子"），可选
  final String? timeJiaZi;

  /// 月将名称（如 "登明"），可选
  final String? monthGeneral;

  /// 是否阴遁（true=阴遁, false=阳遁）
  final bool? isYinDun;

  /// 局数（1-12），可选
  final int? juNumber;

  /// 占卜问题
  final String? question;

  const DaLiuRenInputState({
    this.yearJiaZi,
    this.monthJiaZi,
    this.dayJiaZi,
    this.timeJiaZi,
    this.monthGeneral,
    this.isYinDun,
    this.juNumber,
    this.question,
  });

  /// 空的初始状态
  static const DaLiuRenInputState empty = DaLiuRenInputState();

  /// 验证错误（字段名 -> 错误信息）
  Map<String, String> get validationErrors {
    final errors = <String, String>{};

    if (yearJiaZi == null || yearJiaZi!.isEmpty) {
      errors['yearJiaZi'] = '请选择年干支';
    }
    if (monthJiaZi == null || monthJiaZi!.isEmpty) {
      errors['monthJiaZi'] = '请选择月干支';
    }
    if (dayJiaZi == null || dayJiaZi!.isEmpty) {
      errors['dayJiaZi'] = '请选择日干支';
    }
    if (isYinDun == null) {
      errors['isYinDun'] = '请选择阴阳遁';
    }
    if (monthGeneral == null || monthGeneral!.isEmpty) {
      errors['monthGeneral'] = '请选择月将';
    }
    // 时干支和局数至少要有一个
    if ((timeJiaZi == null || timeJiaZi!.isEmpty) && juNumber == null) {
      errors['timeOrJu'] = '时干支和局数至少填写一个';
    }

    return errors;
  }

  /// 是否可以提交（无验证错误）
  bool get isReadyToSubmit => validationErrors.isEmpty;

  /// 创建副本并更新指定字段
  DaLiuRenInputState copyWith({
    String? yearJiaZi,
    String? monthJiaZi,
    String? dayJiaZi,
    String? timeJiaZi,
    String? monthGeneral,
    bool? isYinDun,
    int? juNumber,
    String? question,
    bool clearTimeJiaZi = false,
    bool clearJuNumber = false,
    bool clearQuestion = false,
  }) {
    return DaLiuRenInputState(
      yearJiaZi: yearJiaZi ?? this.yearJiaZi,
      monthJiaZi: monthJiaZi ?? this.monthJiaZi,
      dayJiaZi: dayJiaZi ?? this.dayJiaZi,
      timeJiaZi: clearTimeJiaZi ? null : (timeJiaZi ?? this.timeJiaZi),
      monthGeneral: monthGeneral ?? this.monthGeneral,
      isYinDun: isYinDun ?? this.isYinDun,
      juNumber: clearJuNumber ? null : (juNumber ?? this.juNumber),
      question: clearQuestion ? null : (question ?? this.question),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DaLiuRenInputState &&
          runtimeType == other.runtimeType &&
          yearJiaZi == other.yearJiaZi &&
          monthJiaZi == other.monthJiaZi &&
          dayJiaZi == other.dayJiaZi &&
          timeJiaZi == other.timeJiaZi &&
          monthGeneral == other.monthGeneral &&
          isYinDun == other.isYinDun &&
          juNumber == other.juNumber &&
          question == other.question;

  @override
  int get hashCode =>
      yearJiaZi.hashCode ^
      monthJiaZi.hashCode ^
      dayJiaZi.hashCode ^
      timeJiaZi.hashCode ^
      monthGeneral.hashCode ^
      isYinDun.hashCode ^
      juNumber.hashCode ^
      question.hashCode;

  @override
  String toString() =>
      'DaLiuRenInputState(yearJiaZi: $yearJiaZi, monthJiaZi: $monthJiaZi, '
      'dayJiaZi: $dayJiaZi, timeJiaZi: $timeJiaZi, monthGeneral: $monthGeneral, '
      'isYinDun: $isYinDun, juNumber: $juNumber, question: $question)';
}
