import 'package:common/enums.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DivinationFailure extends Failure {
  const DivinationFailure(super.message);
}

class NoParams {}

class DateTimeParams {
  final DateTime dateTime;
  final String? question;

  const DateTimeParams(this.dateTime, {this.question});
}

class ManualJuParams {
  final JiaZi dayJiaZi;
  final YinYang yinYangDun;
  final MonthGeneral monthGeneral;
  final DiZhi? timeZhi;
  final int? juNumber;
  final JiaZi? yearJiaZi;
  final JiaZi? monthJiaZi;

  const ManualJuParams(
    this.dayJiaZi,
    this.yinYangDun,
    this.monthGeneral, {
    this.timeZhi,
    this.juNumber,
    this.yearJiaZi,
    this.monthJiaZi,
  });
}
