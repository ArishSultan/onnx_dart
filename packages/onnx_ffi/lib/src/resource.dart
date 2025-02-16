import 'dart:ffi';

///
base class Resource<T extends NativeType> implements Finalizable {
  ///
  const Resource(this.ref);

  ///
  final Pointer<T> ref;

  ///
  V withFinalizer<U extends NativeType, V extends Resource<U>>(
    NativeFinalizer finalizer,
  ) {
    finalizer.attach(this, ref.cast(), detach: this);

    return this as V;
  }
}
