import 'environment.dart';

abstract mixin class OnnxRuntime {
  String get version;

  Environment get defaultEnv;

  @override
  String toString() {
    return 'OnnxRuntime(version: $version, environment: $defaultEnv)';
  }
}
