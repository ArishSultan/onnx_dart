import 'package:onnx_platform_interface/onnx_platform_interface.dart';

abstract mixin class TensorType implements BaseType {
  ///
  int get dimensionCount;

  ///
  List<int> get shape;

  //
  List<String> get symbolicShape;

  @override
  String toString() {
    // return '$dimensionCount';
    return 'TensorType(count: $dimensionCount, shape: $shape, symbolicShape: $symbolicShape)';
  }
}
