import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    show LoggingLevel;

import 'status.dart';

import '../runtime.dart';
import '../resource.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/extensions.dart';

final class Environment extends Resource<OrtEnv> {
  const Environment._(
    super.reference, {
    required this.logId,
    required this.loggingLevel,
  });

  final String logId;
  final LoggingLevel loggingLevel;

  factory Environment({
    String logId = 'DartOnnxFFI',
    LoggingLevel loggingLevel = LoggingLevel.error,
  }) {
    final pointer = calloc<Pointer<OrtEnv>>();

    checkOrtStatus(
      OnnxRuntime.api.createEnv(
        switch (loggingLevel) {
          LoggingLevel.verbose => 0,
          LoggingLevel.info => 1,
          LoggingLevel.warning => 2,
          LoggingLevel.error => 3,
          LoggingLevel.fatal => 4,
        },
        logId.toNativeUtf8().cast(),
        pointer,
      ),
    );

    return Environment._(
      pointer.value,
      logId: logId,
      loggingLevel: loggingLevel,
    ).withFinalizer(_finalizer);
  }

  @override
  String toString() {
    return 'Environment(logId: \'$logId\', loggingLevel: $loggingLevel)';
  }

  static final _finalizer = NativeFinalizer(OnnxRuntime.api.ReleaseEnv.cast());
}
