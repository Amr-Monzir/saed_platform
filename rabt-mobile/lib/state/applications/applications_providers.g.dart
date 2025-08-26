// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applications_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicationsListHash() => r'f761191084e401b5aaf09a4679f659a873404b40';

/// See also [ApplicationsList].
@ProviderFor(ApplicationsList)
final applicationsListProvider = AutoDisposeAsyncNotifierProvider<
  ApplicationsList,
  PaginatedResponse<Application>?
>.internal(
  ApplicationsList.new,
  name: r'applicationsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$applicationsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApplicationsList =
    AutoDisposeAsyncNotifier<PaginatedResponse<Application>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
