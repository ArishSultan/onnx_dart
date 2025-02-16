import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'model_metadata.dart';
import 'session_options.dart';

import '../runtime.dart';
import '../helpers.dart';
import '../resource.dart';
import '../core/status.dart';
import '../core/environment.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/extensions.dart';

final class Session extends Resource<OrtSession> {
  Session._(super.reference);

  factory Session(
    String path,
    SessionOptions options, {
    Environment? environment,
  }) {
    environment ??= OnnxRuntime.instance.defaultEnv;

    final pointer = calloc<Pointer<OrtSession>>();
    checkOrtStatus(
      OnnxRuntime.api.createSession(
        environment.ref,
        path.toNativeUtf8().cast(),
        options.ref,
        pointer,
      ),
    );

    return Session._(pointer.$value).withFinalizer(_finalizer);
  }

  factory Session.fromBytes(
    Uint8List bytes,
    SessionOptions sessionOptions, {
    Environment? environment,
  }) {
    environment ??= OnnxRuntime.instance.defaultEnv;

    final pointer = calloc<Pointer<OrtSession>>();
    final modelBufferPtr = calloc.allocate<Uint8>(bytes.length);
    modelBufferPtr.asTypedList(bytes.length).setRange(0, bytes.length, bytes);

    checkOrtStatus(
      OnnxRuntime.api.createSessionFromArray(
        environment.ref,
        modelBufferPtr.cast(),
        bytes.length,
        sessionOptions.ref,
        pointer,
      ),
    );

    calloc.free(modelBufferPtr);

    return Session._(pointer.$value).withFinalizer(_finalizer);
  }

  ModelMetadata get modelMetadata {
    return _modelMetadata ??= ModelMetadata.fromSession(this);
  }

  // cache variables
  ModelMetadata? _modelMetadata;

  static final _finalizer = NativeFinalizer(
    OnnxRuntime.api.ReleaseSession.cast(),
  );
}
