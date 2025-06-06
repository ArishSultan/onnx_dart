import 'dart:ffi';

import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    as platform_interface;

import 'tensor_type_info.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class TypeInfo extends NativeResource<OrtTypeInfo> {
  TypeInfo(super.ref);

  NativeResource<U> cast<U extends NativeType>() {
    return switch (U) {
          OrtTensorTypeAndShapeInfo => TensorInfo(
            ortApi.castToTensorTypeAndShapeInfo(ref),
          ),
          _ => throw UnimplementedError(),
        }
        as NativeResource<U>;
  }

  platform_interface.TypeInfo resolve() {
    final value = switch (onnxType) {
      ONNXType.ONNX_TYPE_UNKNOWN => throw UnimplementedError(),
      ONNXType.ONNX_TYPE_TENSOR => TensorInfo(
        cast<OrtTensorTypeAndShapeInfo>().ref,
      ),
      ONNXType.ONNX_TYPE_SEQUENCE => throw UnimplementedError(),
      ONNXType.ONNX_TYPE_MAP => throw UnimplementedError(),
      ONNXType.ONNX_TYPE_OPAQUE => throw UnimplementedError(),
      ONNXType.ONNX_TYPE_SPARSETENSOR => throw UnimplementedError(),
      ONNXType.ONNX_TYPE_OPTIONAL => throw UnimplementedError(),
    };

    return value;
  }

  ONNXType get onnxType {
    return _onnxType ??= ONNXType.fromValue(
      ortApi.getOnnxTypeFromTypeInfo(ref),
    );
  }

  ONNXType? _onnxType;

  String toString() {
    return resolve().toString();
  }
}
