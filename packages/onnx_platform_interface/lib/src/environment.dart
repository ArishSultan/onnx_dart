import 'logging_level.dart';

abstract mixin class Environment {
  String get logId;

  LoggingLevel get loggingLevel;

  @override
  String toString() {
    return 'Environment(logId: "$logId", loggingLevel: $loggingLevel)';
  }
}
