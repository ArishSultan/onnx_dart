import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:onnx_platform_interface/onnx_platform_interface.dart' as base;

import 'session.dart';

import '../helpers.dart';
import '../runtime.dart';
import '../resource.dart';

import '../core/status.dart';
import '../allocator/allocator.dart' as allocator;

import '../../ffigen/bindings.dart';
import '../../ffigen/typedefs.dart';
import '../../ffigen/extensions.dart';

final class ModelMetadata extends Resource<OrtModelMetadata>
    with base.ModelMetadata {
  ModelMetadata._(super.ref);

  factory ModelMetadata.fromSession(Session session) {
    final pointer = calloc<Pointer<OrtModelMetadata>>();
    checkOrtStatus(
      OnnxRuntime.$.api.sessionGetModelMetadata(session.ref, pointer),
    );

    return ModelMetadata._(pointer.$value);
  }

  @override
  int get version {
    if (_version == null) {
      final pointer = calloc<Int64>();
      checkOrtStatus(OnnxRuntime.$.api.modelMetadataGetVersion(ref, pointer));

      _version = pointer.value;
      calloc.free(pointer);
    }

    return _version!;
  }

  @override
  String get domain =>
      _domain ??= _getStringProperty(OnnxRuntime.$.api.modelMetadataGetDomain);

  @override
  String get producer =>
      _producer ??= _getStringProperty(
        OnnxRuntime.$.api.modelMetadataGetProducerName,
      );

  @override
  String get graphName =>
      _graphName ??= _getStringProperty(
        OnnxRuntime.$.api.modelMetadataGetGraphName,
      );

  @override
  String get graphDescription =>
      _graphDescription ??= _getStringProperty(
        OnnxRuntime.$.api.modelMetadataGetGraphDescription,
      );

  @override
  Map<String, String> get extraProperties {
    if (_extraProperties == null) {
      final allocatorPtr = allocator.Allocator.withDefaultOptions().ref;

      final numKeysPtr = calloc<Int64>();
      final keysArrayPtr = calloc<Pointer<Pointer<Char>>>();

      checkOrtStatus(
        OnnxRuntime.$.api.modelMetadataGetCustomMetadataMapKeys(
          ref,
          allocatorPtr,
          keysArrayPtr,
          numKeysPtr,
        ),
      );

      final extraProperties = <String, String>{};

      final numKeys = numKeysPtr.value;
      final keysArray = keysArrayPtr.$value;
      for (var i = 0; i < numKeys; ++i) {
        final keyPtr = keysArray[i];
        final valuePtr = calloc<Pointer<Char>>();

        OnnxRuntime.$.api.modelMetadataLookupCustomMetadataMap(
          ref,
          allocatorPtr,
          keyPtr,
          valuePtr,
        );

        final valueStr = valuePtr.$value;
        extraProperties[keyPtr.cast<Utf8>().toDartString()] =
            valueStr.cast<Utf8>().toDartString();

        calloc.free(keyPtr);
        calloc.free(valueStr);
      }

      calloc.free(keysArray);
      calloc.free(numKeysPtr);

      _extraProperties = extraProperties;
    }

    return _extraProperties!;
  }

  String _getStringProperty(ModelMetadataGetStringProperty fn) {
    final pointer = calloc<Pointer<Char>>();

    checkOrtStatus(
      fn(ref, allocator.Allocator.withDefaultOptions().ref, pointer),
    );

    final ptrValue = pointer.value;
    final strValue = ptrValue.cast<Utf8>().toDartString();

    calloc.free(ptrValue);

    return strValue;
  }

  // cache variables;
  int? _version;
  String? _domain;
  String? _producer;
  String? _graphName;
  String? _graphDescription;
  Map<String, String>? _extraProperties;

  static final _finalizer = NativeFinalizer(
    OnnxRuntime.$.api.ReleaseModelMetadata.cast(),
  );
}
