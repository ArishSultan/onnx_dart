import '../type_info.dart';

///
abstract mixin class TensorInfo implements TypeInfo {
  ///
  List<int> get shape;

  ///
  List<String> get symbolicShape;

  @override
  String toString() {
    return 'TensorInfo(shape: $shape)';
  }
}
