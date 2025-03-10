import 'dart:ffi';

import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    as platform_interface;

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class TensorInfo extends NativeResource<OrtTensorTypeAndShapeInfo>
    with platform_interface.TensorInfo {
  TensorInfo(super.ref) {
    attachFinalizer(
      _finalizer ??= NativeFinalizer(
        ortApi.ReleaseTensorTypeAndShapeInfo.cast(),
      ),
    );
  }

  Type get type =>
      _type ??= switch (ortApi.getTensorElementType(ref)) {
        1 => Float,
        2 => Uint8,
        3 => Int8,
        4 => Uint16,
        5 => Int16,
        6 => Int32,
        7 => Int64,
        8 => String,
        9 => bool,
        11 => Double,
        12 => Uint32,
        13 => Uint64,
        // 0 => ONNX_TENSOR_ELEMENT_DATA_TYPE_UNDEFINED,
        // 10 => ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT16,
        // 14 => ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX64,
        // 15 => ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX128,
        // 16 => ONNX_TENSOR_ELEMENT_DATA_TYPE_BFLOAT16,
        // 17 => ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E4M3FN,
        // 18 => ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E4M3FNUZ,
        // 19 => ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E5M2,
        // 20 => ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E5M2FNUZ,
        // 21 => ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT4,
        // 22 => ONNX_TENSOR_ELEMENT_DATA_TYPE_INT4,
        _ => throw UnimplementedError(),
      };

  int get dimensions => _dimensions ??= ortApi.getTensorShapeCount(ref);

  @override
  List<int> get shape => _shape ??= ortApi.getTensorShape(ref, dimensions);

  @override
  List<String> get symbolicShape =>
      _symbolicShape ??= ortApi.getTensorSymbolicShape(ref, dimensions);

  // cache
  Type? _type;
  int? _dimensions;
  List<int>? _shape;
  List<String>? _symbolicShape;

  static NativeFinalizer? _finalizer;
}
