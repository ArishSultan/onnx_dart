import 'dart:ffi';

import '../../ffigen/bindings.dart';

// [OrtApiBase] Methods
typedef GetApi = Pointer<OrtApi> Function(int);
typedef GetVersionString = Pointer<Char> Function();

// [OrtStatus] Methods
typedef ReleaseStatus = void Function(Pointer<OrtStatus> ref);
typedef GetStatusCode = int Function(Pointer<OrtStatus> status);
typedef GetStatusMessage = Pointer<Char> Function(Pointer<OrtStatus> status);

// [OrtEnv] Methods
typedef ReleaseEnv = void Function(Pointer<OrtEnv> ref);
typedef CreateEnv =
    Pointer<OrtStatus> Function(
      int logLevel,
      Pointer<Char> logId,
      Pointer<Pointer<OrtEnv>> ref,
    );

// [OrtAllocator]
typedef ReleaseAllocator = void Function(Pointer<OrtAllocator> ref);
typedef GetAllocatorWithDefaultOptions =
    Pointer<OrtStatus> Function(Pointer<Pointer<OrtAllocator>> ref);

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

// [OrtSessionOptions] Methods
typedef ReleaseSessionOptions = void Function(Pointer<OrtSessionOptions> ref);
typedef CreateSessionOptions =
    Pointer<OrtStatus> Function(Pointer<Pointer<OrtSessionOptions>> ref);

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
