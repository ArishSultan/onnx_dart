import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:onnx_ffi/src/session/run_options.dart';
import 'package:onnx_ffi/src/values/value.dart';
import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    as platform_interface;

import 'model_metadata.dart';
import 'session_options.dart';

import '../environment.dart';
import '../memory/allocator.dart';
import '../type_info/type_info.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/typedefs.dart';
import '../../ffigen/interface.dart';

import '../../base/onnx_runtime.dart';
import '../../base/native_resource.dart';

final class Session extends NativeResource<OrtSession> {
  Session._(super.ref) {
    attachFinalizer(
      _finalizer ??= ffi.NativeFinalizer(ortApi.ReleaseSession.cast()),
    );
  }

  factory Session(
    String path,
    SessionOptions options, {
    Environment? environment,
  }) {
    return Session._(
      ortApi.createSession(
        path,
        options.ref,
        (environment ?? OnnxRuntime.instance.defaultEnv).ref,
      ),
    );
  }

  factory Session.fromBytes(
    Uint8List bytes,
    SessionOptions options, {
    Environment? environment,
  }) {
    return Session._(
      ortApi.createSessionFromBytes(
        bytes,
        options.ref,
        (environment ?? OnnxRuntime.instance.defaultEnv).ref,
      ),
    );
  }

  ModelMetadata get modelMetadata {
    return _modelMetadata ??= ModelMetadata(
      ortApi.sessionGetModelMetadata(ref),
    );
  }

  Map<String, platform_interface.TypeInfo> get inputs {
    return _inputs ??= _readIo(
      ortApi.SessionGetInputCount.asFunction<SessionGetModelIOCount>(
        isLeaf: true,
      ),
      ortApi.SessionGetInputName.asFunction<SessionGetModelIOName>(
        isLeaf: true,
      ),
      ortApi.SessionGetInputTypeInfo.asFunction<SessionGetModelIoTypeInfo>(
        isLeaf: true,
      ),
    );
  }

  Map<String, platform_interface.TypeInfo> get outputs {
    return _outputs ??= _readIo(
      ortApi.SessionGetOutputCount.asFunction<SessionGetModelIOCount>(
        isLeaf: true,
      ),
      ortApi.SessionGetOutputName.asFunction<SessionGetModelIOName>(
        isLeaf: true,
      ),
      ortApi.SessionGetOutputTypeInfo.asFunction<SessionGetModelIoTypeInfo>(
        isLeaf: true,
      ),
    );
  }

  Map<String, OnnxValue> runSync(
    Map<String, OnnxValue> inputs,
    RunOptions options,
  ) {
    final outputDict = <String, OnnxValue>{};
    final outputKeys = outputs.keys.toList();
    final output = ortApi.run(ref, options.ref, inputs, outputKeys);

    for (var i = 0; i < output.length; ++i) {
      outputDict[outputKeys[i]] = OnnxValue(output[i]);
    }

    return outputDict;
  }

  Future<Map<String, OnnxValue>> run(
    Map<String, OnnxValue> inputs,
    RunOptions options,
  ) async {
    final outputDict = <String, OnnxValue>{};
    final outputKeys = outputs.keys.toList();
    final output = await ortApi.runAsync(ref, options.ref, inputs, outputKeys);

    for (var i = 0; i < output.length; ++i) {
      outputDict[outputKeys[i]] = OnnxValue(output[i]);
    }

    return outputDict;
  }

  // cache
  ModelMetadata? _modelMetadata;
  Map<String, platform_interface.TypeInfo>? _inputs;
  Map<String, platform_interface.TypeInfo>? _outputs;

  Map<String, platform_interface.TypeInfo> _readIo(
    SessionGetModelIOCount countFn,
    SessionGetModelIOName nameFn,
    SessionGetModelIoTypeInfo typeInfoFn,
  ) {
    final allocatorPtr = Allocator.$default.ref;
    final count = ortApi.sessionGetIoCount(ref, countFn);

    final map = <String, platform_interface.TypeInfo>{};
    for (var i = 0; i < count; ++i) {
      map[ortApi.sessionGetIoName(ref, i, allocatorPtr, nameFn)] =
          TypeInfo(ortApi.sessionGetIoTypeInfo(ref, i, typeInfoFn)).resolve();
    }

    return map;
  }

  static ffi.NativeFinalizer? _finalizer;
}
