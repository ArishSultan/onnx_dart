import 'dart:ffi' as ffi;

import 'package:onnx_platform_interface/onnx_platform_interface.dart'
    as platform_interface;

import '../memory/allocator.dart';

import '../../ffigen/bindings.dart';
import '../../ffigen/interface.dart';

import '../../base/native_resource.dart';

final class ModelMetadata extends NativeResource<OrtModelMetadata>
    with platform_interface.ModelMetadata {
  ModelMetadata(super.ref) {
    attachFinalizer(
      _finalizer ??= ffi.NativeFinalizer(ortApi.ReleaseModelMetadata.cast()),
    );
  }

  @override
  int get version {
    return _version ??= ortApi.modelMetadataGetVersion(ref);
  }

  @override
  String get domain {
    return _domain ??= ortApi.modelMetadataGetStringProperty(
      ref,
      Allocator.$default.ref,
      ortApi.ModelMetadataGetDomain.asFunction(isLeaf: true),
    );
  }

  @override
  String get producer {
    return _producer ??= ortApi.modelMetadataGetStringProperty(
      ref,
      Allocator.$default.ref,
      ortApi.ModelMetadataGetProducerName.asFunction(isLeaf: true),
    );
  }

  @override
  String get graphName {
    return _graphName ??= ortApi.modelMetadataGetStringProperty(
      ref,
      Allocator.$default.ref,
      ortApi.ModelMetadataGetGraphName.asFunction(isLeaf: true),
    );
  }

  @override
  String get graphDescription {
    return _graphDescription ??= ortApi.modelMetadataGetStringProperty(
      ref,
      Allocator.$default.ref,
      ortApi.ModelMetadataGetGraphDescription.asFunction(isLeaf: true),
    );
  }

  @override
  Map<String, String> get extraProperties {
    if (_extraProperties == null) {
      final allocatorPtr = Allocator.$default.ref;
      final customMapKeys = ortApi.modelMetadataGetCustomMetadataMapKeys(
        ref,
        allocatorPtr,
      );

      final extraProperties = <String, String>{};
      for (final key in customMapKeys) {
        extraProperties[key] = '';
      }

      _extraProperties = extraProperties;
    }

    return _extraProperties!;
  }

  // cache
  int? _version;
  String? _domain;
  String? _producer;
  String? _graphName;
  String? _graphDescription;
  Map<String, String>? _extraProperties;

  static ffi.NativeFinalizer? _finalizer;
}
