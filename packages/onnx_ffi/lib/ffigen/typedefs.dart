import 'dart:ffi';

import '../../ffigen/bindings.dart';

// [OrtApiBase] Methods
typedef GetApi = Pointer<OrtApi> Function(int);
typedef GetVersionString = Pointer<Char> Function();

// [OrtStatus] Methods
typedef ReleaseStatus = void Function(Pointer<OrtStatus> ref);
typedef GetErrorCode = int Function(Pointer<OrtStatus> status);
typedef GetErrorMessage = Pointer<Char> Function(Pointer<OrtStatus> status);

// [OrtEnv] Methods
typedef ReleaseEnv = void Function(Pointer<OrtEnv> ref);
typedef CreateEnv =
    Pointer<OrtStatus> Function(
      int logLevel,
      Pointer<Char> logId,
      Pointer<Pointer<OrtEnv>> ref,
    );

// [OrtAllocator] Methods
typedef ReleaseAllocator = void Function(Pointer<OrtAllocator> ref);
typedef GetAllocatorWithDefaultOptions =
    Pointer<OrtStatus> Function(Pointer<Pointer<OrtAllocator>> ref);
typedef AllocatorGetInfo =
    Pointer<OrtStatus> Function(
      Pointer<OrtAllocator> allocatorPtr,
      Pointer<Pointer<OrtMemoryInfo>> ref,
    );
typedef AllocatorFree =
    Pointer<OrtStatus> Function(
      Pointer<OrtAllocator> allocator,
      Pointer<Void> data,
    );

// [OrtMemoryInfo] Methods
typedef MemoryInfoGetDeviceType =
    void Function(
      Pointer<OrtMemoryInfo> memoryInfoPtr,
      Pointer<UnsignedInt> ref,
    );
typedef MemoryInfoGetIntValue =
    Pointer<OrtStatus> Function(
      Pointer<OrtMemoryInfo> memoryInfoPtr,
      Pointer<Int> ref,
    );
typedef MemoryInfoGetStringValue =
    Pointer<OrtStatus> Function(
      Pointer<OrtMemoryInfo> memoryInfoPtr,
      Pointer<Pointer<Char>> ref,
    );

// [OrtSession] Methods
typedef ReleaseSession = void Function(Pointer<OrtSession> ref);
typedef CreateSession =
    Pointer<OrtStatus> Function(
      Pointer<OrtEnv> env,
      Pointer<Char> modelPath,
      Pointer<OrtSessionOptions> options,
      Pointer<Pointer<OrtSession>> ref,
    );
typedef CreateSessionFromArray =
    Pointer<OrtStatus> Function(
      Pointer<OrtEnv> env,
      Pointer<Void> modelData,
      int modelDataLength,
      Pointer<OrtSessionOptions> options,
      Pointer<Pointer<OrtSession>> ref,
    );
typedef SessionGetModelMetadata =
    Pointer<OrtStatus> Function(
      Pointer<OrtSession> session,
      Pointer<Pointer<OrtModelMetadata>> ref,
    );
typedef SessionGetModelIOCount =
    Pointer<OrtStatus> Function(Pointer<OrtSession> session, Pointer<Size> ref);
typedef SessionGetModelIOName =
    Pointer<OrtStatus> Function(
      Pointer<OrtSession> session,
      int index,
      Pointer<OrtAllocator> allocator,
      Pointer<Pointer<Char>> ref,
    );
typedef SessionGetModelIoTypeInfo =
    Pointer<OrtStatus> Function(
      Pointer<OrtSession> session,
      int index,
      Pointer<Pointer<OrtTypeInfo>> typeInfo,
    );
typedef Run =
    Pointer<OrtStatus> Function(
      Pointer<OrtSession> sessionPtr,
      Pointer<OrtRunOptions> runOptionsPtr,
      Pointer<Pointer<Char>> inputNames,
      Pointer<Pointer<OrtValue>> inputs,
      int inputLen,
      Pointer<Pointer<Char>> outputNames,
      int outputNamesLen,
      Pointer<Pointer<OrtValue>> ref,
    );
typedef RunAsync =
    Pointer<OrtStatus> Function(
      Pointer<OrtSession> sessionPtr,
      Pointer<OrtRunOptions> runOptionsPtr,
      Pointer<Pointer<Char>> inputNames,
      Pointer<Pointer<OrtValue>> inputs,
      int inputLen,
      Pointer<Pointer<Char>> outputNames,
      int outputNamesLen,
      Pointer<Pointer<OrtValue>> ref,
      RunAsyncCallbackFn runAsyncCallback,
      Pointer<Void> userData,
    );

// [OrtSessionOptions] Methods
typedef ReleaseSessionOptions = void Function(Pointer<OrtSessionOptions> ref);
typedef CreateSessionOptions =
    Pointer<OrtStatus> Function(Pointer<Pointer<OrtSessionOptions>> ref);

