library;

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../../ffigen/bindings.dart';

import 'src/internal/typedefs.dart';
import 'src/helpers/native_object.dart';

part 'src/internal/globals.dart';

part 'src/environment.dart';

part 'src/logging_level.dart';

part 'src/status.dart';

void loadLibrary(String path, [int version = 19]) {
  assert(version <= 19, 'MAX version allowed is 19.');

  _setupGlobals(DynamicLibrary.open(path), version);
}
