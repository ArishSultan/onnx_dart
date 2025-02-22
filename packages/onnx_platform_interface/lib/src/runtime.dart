import 'environment.dart';

abstract mixin class OnnxRuntime {
  void initialize([String? libraryPath]);

  String get version;

  Environment get defaultEnv;

  @override
  String toString() {
    return 'OnnxRuntime(version: $version, environment: $defaultEnv)';
  }
}
