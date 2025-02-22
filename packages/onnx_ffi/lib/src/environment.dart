import 'dart:ffi';

import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    as platform_interface;

import '../ffigen/bindings.dart';
import '../ffigen/interface.dart';

import '../base/native_resource.dart';

///
final class Environment extends NativeResource<OrtEnv>
    with platform_interface.Environment {
  Environment._(this.logId, this.loggingLevel, super.ref) {
    attachFinalizer(_finalizer ??= NativeFinalizer(ortApi.ReleaseEnv.cast()));
  }

  ///
  final String logId;

  ///
  final platform_interface.LoggingLevel loggingLevel;

  ///
  factory Environment({
    String logId = '[onnxruntime_dart]',
    platform_interface.LoggingLevel loggingLevel =
        platform_interface.LoggingLevel.verbose,
  }) {
    return Environment._(
      logId,
      loggingLevel,
      ortApi.createEnv(logId, switch (loggingLevel) {
        platform_interface.LoggingLevel.verbose => 0,
        platform_interface.LoggingLevel.info => 1,
        platform_interface.LoggingLevel.warning => 2,
        platform_interface.LoggingLevel.error => 3,
        platform_interface.LoggingLevel.fatal => 4,
      }),
    );
  }

  static NativeFinalizer? _finalizer;
}
