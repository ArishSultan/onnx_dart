import 'dart:typed_data';

import 'value.dart';

import '../memory/allocator.dart';

import '../../ffigen/interface.dart';

final class Tensor<T extends TypedDataList> extends OnnxValue {
  Tensor._(super.ref, this.shape);

  final List<int> shape;

  factory Tensor(List<int> shape, {Allocator? allocator}) {
    final tensorRef = ortApi.createTensorAsOrtValue<T>(
      (allocator ?? Allocator.$default).ref,
      shape,
    );

    return Tensor._(tensorRef, shape);
  }

  factory Tensor.withData(List<int> shape, T data, {Allocator? allocator}) {
    final tensorRef = ortApi.createTensorWithDataAsOrtValue(
      (allocator ?? Allocator.$default).memoryInfo.ref,
      data,
      shape,
    );

    return Tensor._(tensorRef, shape);
  }

  factory Tensor.fromBaseValue(List<int> shape, OnnxValue value) {
    return Tensor._(value.ref, shape);
  }

  num operator [](List<int> index) {
    if (index.length != shape.length) {
      throw Exception('Provided index should match the shape');
    }

    return ortApi.tensorAt<T>(ref, index)[0];
  }
}
