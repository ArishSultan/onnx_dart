import 'dart:ffi' as ffi;
import 'dart:typed_data';

import '../memory/allocator.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class Tensor<T extends TypedDataList> extends NativeResource<OrtValue> {
  Tensor._(super.ref, this.shape, this._data) {
    attachFinalizer(
      _finalizer ??= ffi.NativeFinalizer(ortApi.ReleaseValue.cast()),
    );
  }

  final T _data;
  final List<int> shape;

  factory Tensor(List<int> shape, {Allocator? allocator}) {
    final tensorRef = ortApi.createTensorAsOrtValue<T>(
      (allocator ?? Allocator.$default).ref,
      shape,
    );

    return Tensor._(tensorRef, shape, [] as T);
  }

  factory Tensor.withData(List<int> shape, T data, {Allocator? allocator}) {
    final tensorRef = ortApi.createTensorWithDataAsOrtValue(
      (allocator ?? Allocator.$default).memoryInfo.ref,
      data,
      shape,
    );

    return Tensor._(tensorRef, shape, data);
  }

  num operator [](List<int> index) {
    if (index.length != shape.length) {
      throw Exception('Provided index should match the shape');
    }

    return ortApi.tensorAt<T>(ref, index)[0];
  }

  static ffi.NativeFinalizer? _finalizer;
}
