import 'dart:ffi';

import 'package:onnx_platform_interface/onnx_platform_interface.dart' as base;

import 'helpers.dart';
import 'core/environment.dart';

import '../ffigen/bindings.dart';
import '../ffigen/typedefs.dart';

final class OnnxRuntime extends base.OnnxRuntime {
  OnnxRuntime._() {
    final bindings = OrtBindings(
      DynamicLibrary.open(
        '/Users/arish/Downloads/onnxruntime-osx-arm64-1.20.1/lib/libonnxruntime.1.20.1.dylib',
      ),
    );

    final apiVersion = ORT_API_VERSION - 1;

    apiBase = bindings.OrtGetApiBase().ref;
    api = apiBase.GetApi.asFunction<GetApi>(isLeaf: true)(apiVersion).ref;
  }

  late final OrtApi api;
  late final OrtApiBase apiBase;

  static final $ = OnnxRuntime._();

  String get version {
    return _version ??= stringFromPtrManaged(
      apiBase.GetVersionString.asFunction<GetVersionString>(isLeaf: true)(),
    );
  }

  Environment get defaultEnv {
    return _defaultEnv ??= Environment(loggingLevel: base.LoggingLevel.warning);
  }

  // cache variables
  String? _version;
  Environment? _defaultEnv;
}
