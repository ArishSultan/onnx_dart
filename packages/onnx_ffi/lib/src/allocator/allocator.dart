import 'dart:ffi';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class Allocator extends NativeResource<OrtAllocator> {
  Allocator._default(super.ref);

  Allocator._(super.ref) {
    attachFinalizer(
      _finalizer ?? NativeFinalizer(ortApi.ReleaseAllocator.cast()),
    );
  }

  factory Allocator.$default() {
    return _defaultAllocator ??= Allocator._default(
      ortApi.getAllocatorWithDefaultOptions(),
    );
  }

  static Allocator? _defaultAllocator;

  static NativeFinalizer? _finalizer;
}
