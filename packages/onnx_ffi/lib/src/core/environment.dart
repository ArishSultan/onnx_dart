import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:onnx_platform_interface/onnx_platform_interface.dart' as base;

import 'status.dart';

import '../runtime.dart';
import '../resource.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/extensions.dart';

final class Environment extends Resource<OrtEnv> with base.Environment {
  Environment._(
    super.reference, {
    required this.logId,
    required this.loggingLevel,
  });

  final String logId;
  final base.LoggingLevel loggingLevel;

  factory Environment({
    String logId = '[onnxruntime_dart]',
    base.LoggingLevel loggingLevel = base.LoggingLevel.error,
  }) {
    final pointer = calloc<Pointer<OrtEnv>>();

    checkOrtStatus(
      OnnxRuntime.$.api.createEnv(
        switch (loggingLevel) {
          base.LoggingLevel.verbose => 0,
          base.LoggingLevel.info => 1,
          base.LoggingLevel.warning => 2,
          base.LoggingLevel.error => 3,
          base.LoggingLevel.fatal => 4,
        },
        logId.toNativeUtf8().cast(),
        pointer,
      ),
    );

    return Environment._(
      pointer.value,
      logId: logId,
      loggingLevel: loggingLevel,
    );
  }
}
