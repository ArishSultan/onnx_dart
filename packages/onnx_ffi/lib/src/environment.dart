part of '../onnx_ffigen.dart';

final class Environment extends FFIObject<OrtEnv> {
  const Environment._(super.reference);

  factory Environment({
    String logId = 'DartOnnxFFI',
    LoggingLevel loggingLevel = LoggingLevel.error,
  }) {
    final pointer = calloc<Pointer<OrtEnv>>();
    final resolvedLoggingLevel = switch (loggingLevel) {
      LoggingLevel.verbose => OrtLoggingLevel.ORT_LOGGING_LEVEL_VERBOSE.value,
      LoggingLevel.info => OrtLoggingLevel.ORT_LOGGING_LEVEL_INFO.value,
      LoggingLevel.warning => OrtLoggingLevel.ORT_LOGGING_LEVEL_WARNING.value,
      LoggingLevel.error => OrtLoggingLevel.ORT_LOGGING_LEVEL_ERROR.value,
      LoggingLevel.fatal => OrtLoggingLevel.ORT_LOGGING_LEVEL_FATAL.value,
    };

    // TODO(ArishSultan): Add mechanism to create env with threading options
    _ortApi.CreateEnv.asFunction<_CreateEnv>(isLeaf: true)(
      resolvedLoggingLevel,
      logId.toNativeUtf8().cast<Char>(),
      pointer,
    );

    return FFIObject.withFinalizer(Environment._(pointer.value), _finalizer);
  }

  static final Finalizer<Pointer<OrtEnv>> _finalizer = Finalizer(
    _ortApi.ReleaseEnv.asFunction<_ReleaseEnv>(isLeaf: true),
  );
}

typedef _CreateEnv = Pointer<OrtStatus> Function(
  int logSeverityLevel,
  Pointer<Char> logId,
  Pointer<Pointer<OrtEnv>> out,
);

typedef _ReleaseEnv = void Function(Pointer<OrtEnv> out);
