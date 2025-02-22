// import 'dart:ffi';
//
// import 'package:ffi/ffi.dart';
// import 'package:onnx_platform_interface/onnx_platform_interface.dart' as base;
//
// import 'status.dart';
//
// import '../../base/onnx_runtime.dart';
// import '../type_info/tensor_type_info.dart';
//
// import '../../ffigen/bindings.dart';
// import '../../ffigen/extensions.dart';
//
// base.BaseTypeInfo resolveTypeInfo(Pointer<OrtTypeInfo> typeInfo) {
//   final onnxTypePtr = calloc<UnsignedInt>();
//   checkOrtStatus(
//     OnnxRuntime.$.api.getOnnxTypeFromTypeInfo(typeInfo, onnxTypePtr),
//   );
//
//   final value = switch (onnxTypePtr.value) {
//     0 => throw Exception('Unknown type detected here, Not supported yet'),
//     1 => TensorInfo.fromTypeInfo(typeInfo),
//     2 => throw UnimplementedError(),
//     3 => throw UnimplementedError(),
//     4 => throw UnimplementedError(),
//     5 => throw UnimplementedError(),
//     6 => throw UnimplementedError(),
//     _ => throw UnimplementedError(),
//   };
//
//   // calloc.free(onnxTypePtr);
//   // TODO: Do not release from base class
//   // OnnxRuntime.$.api.releaseTypeInfo(typeInfo);
//
//   return value;
// }
