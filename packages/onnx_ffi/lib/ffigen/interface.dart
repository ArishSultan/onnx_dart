import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'bindings.dart';
import 'typedefs.dart' as types;

late OrtApi ortApi;
late OrtApiBase ortApiBase;

extension OrtApiBaseDartInterface on OrtApiBase {
  OrtApi getApi() {
    return GetApi.asFunction<types.GetApi>(isLeaf: true)(
      ORT_API_VERSION - 1,
    ).ref;
  }

  String getVersion() {
    return GetVersionString.asFunction<types.GetVersionString>(
      isLeaf: true,
    )().cast<Utf8>().toDartString();
  }
}

extension OrtApiDartInterface on OrtApi {
  // [OrtStatus] related methods,
  // TODO: Optimize these functions by caching the values;
  int getErrorCode(Pointer<OrtStatus> statusPtr) {
    return GetErrorCode.asFunction<types.GetErrorCode>(isLeaf: true)(statusPtr);
  }

  String getErrorMessage(Pointer<OrtStatus> statusPtr) {
    return GetErrorMessage.asFunction<types.GetErrorMessage>(isLeaf: true)(
      statusPtr,
    ).cast<Utf8>().toDartString();
  }

  void releaseStatus(Pointer<OrtStatus> statusPtr) {
    return ReleaseStatus.asFunction<types.ReleaseStatus>(isLeaf: true)(
      statusPtr,
    );
  }

  // [OrtAllocator] related methods
  Pointer<OrtAllocator> getAllocatorWithDefaultOptions() {
    final pointer = malloc<Pointer<OrtAllocator>>();

    _checkStatus(
      GetAllocatorWithDefaultOptions.asFunction<
        types.GetAllocatorWithDefaultOptions
      >(isLeaf: true)(pointer),
    );

    return pointer.dispose();
  }

  void allocatorFree(
    Pointer<OrtAllocator> allocatorPtr,
    Pointer<Void> resourcePtr,
  ) {
    _checkStatus(
      AllocatorFree.asFunction<types.AllocatorFree>(isLeaf: true)(
        allocatorPtr,
        resourcePtr,
      ),
    );
  }

  // [OrtEnv] related methods
  Pointer<OrtEnv> createEnv(String id, int loggingLevel) {
    final pointer = malloc<Pointer<OrtEnv>>();
    final logIdPtr = id.toNativeUtf8().cast<Char>();

    _checkStatus(
      CreateEnv.asFunction<types.CreateEnv>(isLeaf: true)(
        loggingLevel,
        logIdPtr,
        pointer,
      ),
    );

    malloc.free(logIdPtr);

    return pointer.dispose();
  }

  // [OrtSessionOptions] related methods
  Pointer<OrtSessionOptions> createSessionOptions() {
    final pointer = malloc<Pointer<OrtSessionOptions>>();

    _checkStatus(
      CreateSessionOptions.asFunction<types.CreateSessionOptions>(isLeaf: true)(
        pointer,
      ),
    );

    return pointer.dispose();
  }

  // [OrtSession] related methods
  Pointer<OrtSession> createSession(
    String modelPath,
    Pointer<OrtSessionOptions> sessionOptionsPtr,
    Pointer<OrtEnv> environmentPtr,
  ) {
    final pointer = malloc<Pointer<OrtSession>>();
    final modelPathPtr = modelPath.toNativeUtf8().cast<Char>();

    _checkStatus(
      CreateSession.asFunction<types.CreateSession>(isLeaf: true)(
        environmentPtr,
        modelPathPtr,
        sessionOptionsPtr,
        pointer,
      ),
    );

    malloc.free(modelPathPtr);

    return pointer.dispose();
  }

  Pointer<OrtSession> createSessionFromBytes(
    Uint8List modelBytes,
    Pointer<OrtSessionOptions> sessionOptions,
    Pointer<OrtEnv> environment,
  ) {
    final pointer = malloc<Pointer<OrtSession>>();
    final modelBufferPtr = malloc<Uint8>(modelBytes.length);

    modelBufferPtr
        .asTypedList(modelBytes.length)
        .setRange(0, modelBytes.length, modelBytes);

    _checkStatus(
      CreateSessionFromArray.asFunction<types.CreateSessionFromArray>(
        isLeaf: true,
      )(
        environment,
        modelBufferPtr.cast(),
        modelBytes.length,
        sessionOptions,
        pointer,
      ),
    );

    malloc.free(modelBufferPtr);

    return pointer.dispose();
  }

