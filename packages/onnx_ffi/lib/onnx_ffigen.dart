library;

import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'ffigen/bindings.dart';
import 'src/internal/ffi_object.dart';

part 'src/environment.dart';

part 'src/logging_level.dart';

late OrtFFI _ortFFI;
late OrtApi _ortApi;

void main() {
  final lib = DynamicLibrary.open(
    '/Users/arish/Downloads/onnxruntime-osx-arm64-1.19.2/lib/libonnxruntime.1.19.2.dylib',
  );

  _ortFFI = OrtFFI(lib);

  _ortApi = _ortFFI.OrtGetApiBase()
      .ref
      .GetApi
      .asFunction<Pointer<OrtApi> Function(int)>(isLeaf: true)(19)
      .ref;
  // final version = _ortFFI.OrtGetApiBase()
  //     .ref
  //     .GetVersionString
  //     .asFunction<Pointer<Char> Function()>(isLeaf: true)()
  //     .cast<Utf8>()
  //     .toDartString();
  //
}
