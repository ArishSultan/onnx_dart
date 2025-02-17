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
import '../allocator/allocator.dart' as allocator;

import '../../ffigen/bindings.dart';
import '../../ffigen/typedefs.dart';
import '../../ffigen/extensions.dart';

final class Session extends Resource<OrtSession> {
  Session._(super.reference);

  factory Session(
    String path,
    SessionOptions options, {
    Environment? environment,
  }) {
    environment ??= OnnxRuntime.$.defaultEnv;

    final pointer = calloc<Pointer<OrtSession>>();
    checkOrtStatus(
      OnnxRuntime.$.api.createSession(
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
    environment ??= OnnxRuntime.$.defaultEnv;

    final pointer = calloc<Pointer<OrtSession>>();
    final modelBufferPtr = calloc.allocate<Uint8>(bytes.length);
    modelBufferPtr.asTypedList(bytes.length).setRange(0, bytes.length, bytes);

    checkOrtStatus(
      OnnxRuntime.$.api.createSessionFromArray(
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

  get inputs {
    if (_inputs == null) {
      final inputs = <String, dynamic>{};

      _readIo(
        OnnxRuntime.$.api.sessionGetInputCount,
        OnnxRuntime.$.api.sessionGetInputName,
        OnnxRuntime.$.api.sessionGetInputTypeInfo,
        inputs,
      );

      return inputs;

      // _inputs = inputs;
    }

    return _inputs!;
  }

  get outputs {
    if (_outputs == null) {
      final outputs = <String, dynamic>{};

      _readIo(
        OnnxRuntime.$.api.sessionGetOutputCount,
        OnnxRuntime.$.api.sessionGetOutputName,
        OnnxRuntime.$.api.sessionGetOutputTypeInfo,
        outputs,
      );

      _outputs = outputs;
    }

    return _outputs!;
  }

  // cache variables
  Map<String, dynamic>? _inputs;
  Map<String, dynamic>? _outputs;
  ModelMetadata? _modelMetadata;

  _readIo(
    SessionGetModelIOCount countFn,
    SessionGetModelIOName nameFn,
    SessionGetModelIoTypeInfo typeInfoFn,
    Map<String, dynamic> outputRef,
  ) {
    final countPtr = calloc<Size>();
    checkOrtStatus(countFn(ref, countPtr));

    final ioCount = countPtr.value;
    calloc.free(countPtr);

    final allocatorPtr = allocator.Allocator.withDefaultOptions().ref;
    for (var i = 0; i < ioCount; ++i) {
      final namePtr = calloc<Pointer<Char>>();
      nameFn(ref, i, allocatorPtr, namePtr);

      // final typeInfoPtr = calloc<Pointer<OrtTypeInfo>>();
      // typeInfoFn(ref, i, typeInfoPtr);

      final strPtr = namePtr.$value;
      // final typeInfo = typeInfoPtr.$value;

      outputRef[strPtr.cast<Utf8>().toDartString()] = null;

      calloc.free(strPtr);
    }
  }

  static final _finalizer = NativeFinalizer(
    OnnxRuntime.$.api.ReleaseSession.cast(),
  );
}