  Pointer<OrtModelMetadata> sessionGetModelMetadata(
    Pointer<OrtSession> session,
  ) {
    final pointer = malloc<Pointer<OrtModelMetadata>>();

    _checkStatus(
      SessionGetModelMetadata.asFunction<types.SessionGetModelMetadata>(
        isLeaf: true,
      )(session, pointer),
    );

    return pointer.dispose();
  }

  int sessionGetIoCount(
    Pointer<OrtSession> sessionPtr,
    types.SessionGetModelIOCount fn,
  ) {
    final pointer = malloc<Size>();
    _checkStatus(fn(sessionPtr, pointer));

    final count = pointer.value;
    malloc.free(pointer);

    return count;
  }

  String sessionGetIoName(
    Pointer<OrtSession> sessionPtr,
    int index,
    Pointer<OrtAllocator> allocatorPtr,
    types.SessionGetModelIOName fn,
  ) {
    final pointer = malloc<Pointer<Char>>();
    _checkStatus(fn(sessionPtr, index, allocatorPtr, pointer));

    final strPtr = pointer.value;
    final strValue = strPtr.cast<Utf8>().toDartString();

    allocatorFree(allocatorPtr, strPtr.cast());
    malloc.free(pointer);

    return strValue;
  }

  Pointer<OrtTypeInfo> sessionGetIoTypeInfo(
    Pointer<OrtSession> sessionPtr,
    int index,
    types.SessionGetModelIoTypeInfo fn,
  ) {
    final pointer = malloc<Pointer<OrtTypeInfo>>();
    _checkStatus(fn(sessionPtr, index, pointer));

    final typeInfoPtr = pointer.value;
    malloc.free(pointer);

    return typeInfoPtr;
  }

  // [OrtModelMetadata] related methods
  int modelMetadataGetVersion(Pointer<OrtModelMetadata> metadataPtr) {
    final pointer = malloc<Int64>();

    _checkStatus(
      ModelMetadataGetVersion.asFunction<types.ModelMetadataGetVersion>(
        isLeaf: true,
      )(metadataPtr, pointer),
    );

    final version = pointer.value;
    malloc.free(pointer);

    return version;
  }

  String modelMetadataGetStringProperty(
    Pointer<OrtModelMetadata> metadataPtr,
    Pointer<OrtAllocator> allocatorPtr,
    types.ModelMetadataGetStringProperty fn,
  ) {
    final pointer = malloc<Pointer<Char>>();
    _checkStatus(fn(metadataPtr, allocatorPtr, pointer));

    final strPtr = pointer.value;
    final strValue = strPtr.cast<Utf8>().toDartString();
    allocatorFree(allocatorPtr, strPtr.cast());
    malloc.free(pointer);

    return strValue;
  }

  List<String> modelMetadataGetCustomMetadataMapKeys(
    Pointer<OrtModelMetadata> metadataPtr,
    Pointer<OrtAllocator> allocatorPtr,
  ) {
    final keysCountPtr = malloc<Int64>();
    final keysArrayPtr = calloc<Pointer<Pointer<Char>>>();

    _checkStatus(
      ModelMetadataGetCustomMetadataMapKeys.asFunction<
        types.ModelMetadataGetCustomMetadataMapKeys
      >(isLeaf: true)(metadataPtr, allocatorPtr, keysArrayPtr, keysCountPtr),
    );

    final keysCount = keysCountPtr.value;
    malloc.free(keysCountPtr);

    final keysList = <String>[];
    for (var i = 0; i < keysCount; ++i) {
      final strPtr = keysArrayPtr[i].value;
      keysList.add(strPtr.cast<Utf8>().toDartString());

      allocatorFree(allocatorPtr, strPtr.cast());
    }

    malloc.free(keysArrayPtr);

    return keysList;
  }

  // [OrtTypeInfo] related methods
  Pointer<OrtTensorTypeAndShapeInfo> castToTensorTypeAndShapeInfo(
    Pointer<OrtTypeInfo> typeInfoPtr,
  ) {
    final pointer = malloc<Pointer<OrtTensorTypeAndShapeInfo>>();
    _checkStatus(
      CastTypeInfoToTensorInfo.asFunction<types.CastTypeInfoToTensorInfo>(
        isLeaf: true,
      )(typeInfoPtr, pointer),
    );

    final tensorInfoPtr = pointer.value;
    malloc.free(pointer);

    return tensorInfoPtr;
  }

  int getOnnxTypeFromTypeInfo(Pointer<OrtTypeInfo> typeInfoPtr) {
    final pointer = malloc<UnsignedInt>();
    _checkStatus(
      GetOnnxTypeFromTypeInfo.asFunction<types.GetOnnxTypeFromTypeInfo>(
        isLeaf: true,
      )(typeInfoPtr, pointer),
    );

    final onnxType = pointer.value;
    malloc.free(pointer);

    return onnxType;
  }

