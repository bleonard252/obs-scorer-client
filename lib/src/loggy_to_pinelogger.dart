import 'package:loggy/loggy.dart';
import 'package:pinelogger/pinelogger.dart';

class LoggyToPinelogger extends LoggyPrinter {
  final Pinelogger parent;
  LoggyToPinelogger(this.parent);
  @override
  void onLog(LogRecord record) {
    //pinelogger.name = record.loggerName;
    parent.child(record.loggerName).log(
      record.message,
      severity: Severity(record.level.priority, record.level.name),
      //extraData: record.extraData,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }

}