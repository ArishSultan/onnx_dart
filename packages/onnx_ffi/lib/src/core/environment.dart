import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:onnx_platform_interface/onnx_platform_interface.dart';

import 'status.dart';

import '../../onnx_ffigen.dart';

import '../../ffigen/typedefs.dart';
import '../../ffigen/bindings.dart';

final class Environment extends Resource<OrtEnv> {
  // Finalizer hook for garbage collection.
  static final _finalizer = Finalizer(
    OnnxRuntime.instance.api.ReleaseEnv.asFunction<ReleaseEnv>(isLeaf: true),
  );

  const Environment._(super.reference);

  factory Environment({
    String logId = 'DartOnnxFFI',
    LoggingLevel loggingLevel = LoggingLevel.error,
  }) {
    final pointer = calloc<Pointer<OrtEnv>>();

    checkOrtStatus(
      OnnxRuntime.instance.api.CreateEnv.asFunction<CreateEnv>(isLeaf: true)(
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

    return Environment._(pointer.value).withFinalizer(_finalizer);
  }
}
