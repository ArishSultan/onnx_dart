import 'dart:ffi';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class RunOptions extends NativeResource<OrtRunOptions> {
  RunOptions._(super.reference) {
    attachFinalizer(
      _finalizer ??= NativeFinalizer(ortApi.ReleaseRunOptions.cast()),
    );
  }

  factory RunOptions() {
    return RunOptions._(ortApi.createRunOptions());
  }

  static NativeFinalizer? _finalizer;
}
