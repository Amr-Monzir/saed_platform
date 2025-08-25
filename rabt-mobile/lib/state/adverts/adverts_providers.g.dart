// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adverts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$advertByIdHash() => r'4e65b7db0c7b7c5fced27b2d60c478f3b0d51b07';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [advertById].
@ProviderFor(advertById)
const advertByIdProvider = AdvertByIdFamily();

/// See also [advertById].
class AdvertByIdFamily extends Family<AsyncValue<Advert?>> {
  /// See also [advertById].
  const AdvertByIdFamily();

  /// See also [advertById].
  AdvertByIdProvider call(int id) {
    return AdvertByIdProvider(id);
  }

  @override
  AdvertByIdProvider getProviderOverride(
    covariant AdvertByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'advertByIdProvider';
}

/// See also [advertById].
class AdvertByIdProvider extends AutoDisposeFutureProvider<Advert?> {
  /// See also [advertById].
  AdvertByIdProvider(int id)
    : this._internal(
        (ref) => advertById(ref as AdvertByIdRef, id),
        from: advertByIdProvider,
        name: r'advertByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$advertByIdHash,
        dependencies: AdvertByIdFamily._dependencies,
        allTransitiveDependencies: AdvertByIdFamily._allTransitiveDependencies,
        id: id,
      );

  AdvertByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Advert?> Function(AdvertByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdvertByIdProvider._internal(
        (ref) => create(ref as AdvertByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Advert?> createElement() {
    return _AdvertByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdvertByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdvertByIdRef on AutoDisposeFutureProviderRef<Advert?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AdvertByIdProviderElement
    extends AutoDisposeFutureProviderElement<Advert?>
    with AdvertByIdRef {
  _AdvertByIdProviderElement(super.provider);

  @override
  int get id => (origin as AdvertByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
