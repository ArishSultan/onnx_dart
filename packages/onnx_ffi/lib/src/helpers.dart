import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:onnx_ffi/ffigen/extensions.dart';
import 'package:onnx_ffi/src/runtime.dart';

import 'core/status.dart';
import 'allocator/allocator.dart' as alloc;

extension OnnxPointerPointerExt<T extends NativeType> on Pointer<Pointer<T>> {
  Pointer<T> get $value {
    final freedValue = value;
    calloc.free(this);

    return freedValue;
  }
}

String stringFromPtrManaged(Pointer<Char> pointer) {
  return pointer.cast<Utf8>().toDartString();
}

String stringFromPtrOnnxAllocated(
  Pointer<Char> pointer, [
  alloc.Allocator? allocator,
]) {
  final value = pointer.cast<Utf8>().toDartString();
  checkOrtStatus(
    OnnxRuntime.$.api.allocatorFree(
      (allocator ?? alloc.Allocator.withDefaultOptions()).ref,
      pointer.cast(),
    ),
  );

  return value;
}

String stringFromPtr(Pointer<Char> pointer) {
  final value = pointer.cast<Utf8>().toDartString();
  calloc.free(pointer);

  return value;
}
