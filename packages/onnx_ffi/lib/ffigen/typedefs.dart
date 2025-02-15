import 'dart:ffi';

import '../../ffigen/bindings.dart';

// [OrtApiBase] Methods
typedef GetApi = Pointer<OrtApi> Function(int);
typedef GetVersionString = Pointer<Char> Function();

// [OrtStatus] Methods
typedef ReleaseStatus = void Function(Pointer<OrtStatus> out);
typedef GetStatusCode = int Function(Pointer<OrtStatus> status);
typedef GetStatusMessage = Pointer<Char> Function(Pointer<OrtStatus> status);

// [OrtEnv] Methods
typedef ReleaseEnv = void Function(Pointer<OrtEnv> out);
typedef CreateEnv =
    Pointer<OrtStatus> Function(
      int logLevel,
      Pointer<Char> logId,
      Pointer<Pointer<OrtEnv>> ref,
    );
