import 'dart:io';

import 'package:onnx_ffi/onnx_ffigen.dart';
import 'package:onnx_ffi/src/runtime.dart';
import 'package:onnx_ffi/src/session/session.dart';
import 'package:onnx_ffi/src/session/session_options.dart';

Future<void> main() async {
  final bytes =
      await File(
        // '/Users/arish/Workspace/Professional/EmailAnalyzer/email_analyzer/assets/models/detection.onnx',
        '/Users/arish/Downloads/arcfaceresnet100-11-int8.onnx',
      ).readAsBytes();
  Session session = Session.fromBytes(bytes, SessionOptions());

  print(OnnxRuntime.$.version);

  print(session.inputs);
  session.outputs;
}

// libonnxruntime.1.20.0.dylib
