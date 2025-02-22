import 'dart:ffi';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class SessionOptions extends NativeResource<OrtSessionOptions> {
  SessionOptions._(super.reference) {
    attachFinalizer(
      _finalizer ??= NativeFinalizer(ortApi.ReleaseSessionOptions.cast()),
    );
  }

  factory SessionOptions() {
    return SessionOptions._(ortApi.createSessionOptions());
  }

  static NativeFinalizer? _finalizer;
}
