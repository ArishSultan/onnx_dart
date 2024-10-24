import 'dart:ffi';

base class FFIObject<T extends NativeType> implements Finalizable {
  const FFIObject(this.reference);

  final Pointer<T> reference;

  static U withFinalizer<T extends NativeType, U extends FFIObject<T>>(
    U object,
    Finalizer<Pointer<T>> finalizer,
  ) {
    finalizer.attach(object, object.reference);
    return object;
  }
}
