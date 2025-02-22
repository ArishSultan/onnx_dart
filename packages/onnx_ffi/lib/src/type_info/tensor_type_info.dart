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

  int get dimensions {
    return _dimensions ??= ortApi.getTensorShapeCount(ref);
  }

  @override
  List<int> get shape {
    return _shape ??= ortApi.getTensorShape(ref, dimensions);
  }

  @override
  List<String> get symbolicShape {
    return _symbolicShape ??= ortApi.getTensorSymbolicShape(ref, dimensions);
  }

  // cache
  int? _dimensions;
  List<int>? _shape;
  List<String>? _symbolicShape;

  static NativeFinalizer? _finalizer;
}
