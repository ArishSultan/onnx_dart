import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../helpers.dart';
import '../runtime.dart';
import '../resource.dart';
import '../core/status.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/extensions.dart';

final class SessionOptions extends Resource<OrtSessionOptions> {
  const SessionOptions._(super.reference);

  factory SessionOptions() {
    final pointer = calloc<Pointer<OrtSessionOptions>>();
    checkOrtStatus(OnnxRuntime.$.api.createSessionOptions(pointer));

    return SessionOptions._(pointer.$value).withFinalizer(_finalizer);
  }

  static final _finalizer = NativeFinalizer(
    OnnxRuntime.$.api.ReleaseSessionOptions.cast(),
  );
}
