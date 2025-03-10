import 'dart:ffi';

import '../../ffigen/bindings.dart';

import '../../base/native_resource.dart';
import '../../ffigen/interface.dart';

base class OnnxValue extends NativeResource<OrtValue> {
  OnnxValue(super.ref) {
    // attachFinalizer(_finalizer ??= NativeFinalizer(ortApi.ReleaseValue.cast()));
  }

  static NativeFinalizer? _finalizer;
}
