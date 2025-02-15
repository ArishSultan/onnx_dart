// import 'package:onnx_ffi/ffigen/bindings.dart';

import '../ffigen/bindings.dart';

final class OnnxRuntime {
  static late final OnnxRuntime instance;

  late final OrtApi api;
}

// part of '../onnx_ffigen.dart';
//
// ///
// abstract final class OnnxRuntime {
//   ///
//   static late final OrtBindings _ortBindings;
//
//   ///
//   static late final OrtApi _api;
//
//   ///
//   static late final OrtApiBase _apiBase;
//
//   ///
//   /// API version is hardcoded to `20`, maybe in future it will be a variable.
//   static final int apiVersion = 20;
//
//   ///
//   static late final String version;
//
//   ///
//   static void initialize(String pathToLib) {
//     _ortBindings = OrtBindings(DynamicLibrary.open(pathToLib));
//
//     _apiBase = _ortBindings.OrtGetApiBase().ref;
//     _api = _apiBase.GetApi.asFunction<GetApi>(isLeaf: true)(20).ref;
//
//     version =
//         _apiBase.GetVersionString.asFunction<GetVersionString>(
//           isLeaf: true,
//         )().cast<Utf8>().toDartString();
//   }
// }
