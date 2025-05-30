import 'dart:ffi';
import 'dart:typed_data';

import 'package:onnx_platform_interface/onnx_platform_interface.dart';

import 'value.dart';

import '../memory/allocator.dart';

import '../../ffigen/interface.dart';

final class Tensor<T extends TypedDataList> extends OnnxValue {
  Tensor.fromRef(super.ref, this.shape);

  final List<int> shape;

  factory Tensor(List<int> shape, {Allocator? allocator}) {
    final tensorRef = ortApi.createTensorAsOrtValue<T>(
      (allocator ?? Allocator.$default).ref,
      shape,
    );

    return Tensor.fromRef(tensorRef, shape);
  }

  factory Tensor.withData(List<int> shape, T data, {Allocator? allocator}) {
    final tensorRef = ortApi.createTensorWithDataAsOrtValue(
      (allocator ?? Allocator.$default).memoryInfo.ref,
      data,
      shape,
    );

    return Tensor.fromRef(tensorRef, shape);
  }

  T get data {
    final info = typeInfo.resolve() as TensorInfo;
    final typedList = ortApi.getTensorMutableData(ref, info.elementCount);

    return switch (info.type) {
      Float => typedList.buffer.asFloat32List(),
      Double => typedList.buffer.asFloat64List(),
      _ => throw UnimplementedError(),
    } as T;
  }

  num operator [](List<int> index) {
    if (index.length != shape.length) {
      throw Exception('Provided index should match the shape');
    }

    return ortApi.tensorAt<T>(ref, index)[0];
  }
}
