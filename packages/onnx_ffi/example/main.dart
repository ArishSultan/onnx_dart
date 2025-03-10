import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:onnx_ffi/onnx_ffi.dart';

const sampleModelPath1 =
    '/Users/arish/Workspace/Professional/EmailAnalyzer/email_analyzer/assets/models/detection.onnx';

const sampleModelPath2 = '/Users/arish/Downloads/arcfaceresnet100-11-int8.onnx';

Future<void> main() async {
  OnnxRuntime.instance.initialize();

  // final sampleModel1 = Session(sampleModelPath1, SessionOptions());
  final sampleModel2 = Session(sampleModelPath2, SessionOptions());

  // print('Model 1');
  // print(sampleModel1.modelMetadata);
  // print(sampleModel1.inputs);
  // print(sampleModel1.outputs);
  // print('---------------------');
  // print('Model 2');
  // print(sampleModel2.modelMetadata);
  // print(sampleModel2.inputs);
  // print(sampleModel2.outputs);

  final file = File('sample.txt');
  if (!file.existsSync()) {
    file.createSync();
  }

  file.writeAsBytesSync(
    Float32List.fromList(
      List.generate(112 * 112 * 3, (_) => Random().nextDouble()),
    ).buffer.asUint8List(),
  );

  final data = file.readAsBytesSync().buffer.asFloat32List();

  final output = await sampleModel2.run({
    'data': Tensor<Float32List>.withData([1, 3, 112, 112], data),
  }, RunOptions());

  final fc1 = Tensor<Float32List>.fromBaseValue([1, 512], output['fc1']!);
  print(fc1[[0, 0]]);

  final output2 = sampleModel2.runSync({
    'data': Tensor<Float32List>.withData([1, 3, 112, 112], data),
  }, RunOptions());

  final fc12 = Tensor<Float32List>.fromBaseValue([1, 512], output2['fc1']!);
  print(fc12[[0, 0]]);
}

// 0.039995644241571426
// 0.039995644241571426
