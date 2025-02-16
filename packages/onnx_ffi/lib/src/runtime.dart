import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:onnx_platform_interface/onnx_platform_interface.dart' as base;

import 'core/environment.dart';

import '../ffigen/bindings.dart';
import '../ffigen/typedefs.dart';

final class OnnxRuntime implements base.OnnxRuntime {
  static final instance = OnnxRuntime._();

  static late final OrtApi api;
  static late final OrtApiBase apiBase;

  OnnxRuntime._() {
    final bindings = OrtBindings(
      DynamicLibrary.open(
        '/Users/arish/Downloads/onnxruntime-osx-arm64-1.20.1/lib/libonnxruntime.1.20.1.dylib',
      ),
    );

    apiBase = bindings.OrtGetApiBase().ref;
    api =
        apiBase.GetApi.asFunction<GetApi>(isLeaf: true)(
          ORT_API_VERSION - 1,
        ).ref;
  }

  String? _version;

  String get version {
    return _version ??=
        apiBase.GetVersionString.asFunction<GetVersionString>(
          isLeaf: true,
        )().cast<Utf8>().toDartString();
  }

  Environment? _defaultEnv;

  Environment get defaultEnv {
    return _defaultEnv ??= Environment(loggingLevel: base.LoggingLevel.verbose);
  }
}
