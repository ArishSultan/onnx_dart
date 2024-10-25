part of '../onnx_ffigen.dart';

final class Environment extends NativeObject<OrtEnv> {
  const Environment._(super.reference);

  factory Environment({
    String logId = 'DartOnnxFFI',
    LoggingLevel loggingLevel = LoggingLevel.error,
  }) {
    final pointer = calloc<Pointer<OrtEnv>>();
    final resolvedLoggingLevel = switch (loggingLevel) {
      LoggingLevel.verbose => 0,
      LoggingLevel.info => 1,
      LoggingLevel.warning => 2,
      LoggingLevel.error => 3,
      LoggingLevel.fatal => 4,
    };

    // TODO(ArishSultan): Add mechanism to create env with threading options
    _handleStatus(
      _ortApi.CreateEnv.asFunction<CreateEnv>(isLeaf: true)(
        resolvedLoggingLevel,
        logId.toNativeUtf8().cast<Char>(),
        pointer,
      ),
    );

    return Environment._(pointer.value).withFinalizer(_finalizer);
  }

  static final Finalizer<Pointer<OrtEnv>> _finalizer = Finalizer(
    _ortApi.ReleaseEnv.asFunction<ReleaseEnv>(isLeaf: true),
  );
}
