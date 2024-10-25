part of '../onnx_ffigen.dart';

void _handleStatus(Pointer<OrtStatus> status) {
  final code = _ortApi.GetErrorCode.asFunction<GetStatusCode>()(status);
  final message = _ortApi.GetErrorMessage.asFunction<GetStatusMessage>()(status)
      .cast<Utf8>()
      .toDartString();

  _ortApi.ReleaseStatus.asFunction<ReleaseStatus>()(status);
  if (code == 0) {
    // code == 0, indicates that the call was successful
    return;
  }

  // TODO(ArishSultan): Throw proper error message
  print('StatusCode: $code, $message');
}
