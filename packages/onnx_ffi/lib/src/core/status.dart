// import 'dart:ffi';
//
// import 'cache.dart';
//
// import '../../ffigen/bindings.dart';
//
// void checkOrtStatus(Pointer<OrtStatus> status) {
//   if (status == nullptr) {
//     // There is no status, call is marked as success.
//     return;
//   }
//
//   final code = $getStatusCodeFn(status);
//   final message = $getStatusMessageFn(status);
//
//   if (code == 0) {
//     // The function call is success.
//     return;
//   }
//
//   print('code: $code, message: $message');
// }
