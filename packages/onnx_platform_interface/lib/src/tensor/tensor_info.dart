import '../type_info.dart';

///
abstract mixin class TensorInfo implements TypeInfo {
  ///
  Type get type;

  ///
  List<int> get shape;

  ///
  int get elementCount;

  ///
  List<String> get symbolicShape;

  @override
  String toString() {
    return 'TensorInfo(type: $type, elements: $elementCount, shape: $shape)';
  }
}
