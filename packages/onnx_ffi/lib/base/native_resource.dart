import 'dart:ffi';

import 'package:meta/meta.dart';

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
  /// [finalizer] specifies how the native resource should be cleaned up and it
  /// is preferred to call this in the constructor since the resource should be
  /// attached to finalizer as soon as it is created.
  ///
  /// Example usage:
  /// ```dart
  /// class SomeObject extends NativeResource<Void> {
  ///   SomeObject(super.ref) {
  ///     attachFinalizer(this);
  ///   }
  ///
  ///   static NativeFinalizer = NativeFinalizer(...);
  /// }
  ///
  /// final resource = SomeObject(pointer).withFinalizer(myFinalizer);
  /// resource.attachFinalizer(myFinalizer);
  /// ```
  @protected
  void attachFinalizer<U extends NativeType, V extends NativeResource<U>>(
    NativeFinalizer finalizer,
  ) {
    finalizer.attach(this, ref.cast(), detach: this);
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
