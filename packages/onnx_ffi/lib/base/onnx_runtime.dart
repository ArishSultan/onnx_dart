import 'dart:ffi';

import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    as platform_interface;

import '../ffigen/bindings.dart';
import '../ffigen/interface.dart';

import '../src/environment.dart';

///
final class OnnxRuntime extends platform_interface.OnnxRuntime {
  ///
  OnnxRuntime._();

  ///
  static late OnnxRuntime instance = OnnxRuntime._();

  ///
  void initialize([String? libraryPath]) {
    if (libraryPath == null) {
      // TODO: try to find library in different locations based on the platform
      libraryPath =
          '/Users/arish/Downloads'
          '/onnxruntime-osx-arm64-1.20.1/lib/libonnxruntime.1.20.1.dylib';
    }

    final bindings = OrtBindings(DynamicLibrary.open(libraryPath));
    ortApiBase = bindings.OrtGetApiBase().ref;
    ortApi = ortApiBase.getApi();
  }

  ///
  @override
  String get version => _version ??= ortApiBase.getVersion();

  ///
  @override
  Environment get defaultEnv =>
      _defaultEnv ??= Environment(
        loggingLevel: platform_interface.LoggingLevel.warning,
      );

  // cache variables
  String? _version;
  Environment? _defaultEnv;
}
