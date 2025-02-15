part of '../onnx_ffigen.dart';

///
base class Resource<T extends NativeType> implements Finalizable {
  ///
  const Resource(this.ref);

  ///
  final Pointer<T> ref;

  ///
  V withFinalizer<U extends NativeType, V extends Resource<U>>(
    Finalizer<Pointer<T>> finalizer,
  ) {
    finalizer.attach(this, ref);

    return this as V;
  }
}
