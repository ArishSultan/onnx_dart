import 'dart:ffi';

///
base class NativeObject<T extends NativeType> implements Finalizable {
  ///
  const NativeObject(this.reference);

  ///
  final Pointer<T> reference;

  ///
  V withFinalizer<U extends NativeType, V extends NativeObject<U>>(
    Finalizer<Pointer<T>> finalizer,
  ) {
    finalizer.attach(this, reference);

    return this as V;
  }
}
