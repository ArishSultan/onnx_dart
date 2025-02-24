import 'dart:ffi';

import 'package:onnx_platform_interface/onnx_platform_interface.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

enum AllocatorType { invalid, device, arena }

enum MemoryType { $default, cpuInput, cpuOutput }

final class MemoryInfo extends NativeResource<OrtMemoryInfo> {
  MemoryInfo.managed(super.ref) : _managed = true;

  MemoryInfo(super.ref) : _managed = false {
    attachFinalizer(
      _finalizer ?? NativeFinalizer(ortApi.ReleaseMemoryInfo.cast()),
    );
  }

  final bool _managed;

  int get id => _id ??= ortApi.memoryInfoGetId(ref);

  String get name => _name ??= ortApi.memoryInfoGetName(ref, _managed);

  DeviceType get deviceType =>
      _deviceType ??= switch (ortApi.memoryInfoGetDeviceType(ref)) {
        0 => DeviceType.cpu,
        1 => DeviceType.gpu,
        2 => DeviceType.fpga,
        _ => throw UnimplementedError(),
      };

  MemoryType get memoryType =>
      _memType ??= switch (ortApi.memoryInfoGetMemType(ref)) {
        0 => MemoryType.$default,
        -2 => MemoryType.cpuInput,
        -1 => MemoryType.cpuOutput,
        _ => throw UnimplementedError(),
      };

  AllocatorType get type =>
      _type ??= switch (ortApi.memoryInfoGetType(ref)) {
        -1 => AllocatorType.invalid,
        0 => AllocatorType.device,
        1 => AllocatorType.arena,
        _ => throw UnimplementedError(),
      };

  // cache
  DeviceType? _deviceType;
  int? _id;
  String? _name;
  MemoryType? _memType;
  AllocatorType? _type;

  static NativeFinalizer? _finalizer;

  @override
  String toString() {
    return 'MemoryInfo('
        'device: $deviceType, id: $id, name: "$name", '
        'memType: $memoryType, type: $type'
        ')';
  }
}
