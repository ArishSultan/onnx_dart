import 'dart:ffi';

import 'package:onnx_ffi/onnx_ffi.dart';

import '../../ffigen/bindings.dart';

import '../../base/native_resource.dart';
import '../../ffigen/interface.dart';

base class OnnxValue extends NativeResource<OrtValue> {
  OnnxValue(super.ref) {
    attachFinalizer(_finalizer ??= NativeFinalizer(ortApi.ReleaseValue.cast()));
  }

  TypeInfo get typeInfo => TypeInfo(ortApi.getValueTypeInfo(ref));

  static NativeFinalizer? _finalizer;
}
