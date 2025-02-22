// import 'dart:ffi';
//
// import '../../base/onnx_runtime.dart';
//
// import '../../ffigen/typedefs.dart';
//
// late final ReleaseStatus $releaseStatusFn;
//
// late final GetStatusCode $getStatusCodeFn;
// late final GetStatusMessage $getStatusMessageFn;
//
// ///
// void setupFunctionsCache() {
//   $releaseStatusFn = OnnxRuntime.$.api.ReleaseStatus.asFunction<ReleaseStatus>(
//     isLeaf: true,
//   );
//   $getStatusCodeFn = OnnxRuntime.$.api.GetErrorCode.asFunction<GetStatusCode>(
//     isLeaf: false,
//   );
//
//   $getStatusMessageFn = OnnxRuntime.$.api.GetErrorMessage
//       .asFunction<GetStatusMessage>(isLeaf: true);
// }
