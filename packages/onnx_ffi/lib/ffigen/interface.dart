import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:onnx_ffi/src/values/value.dart';

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

  Pointer<OrtMemoryInfo> allocatorGetInfo(Pointer<OrtAllocator> allocatorPtr) {
    final pointer = malloc<Pointer<OrtMemoryInfo>>();

    _checkStatus(
      ortApi.AllocatorGetInfo.asFunction<types.AllocatorGetInfo>(isLeaf: true)(
        allocatorPtr,
        pointer,
      ),
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

  // [OrtMemoryInfo] related methods
  int memoryInfoGetDeviceType(Pointer<OrtMemoryInfo> memoryInfoPtr) {
    final pointer = malloc<UnsignedInt>();
    ortApi.MemoryInfoGetDeviceType.asFunction<types.MemoryInfoGetDeviceType>(
      isLeaf: true,
    )(memoryInfoPtr, pointer);

    final deviceType = pointer.value;
    malloc.free(pointer);

    return deviceType;
  }

  int memoryInfoGetId(Pointer<OrtMemoryInfo> memoryInfoPtr) {
    final pointer = malloc<Int>();
    ortApi.MemoryInfoGetId.asFunction<types.MemoryInfoGetIntValue>(
      isLeaf: true,
    )(memoryInfoPtr, pointer);

    final id = pointer.value;
    malloc.free(pointer);

    return id;
  }

  int memoryInfoGetMemType(Pointer<OrtMemoryInfo> memoryInfoPtr) {
    final pointer = malloc<Int>();
    ortApi.MemoryInfoGetMemType.asFunction<types.MemoryInfoGetIntValue>(
      isLeaf: true,
    )(memoryInfoPtr, pointer);

    final memType = pointer.value;
    malloc.free(pointer);

    return memType;
  }

  String memoryInfoGetName(Pointer<OrtMemoryInfo> memoryInfoPtr, bool managed) {
    final pointer = malloc<Pointer<Char>>();
    ortApi.MemoryInfoGetName.asFunction<types.MemoryInfoGetStringValue>(
      isLeaf: true,
    )(memoryInfoPtr, pointer);

    final namePtr = pointer.dispose();
    final nameStr = namePtr.cast<Utf8>().toDartString();

    if (!managed) {
      malloc.free(namePtr);
    }

    return nameStr;
  }

  int memoryInfoGetType(Pointer<OrtMemoryInfo> memoryInfoPtr) {
    final pointer = malloc<Int>();
    ortApi.MemoryInfoGetType.asFunction<types.MemoryInfoGetIntValue>(
      isLeaf: true,
    )(memoryInfoPtr, pointer);

    final type = pointer.value;
    malloc.free(pointer);

    return type;
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

  // [OrtRunOptions] related methods
  Pointer<OrtRunOptions> createRunOptions() {
    final pointer = malloc<Pointer<OrtRunOptions>>();

    _checkStatus(
      CreateRunOptions.asFunction<types.CreateRunOptions>(isLeaf: true)(
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

  Future<List<Pointer<OrtValue>>> runAsync(
    Pointer<OrtSession> sessionPtr,
    Pointer<OrtRunOptions> runOptionsPtr,
    Map<String, OnnxValue> inputs,
    List<String> outputs,
  ) {
    final completer = Completer<List<Pointer<OrtValue>>>();

    // TODO: Fix this implementation for proper use.
    final id = _asyncFunctions.length;
    _asyncFunctions[id] = completer;

    final pointer = malloc<Pointer<OrtValue>>(outputs.length);
    final (outputNamesPtr, outputLen) = _dissembleOutputList(outputs);
    final (inputNamesPtr, inputValuesPtr, inputLen) = _dissembleInputMap(
      inputs,
    );

    final userDataPtr = malloc<Int>();
    userDataPtr.value = id;

    _checkStatus(
      RunAsync.asFunction<types.RunAsync>(isLeaf: true)(
        sessionPtr,
        runOptionsPtr,
        inputNamesPtr,
        inputValuesPtr,
        inputLen,
        outputNamesPtr,
        outputLen,
        pointer,
        _pointerHandleAsyncCallback.nativeFunction,
        userDataPtr.cast(),
      ),
    );

    return completer.future;
  }

  List<Pointer<OrtValue>> run(
    Pointer<OrtSession> sessionPtr,
    Pointer<OrtRunOptions> runOptionsPtr,
    Map<String, OnnxValue> inputs,
    List<String> outputs,
  ) {
    final pointer = malloc<Pointer<OrtValue>>(outputs.length);
    final (outputNamesPtr, outputLen) = _dissembleOutputList(outputs);
    final (inputNamesPtr, inputValuesPtr, inputLen) = _dissembleInputMap(
      inputs,
    );

    _checkStatus(
      Run.asFunction<types.Run>(isLeaf: true)(
        sessionPtr,
        runOptionsPtr,
        inputNamesPtr,
        inputValuesPtr,
        inputLen,
        outputNamesPtr,
        outputLen,
        pointer,
      ),
    );

    final outputList = <Pointer<OrtValue>>[];
    for (var i = 0; i < outputLen; ++i) {
      outputList.add(pointer[i]);
    }

    malloc.free(pointer);

    return outputList;
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

  int getTensorElementType(Pointer<OrtTensorTypeAndShapeInfo> tensorInfoPtr) {
    final pointer = malloc<UnsignedInt>();

    _checkStatus(
      GetTensorElementType.asFunction<types.GetTensorElementType>(isLeaf: true)(
        tensorInfoPtr,
        pointer,
      ),
    );

    final elementType = pointer.value;
    malloc.free(pointer);

    return elementType;
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
    // malloc.free(pointer);

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
  Pointer<OrtValue> createTensorAsOrtValue<T extends TypedDataList>(
    Pointer<OrtAllocator> allocatorPtr,
    List<int> shape,
  ) {
    final pointer = malloc<Pointer<OrtValue>>();
    final shapeArrPtr = malloc<Int64>(shape.length);
    shapeArrPtr.asTypedList(shape.length).setRange(0, shape.length, shape);

    _checkStatus(
      CreateTensorAsOrtValue.asFunction<types.CreateTensorAsOrtValue>(
        isLeaf: true,
      )(
        allocatorPtr,
        shapeArrPtr,
        shape.length,
        resolveOnnxTypeFromDartType(T),
        pointer,
      ),
    );

    final tensorPtr = pointer.value;
    malloc.free(shapeArrPtr);
    malloc.free(pointer);

    return tensorPtr;
  }

  Pointer<OrtTypeInfo> getValueTypeInfo(Pointer<OrtValue> value) {
    final pointer = malloc<Pointer<OrtTypeInfo>>();
    _checkStatus(
      GetTypeInfo.asFunction<types.GetTypeInfo>(isLeaf: true)(value, pointer),
    );

    return pointer.dispose();
  }

  Pointer<OrtValue> createTensorWithDataAsOrtValue<T extends TypedDataList>(
    Pointer<OrtMemoryInfo> memoryInfoPtr,
    T data,
    List<int> shape,
  ) {
    final pointer = malloc<Pointer<OrtValue>>();
    final shapeArrPtr = malloc<Int64>(shape.length);
    shapeArrPtr.asTypedList(shape.length).setRange(0, shape.length, shape);

    final convertedData = data.buffer.asUint8List();
    final dataArrayPtr = malloc<Int8>(convertedData.length);
    dataArrayPtr
        .asTypedList(convertedData.length)
        .setRange(0, convertedData.length, convertedData);

    _checkStatus(
      CreateTensorWithDataAsOrtValue.asFunction<
        types.CreateTensorWithDataAsOrtValue
      >(isLeaf: true)(
        memoryInfoPtr,
        dataArrayPtr.cast(),
        data.lengthInBytes,
        shapeArrPtr,
        shape.length,
        resolveOnnxTypeFromDartType(T),
        pointer,
      ),
    );

    malloc.free(shapeArrPtr);
    return pointer.dispose();
  }

  tensorAt<T extends TypedDataList>(
    Pointer<OrtValue> valuePtr,
    List<int> index,
  ) {
    final pointer = malloc<Pointer<Void>>();
    final indexArrPtr = malloc<Int64>(index.length);
    indexArrPtr.asTypedList(index.length).setRange(0, index.length, index);

    _checkStatus(
      TensorAt.asFunction<types.TensorAt>(isLeaf: true)(
        valuePtr,
        indexArrPtr,
        index.length,
        pointer,
      ),
    );

    final data = pointer.dispose();
    return switch (T) {
      Int8List => data.cast<Int8>().asTypedList(1),
      Int16List => data.cast<Int16>().asTypedList(1),
      Int32List => data.cast<Int32>().asTypedList(1),
      Int64List => data.cast<Int64>().asTypedList(1),

      Uint8List => data.cast<Uint8>().asTypedList(1),
      Uint16List => data.cast<Uint8>().asTypedList(1),
      Uint32List => data.cast<Uint8>().asTypedList(1),
      Uint64List => data.cast<Uint8>().asTypedList(1),

      Float32List => data.cast<Float>().asTypedList(1),
      Float64List => data.cast<Double>().asTypedList(1),

      _ => throw UnimplementedError(),
    };
  }
}

Map<int, Completer<List<Pointer<OrtValue>>>> _asyncFunctions = {};

final _pointerHandleAsyncCallback =
    NativeCallable<RunAsyncCallbackFnFunction>.listener(_handleAsyncCallback);

void _handleAsyncCallback(
  Pointer<Void> userData,
  Pointer<Pointer<OrtValue>> outputs,
  int outputsCount,
  Pointer<OrtStatus> status,
) {
  final id = userData.cast<Int>().value;
  malloc.free(userData);

  final completer = _asyncFunctions.remove(id)!;
  try {
    _checkStatus(status);

    final outputList = <Pointer<OrtValue>>[];
    for (var i = 0; i < outputsCount; ++i) {
      outputList.add(outputs[i]);
    }

    malloc.free(outputs);

    completer.complete(outputList);
  } catch (err) {
    malloc.free(outputs);
    completer.completeError(err);
  }
}

(Pointer<Pointer<Char>>, Pointer<Pointer<OrtValue>>, int) _dissembleInputMap(
  Map<String, OnnxValue> value,
) {
  final names = value.keys.toList();
  final values = value.values.toList();

  final nameArrayPtr = malloc<Pointer<Char>>(names.length);
  for (var i = 0; i < names.length; ++i) {
    nameArrayPtr[i] = names[i].toNativeUtf8().cast();
  }

  final valueArrayPtr = malloc<Pointer<OrtValue>>(values.length);
  for (var i = 0; i < values.length; ++i) {
    valueArrayPtr[i] = values[i].ref;
  }

  return (nameArrayPtr, valueArrayPtr, value.length);
}

(Pointer<Pointer<Char>>, int) _dissembleOutputList(List<String> values) {
  final names = values.toList();
  final nameArrayPtr = malloc<Pointer<Char>>(names.length);
  for (var i = 0; i < names.length; ++i) {
    nameArrayPtr[i] = names[i].toNativeUtf8().cast();
  }

  return (nameArrayPtr, values.length);
}

int resolveOnnxTypeFromDartType(Type type) {
  return switch (type) {
    const (List<bool>) => 9, // ONNX_TENSOR_ELEMENT_DATA_TYPE_STRING(8),
    const (List<String>) => 8, // ONNX_TENSOR_ELEMENT_DATA_TYPE_BOOL(9),

    Int8List => 3, // ONNX_TENSOR_ELEMENT_DATA_TYPE_INT8
    Int16List => 5, // ONNX_TENSOR_ELEMENT_DATA_TYPE_INT16
    Int32List => 6, // ONNX_TENSOR_ELEMENT_DATA_TYPE_INT32
    Int64List => 7, // ONNX_TENSOR_ELEMENT_DATA_TYPE_INT64

    Uint8List => 2, // ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT8
    Uint16List => 4, // ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT16
    Uint32List => 12, // ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT32
    Uint64List => 13, // ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT64

    Float32List => 1, // ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT
    Float64List => 11, // ONNX_TENSOR_ELEMENT_DATA_TYPE_DOUBLE
    // These types are not supported by dart as of now
    // -----------------------------------------------
    //
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_UNDEFINED(0),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT16(10),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX64(14),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX128(15),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_BFLOAT16(16),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E4M3FN(17),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E4M3FNUZ(18),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E5M2(19),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT8E5M2FNUZ(20),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT4(21),
    // ONNX_TENSOR_ELEMENT_DATA_TYPE_INT4(22)
    _ => throw UnimplementedError(),
  };
}

void _checkStatus(Pointer<OrtStatus> status) {
  if (status == nullptr) {
    // Mostly the status is [nullptr], it indicates success, however as per the
    // docs, this should not be a [nullptr].

    return;
  }

  final code = ortApi.getErrorCode(status);
  final message = ortApi.getErrorMessage(status);

  print('code: $code, message: $message');

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