  // [OrtTensorTypeAndShapeInfo] related methods
  int getTensorShapeCount(Pointer<OrtTensorTypeAndShapeInfo> tensorInfoPtr) {
    final pointer = malloc<Size>();
    _checkStatus(
      GetDimensionsCount.asFunction<types.GetDimensionsCount>(isLeaf: true)(
        tensorInfoPtr,
        pointer,
      ),
    );

    final sizeCount = pointer.value;
    malloc.free(pointer);

    return sizeCount;
  }

  List<int> getTensorShape(
    Pointer<OrtTensorTypeAndShapeInfo> tensorInfoPtr,
    int dimensionCount,
  ) {
    final pointer = malloc<Int64>(dimensionCount);
    _checkStatus(
      GetDimensions.asFunction<types.GetDimensions>(isLeaf: true)(
        tensorInfoPtr,
        pointer,
        dimensionCount,
      ),
    );

    final dimensions = pointer.asTypedList(dimensionCount).toList();
    malloc.free(pointer);

    return dimensions;
  }

  List<String> getTensorSymbolicShape(
    Pointer<OrtTensorTypeAndShapeInfo> tensorInfoPtr,
    int dimensionCount,
  ) {
    final pointer = malloc<Pointer<Char>>(dimensionCount);
    _checkStatus(
      GetSymbolicDimensions.asFunction<types.GetSymbolicDimensions>(
        isLeaf: true,
      )(tensorInfoPtr, pointer, dimensionCount),
    );

    final symbolicDimensions = <String>[];
    for (var i = 0; i < dimensionCount; ++i) {
      final strPtr = pointer[i];
      symbolicDimensions.add(strPtr.cast<Utf8>().toDartString());

      malloc.free(strPtr);
    }

    malloc.free(pointer);

    return symbolicDimensions;
  }

  // [OrtValue] related methods
  createTensorAsOrtValue(
    Pointer<OrtAllocator> allocatorPtr,
    List<int> shape,
    int type,
  ) {
    final pointer = malloc<Pointer<OrtValue>>();
    final shapeArrPtr = malloc<Int64>(shape.length);
    shapeArrPtr.asTypedList(shape.length).setRange(0, shape.length, shape);

    _checkStatus(
      CreateTensorAsOrtValue.asFunction<types.CreateTensorAsOrtValue>(
        isLeaf: true,
      )(allocatorPtr, shapeArrPtr, shape.length, type, pointer),
    );

    final tensorPtr = pointer.value;
    malloc.free(shapeArrPtr);
    malloc.free(pointer);

    return tensorPtr;
  }

  createTensorWithDataAsOrtValue(
    Pointer<OrtAllocator> allocatorPtr,
    List<int> shape,
    int type,
  ) {
    final pointer = malloc<Pointer<OrtValue>>();
    final shapeArrPtr = malloc<Int64>(shape.length);
    shapeArrPtr.asTypedList(shape.length).setRange(0, shape.length, shape);

    // _checkStatus(
    //   CreateTensorWithDataAsOrtValue.asFunction<
    //     types.CreateTensorWithDataAsOrtValue
    //   >(isLeaf: true)(allocatorPtr, shapeArrPtr, shape.length, type, pointer),
    // );

    final tensorPtr = pointer.value;
    malloc.free(shapeArrPtr);
    malloc.free(pointer);

    return tensorPtr;
  }
}

void _checkStatus(Pointer<OrtStatus> status) {
  if (status == nullptr) {
    // Mostly the status is [nullptr], it indicates success, however as per the
    // docs, this should not be a [nullptr].

    return;
  }

  final code = ortApi.getErrorCode(status);
  final _ /*message*/ = ortApi.getErrorMessage(status);

  ortApi.releaseStatus(status);

  switch (code) {
    case 0: // ORT_OK
      return;
    case 1: // ORT_FAIL
    case 2: // ORT_INVALID_ARGUMENT
    case 3: // ORT_NO_SUCHFILE
    case 4: // ORT_NO_MODEL
    case 5: // ORT_ENGINE_ERROR
    case 6: // ORT_RUNTIME_EXCEPTION
    case 7: // ORT_INVALID_PROTOBUF
    case 8: // ORT_MODEL_LOADED
    case 9: // ORT_NOT_IMPLEMENTED
    case 10: // ORT_INVALID_GRAPH
    case 11: // ORT_EP_FAIL
    default:
  }
}

extension _PointerPointerX<T extends NativeType> on Pointer<Pointer<T>> {
  @pragma("vm:prefer-inline")
  Pointer<T> dispose() {
    final val = value;
    malloc.free(this);

    return val;
  }
}
