import '../type_info.dart';

///
abstract mixin class TensorInfo implements TypeInfo {
  ///
  Type get type;

  ///
  List<int> get shape;

  ///
  List<String> get symbolicShape;

  @override
  String toString() {
    return 'TensorInfo(type: $type, shape: $shape)';
  }
}
