import 'dart:ffi';

import 'tensor_type_info.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class TypeInfo extends NativeResource<OrtTypeInfo> {
  TypeInfo(super.ref) {
    attachFinalizer(
      _finalizer ??= NativeFinalizer(ortApi.ReleaseTypeInfo.cast()),
    );
  }

  NativeResource<U> cast<U extends NativeType>() {
    final value = switch (U) {
      OrtTensorTypeAndShapeInfo => TensorInfo(
        ortApi.castToTensorTypeAndShapeInfo(ref),
      ),
      _ => throw UnimplementedError(),
    };

    return value as NativeResource<U>;
  }

  ONNXType get onnxType {
    return _onnxType ??= ONNXType.fromValue(
      ortApi.getOnnxTypeFromTypeInfo(ref),
    );
  }

  ONNXType? _onnxType;

  static NativeFinalizer? _finalizer;
}
