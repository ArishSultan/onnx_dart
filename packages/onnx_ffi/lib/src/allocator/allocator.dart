import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../runtime.dart';
import '../helpers.dart';
import '../resource.dart';
import '../core/status.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/extensions.dart';

final class Allocator extends Resource<OrtAllocator> {
  const Allocator._(super.ref);

  factory Allocator.withDefaultOptions() {
    if (_defaultAllocator == null) {
      final pointer = calloc<Pointer<OrtAllocator>>();
      checkOrtStatus(OnnxRuntime.api.getAllocatorWithDefaultOptions(pointer));

      _defaultAllocator = Allocator._(pointer.$value);
    }

    return _defaultAllocator!;
  }

  static Allocator? _defaultAllocator;

  static final _finalizer = NativeFinalizer(
    OnnxRuntime.api.ReleaseAllocator.cast(),
  );
}
