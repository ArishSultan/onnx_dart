import 'dart:ffi' as ffi;
import 'dart:typed_data';

import '../memory/allocator.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class Tensor<T extends TypedDataList> extends NativeResource<OrtValue> {
  Tensor._(super.ref) {
    attachFinalizer(
      _finalizer ??= ffi.NativeFinalizer(ortApi.ReleaseValue.cast()),
    );
  }

  factory Tensor(List<int> shape, {Allocator? allocator}) {
    return Tensor._(
      ortApi.createTensorAsOrtValue(
        (allocator ?? Allocator.$default).ref,
        shape,
        _resolveType(T),
      ),
    );
  }

  factory Tensor.withData(List<int> shape, T data, {Allocator? allocator}) {
    return Tensor._(
      ortApi.createTensorWithDataAsOrtValue(
        (allocator ?? Allocator.$default).ref,
        shape,
        _resolveType(T),
      ),
    );
  }

  static _resolveType(Type type) {
    return switch (type) {
      Uint8List =>
        ONNXTensorElementDataType.ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT8,
      _ => UnimplementedError(),
    };
  }

  static ffi.NativeFinalizer? _finalizer;
}
