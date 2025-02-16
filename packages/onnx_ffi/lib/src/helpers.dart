import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension OnnxPointerPointerExt<T extends NativeType> on Pointer<Pointer<T>> {
  Pointer<T> get $value {
    final freedValue = value;
    calloc.free(this);

    return freedValue;
  }
}