// [OrtRunOptions] Methods
typedef CreateRunOptions =
    Pointer<OrtStatus> Function(Pointer<Pointer<OrtRunOptions>> ref);

// [OrtModelMetadata] Methods
typedef ReleaseModelMetadata = Function();
typedef ModelMetadataGetVersion =
    Pointer<OrtStatus> Function(
      Pointer<OrtModelMetadata> modelMetadata,
      Pointer<Int64> ref,
    );
typedef ModelMetadataGetStringProperty =
    Pointer<OrtStatus> Function(
      Pointer<OrtModelMetadata> modelMetadata,
      Pointer<OrtAllocator> allocator,
      Pointer<Pointer<Char>> ref,
    );
typedef ModelMetadataGetCustomMetadataMapKeys =
    Pointer<OrtStatus> Function(
      Pointer<OrtModelMetadata> modelMetadata,
      Pointer<OrtAllocator> allocator,
      Pointer<Pointer<Pointer<Char>>> keysRef,
      Pointer<Int64> numKeysRef,
    );
typedef ModelMetadataLookupCustomMetadataMap =
    Pointer<OrtStatus> Function(
      Pointer<OrtModelMetadata> modelMetadata,
      Pointer<OrtAllocator> allocator,
      Pointer<Char> key,
      Pointer<Pointer<Char>> value,
    );

// [OrtTypeInfo] Methods
typedef ReleaseTypeInfo = void Function(Pointer<OrtTypeInfo> input);
typedef GetOnnxTypeFromTypeInfo =
    Pointer<OrtStatus> Function(
      Pointer<OrtTypeInfo> typeInfo,
      Pointer<UnsignedInt> ref,
    );
typedef CastTypeInfoToTensorInfo =
    Pointer<OrtStatus> Function(
      Pointer<OrtTypeInfo> typeInfo,
      Pointer<Pointer<OrtTensorTypeAndShapeInfo>> ref,
    );

// [OrtTensorTypeAndShapeInfo] Methods
typedef CreateTensorTypeAndShapeInfo =
    Pointer<OrtStatus> Function(
      Pointer<Pointer<OrtTensorTypeAndShapeInfo>> ref,
    );
typedef SetTensorElementType =
    Pointer<OrtStatus> Function(
      Pointer<OrtTensorTypeAndShapeInfo> info,
      int type,
    );
typedef SetDimensions =
    Pointer<OrtStatus> Function(
      Pointer<OrtTensorTypeAndShapeInfo> info,
      Pointer<Int64> dimValues,
      int dimCount,
    );
typedef GetTensorElementType =
    Pointer<OrtStatus> Function(
      Pointer<OrtTensorTypeAndShapeInfo> info,
      Pointer<UnsignedInt> ref,
    );
typedef GetDimensionsCount =
    Pointer<OrtStatus> Function(
      Pointer<OrtTensorTypeAndShapeInfo> info,
      Pointer<Size> ref,
    );
typedef GetDimensions =
    Pointer<OrtStatus> Function(
      Pointer<OrtTensorTypeAndShapeInfo> info,
      Pointer<Int64> dimValues,
      int dimValuesLength,
    );
typedef GetSymbolicDimensions =
    Pointer<OrtStatus> Function(
      Pointer<OrtTensorTypeAndShapeInfo> info,
      Pointer<Pointer<Char>> dimParams,
      int dimParamsLength,
    );
typedef GetTensorShapeElementCount =
    Pointer<OrtStatus> Function(
      Pointer<OrtTensorTypeAndShapeInfo> info,
      Pointer<Size> ref,
    );

// [OrtValue] related methods
typedef CreateTensorAsOrtValue =
    Pointer<OrtStatus> Function(
      Pointer<OrtAllocator> allocatorPtr,
      Pointer<Int64> shapePtr,
      int shapeLen,
      int type,
      Pointer<Pointer<OrtValue>> ref,
    );
typedef CreateTensorWithDataAsOrtValue =
    Pointer<OrtStatus> Function(
      Pointer<OrtMemoryInfo> info,
      Pointer<Void> pData,
      int pDataLen,
      Pointer<Int64> shapePtr,
      int shapeLen,
      int type,
      Pointer<Pointer<OrtValue>> ref,
    );
typedef TensorAt =
    Pointer<OrtStatus> Function(
      Pointer<OrtValue> valuePtr,
      Pointer<Int64> locationValues,
      int locationValuesCount,
      Pointer<Pointer<Void>> ref,
    );
typedef GetTypeInfo =
    Pointer<OrtStatus> Function(
      Pointer<OrtValue> value,
      Pointer<Pointer<OrtTypeInfo>> ref,
    );
