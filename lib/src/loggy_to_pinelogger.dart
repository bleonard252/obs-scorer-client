import 'package:loggy/loggy.dart';
import 'package:pinelogger/pinelogger.dart';

class LoggyToPinelogger extends LoggyPrinter {
  final Pinelogger parent;
  LoggyToPinelogger(this.parent);
  @override
  void onLog(LogRecord record) {
    //pinelogger.name = record.loggerName;
    late final Severity _priorityLevel;
    switch (record.level) {
      case LogLevel.debug:
        _priorityLevel = Severity.debug;
        break;
      case LogLevel.info:
        _priorityLevel = Severity.info;
        break;
      case LogLevel.warning:
        _priorityLevel = Severity.warning;
        break;
      case LogLevel.error:
        _priorityLevel = Severity.error;
        break;
      default:
        Severity(record.level.priority, record.level.name);
        break;
    }
    parent.child(record.loggerName).log(
      record.message,
      severity: _priorityLevel,
      //extraData: record.extraData,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }

}