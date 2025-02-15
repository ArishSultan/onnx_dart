import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../../onnx_ffigen.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/typedefs.dart';

void checkOrtStatus(Pointer<OrtStatus> status) {
  final code = OnnxRuntime.instance.api.GetErrorCode.asFunction<GetStatusCode>(
    isLeaf: true,
  )(status);

  final message =
      OnnxRuntime.instance.api.GetErrorMessage
          .asFunction<GetStatusMessage>(isLeaf: true)(status)
          .cast<Utf8>()
          .toDartString;

  // Success case
  if (code == 0) {
    return;
  }

  // TODO: Throw proper error as defined in platform interface.
  print('OrtStatus: $code => $message');
}
