import 'logging_level.dart';

abstract mixin class Environment {
  String get logId;

  LoggingLevel get loggingLevel;
}
