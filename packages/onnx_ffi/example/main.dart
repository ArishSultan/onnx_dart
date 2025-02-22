import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:onnx_ffi/ffigen/bindings.dart';
import 'package:onnx_ffi/ffigen/typedefs.dart';
import 'package:onnx_ffi/onnx_ffigen.dart';
import 'package:onnx_ffi/base/onnx_runtime.dart';
import 'package:onnx_ffi/src/session/session.dart';
import 'package:onnx_ffi/src/session/session_options.dart';

Future<void> main() async {
  OnnxRuntime.instance.initialize();

  final bytes =
      await File(
        // '/Users/arish/Workspace/Professional/EmailAnalyzer/email_analyzer/assets/models/detection.onnx',
        '/Users/arish/Downloads/arcfaceresnet100-11-int8.onnx',
      ).readAsBytes();
  Session session = Session.fromBytes(bytes, SessionOptions());
  // Session session2 = Session.fromBytes(bytes, SessionOptions());

  // print(OnnxRuntime.$.version);

  print(session.modelMetadata);
  print('inputs: ${session.inputs}');
  print('outputs: ${session.outputs}');
  // session.outputs;
}
