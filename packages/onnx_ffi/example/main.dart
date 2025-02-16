import 'package:onnx_ffi/onnx_ffigen.dart';
import 'package:onnx_ffi/src/runtime.dart';
import 'package:onnx_ffi/src/session/session.dart';
import 'package:onnx_ffi/src/session/session_options.dart';

void main() {
  Session session = Session(
    // '/Users/arish/Workspace/Professional/EmailAnalyzer/email_analyzer/assets/models/detection.onnx',
    '/Users/arish/Downloads/arcfaceresnet100-11-int8.onnx',
    SessionOptions(),
  );

  print(session.modelMetadata);
}

// libonnxruntime.1.20.0.dylib
