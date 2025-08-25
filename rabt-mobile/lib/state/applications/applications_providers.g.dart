// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applications_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicationsListHash() => r'87428d2bef8aa106879edfa3e752bb0598c9c1d8';

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

/// See also [applicationsList].
@ProviderFor(applicationsList)
const applicationsListProvider = ApplicationsListFamily();

/// See also [applicationsList].
class ApplicationsListFamily
    extends Family<AsyncValue<PaginatedResponse<Application>?>> {
  /// See also [applicationsList].
  const ApplicationsListFamily();

  /// See also [applicationsList].
  ApplicationsListProvider call({int? advertId, int? page, int? limit}) {
    return ApplicationsListProvider(
      advertId: advertId,
      page: page,
      limit: limit,
    );
  }

  @override
  ApplicationsListProvider getProviderOverride(
    covariant ApplicationsListProvider provider,
  ) {
    return call(
      advertId: provider.advertId,
      page: provider.page,
      limit: provider.limit,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'applicationsListProvider';
}

/// See also [applicationsList].
class ApplicationsListProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<Application>?> {
  /// See also [applicationsList].
  ApplicationsListProvider({int? advertId, int? page, int? limit})
    : this._internal(
        (ref) => applicationsList(
          ref as ApplicationsListRef,
          advertId: advertId,
          page: page,
          limit: limit,
        ),
        from: applicationsListProvider,
        name: r'applicationsListProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$applicationsListHash,
        dependencies: ApplicationsListFamily._dependencies,
        allTransitiveDependencies:
            ApplicationsListFamily._allTransitiveDependencies,
        advertId: advertId,
        page: page,
        limit: limit,
      );

  ApplicationsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.advertId,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int? advertId;
  final int? page;
  final int? limit;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<Application>?> Function(
      ApplicationsListRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApplicationsListProvider._internal(
        (ref) => create(ref as ApplicationsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        advertId: advertId,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<Application>?>
  createElement() {
    return _ApplicationsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicationsListProvider &&
        other.advertId == advertId &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, advertId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ApplicationsListRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<Application>?> {
  /// The parameter `advertId` of this provider.
  int? get advertId;

  /// The parameter `page` of this provider.
  int? get page;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _ApplicationsListProviderElement
    extends AutoDisposeFutureProviderElement<PaginatedResponse<Application>?>
    with ApplicationsListRef {
  _ApplicationsListProviderElement(super.provider);

  @override
  int? get advertId => (origin as ApplicationsListProvider).advertId;
  @override
  int? get page => (origin as ApplicationsListProvider).page;
  @override
  int? get limit => (origin as ApplicationsListProvider).limit;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
