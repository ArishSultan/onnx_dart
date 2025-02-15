// part of '../onnx_ffigen.dart';
//
// final class Session extends NativeObject<OrtEnv> {
//   const Session._(super.reference);
//
//   // external ffi.Pointer<
//   //     ffi.NativeFunction<
//   //         OrtStatusPtr Function(
//   //             ffi.Pointer<OrtEnv> env,
//   //             ffi.Pointer<ffi.Char> model_path,
//   //             ffi.Pointer<OrtSessionOptions> options,
//   //             ffi.Pointer<ffi.Pointer<OrtSession>> out)>> CreateSession;
//
//   factory Session({
//     required Environment environment,
//   }) {
//     // final pointer = calloc<Pointer<OrtSession>>();
//     // final resolvedLoggingLevel = switch (loggingLevel) {
//     //   LoggingLevel.verbose => 0,
//     //   LoggingLevel.info => 1,
//     //   LoggingLevel.warning => 2,
//     //   LoggingLevel.error => 3,
//     //   LoggingLevel.fatal => 4,
//     // };
//     //
//     // // TODO(ArishSultan): Add mechanism to create env with threading options
//     // _handleStatus(
//     //   _ortApi.CreateEnv.asFunction<CreateEnv>(isLeaf: true)(
//     //     resolvedLoggingLevel,
//     //     logId.toNativeUtf8().cast<Char>(),
//     //     pointer,
//     //   ),
//     // );
//     //
//     // return Environment._(pointer.value).withFinalizer(_finalizer);
//   }
//
//   static final Finalizer<Pointer<OrtEnv>> _finalizer = Finalizer(
//     _ortApi.ReleaseEnv.asFunction<ReleaseEnv>(isLeaf: true),
//   );
// }
