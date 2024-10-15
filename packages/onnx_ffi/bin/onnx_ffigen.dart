import 'dart:ffi';
import 'package:onnx_ffi/onnx_ffigen.dart';
import 'package:onnx_ffi/onnxruntime_bindings.dart';

void main() {
  // Load the ONNX Runtime shared library.
  final DynamicLibrary ortLib = DynamicLibrary.open('C:/Users/abdul/Downloads/onnxruntime-training-win-x64-1.19.2/lib/onnxruntime.dll');

  // Initialize the bindings with the loaded library.
  final onnx = NativeLibrary(ortLib);

  // Example: Get the API Base
  final apiBase = onnx.OrtGetApiBase();

  // Get the version of ONNX Runtime
  final api = apiBase.ref.GetApi;
  print("ONNX Runtime Version: ${api.address}");
}
