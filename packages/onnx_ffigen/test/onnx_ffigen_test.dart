import 'package:onnx_ffigen/onnx_ffigen.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });
}
