import 'dart:ffi';

/// A class that manages native resources with proper cleanup handling.
///
/// This class provides a safe wrapper around native pointers with automatic
/// resource management through finalizers. It ensures proper cleanup of native
/// resources when the Dart object is garbage collected.
///
/// Type parameter [T] represents the specific native type being managed.
abstract base class NativeResource<T extends NativeType>
    implements Finalizable {
  /// Creates a new [NativeResource] instance.
  ///
  /// The [ref] parameter must not be null and should point to a valid native resource.
  NativeResource(this.ref)
    : assert(ref != nullptr, 'Native pointer cannot be null');

  /// The underlying native pointer to the resource.
  ///
  /// This pointer can be used directly but it is not recommended to use free
  /// this reference since that portion is managed by [NativeFinalizer]
  final Pointer<T> ref;

  /// Attaches a finalizer to this resource for automatic cleanup.
  ///
  /// [finalizer] specifies how the native resource should be cleaned up.
  /// Returns the resource cast to the specified type [V].
  ///
  /// Example usage:
  /// ```dart
  /// class SomeObject extends NativeResource<Void> {
  ///   // ....
  /// }
  ///
  /// final resource = SomeObject(pointer).withFinalizer(myFinalizer);
  /// ```
  V withFinalizer<U extends NativeType, V extends NativeResource<U>>(
    NativeFinalizer finalizer,
  ) {
    finalizer.attach(this, ref.cast(), detach: this);

    return this as V;
  }

  /// Safely casts the native pointer to a different type.
  ///
  /// [U] is the target native type to cast to.
  /// Returns a new [NativeResource] instance with the cast pointer.
  ///
  /// This operation is not valid for all kinds of resources thus by default it
  /// throws
  NativeResource<U> cast<U extends NativeType>() {
    throw UnsupportedError(
      '$runtimeType can not be casted to another type (NativeResource<$U>)',
    );
  }
}
