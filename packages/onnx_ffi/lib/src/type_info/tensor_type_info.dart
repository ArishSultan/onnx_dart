import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    show TensorType;

import '../helpers.dart';
import '../runtime.dart';
import '../resource.dart';

import '../core/status.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/extensions.dart';

final class TensorTypeAndShapeInfo extends Resource<OrtTensorTypeAndShapeInfo>
    with TensorType {
  TensorTypeAndShapeInfo._(super.ref);

  factory TensorTypeAndShapeInfo.fromTypeInfo(Pointer<OrtTypeInfo> typeInfo) {
    final pointer = calloc<Pointer<OrtTensorTypeAndShapeInfo>>();
    checkOrtStatus(
      OnnxRuntime.$.api.castTypeInfoToTensorInfo(typeInfo, pointer),
    );

    return TensorTypeAndShapeInfo._(pointer.value);
  }

  int get dimensionCount {
    if (_dimensionCount == null) {
      final pointer = calloc<Size>();
      OnnxRuntime.$.api.getDimensionsCount(ref, pointer);

      _dimensionCount = pointer.value;
      calloc.free(pointer);
    }

    return _dimensionCount!;
  }

  @override
  List<int> get shape {
    if (_shape == null) {
      final pointer = calloc<Int64>();
      checkOrtStatus(
        OnnxRuntime.$.api.getDimensions(ref, pointer, dimensionCount),
      );

      // calloc.free(pointer);
      _shape = pointer.asTypedList(dimensionCount).toList();
      // _shape = [];
    }

    return _shape!;
  }

  List<String> get symbolicShape {
    return [];
    if (_symbolicShape == null) {
      final symbolicShape = <String>[];

      final dimCount = dimensionCount;
      final pointer = calloc<Pointer<Char>>();

      OnnxRuntime.$.api.getSymbolicDimensions(ref, pointer, dimCount);
      for (var i = 0; i < dimCount; ++i) {
        symbolicShape.add(stringFromPtrManaged(pointer[i]));
      }

      _symbolicShape = [];
      calloc.free(pointer);
    }

    return _symbolicShape!;
  }

  // cache variables
  int? _dimensionCount;
  List<int>? _shape;
  List<String>? _symbolicShape;
}
