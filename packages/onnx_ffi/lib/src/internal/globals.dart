part of '../../onnx_ffigen.dart';

late final OrtFFI _ortFFI;
late final OrtApiBase _ortApiBase;

late final OrtApi _ortApi;

void _setupGlobals(DynamicLibrary library, int version) {
  _ortFFI = OrtFFI(library);
  _ortApiBase = _ortFFI.OrtGetApiBase().ref;
  _ortApi = _ortApiBase.GetApi.asFunction<GetApi>(isLeaf: true)(version).ref;
}
