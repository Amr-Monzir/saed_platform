// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applications_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$applicationsListHash() => r'4f79ee0707a503f0dc2b81b37143586b9d437096';

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
String _$pendingApplicationsHash() =>
    r'ffa3fc4d97a3c305f9a4ca9093dae5169b07a319';

/// See also [PendingApplications].
@ProviderFor(PendingApplications)
final pendingApplicationsProvider = AutoDisposeAsyncNotifierProvider<
  PendingApplications,
  PaginatedResponse<Application>?
>.internal(
  PendingApplications.new,
  name: r'pendingApplicationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingApplicationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PendingApplications =
    AutoDisposeAsyncNotifier<PaginatedResponse<Application>?>;
String _$acceptedApplicationsHash() =>
    r'281c2f5da922c05c7f27ea29e3a3b874f0885b9b';

/// See also [AcceptedApplications].
@ProviderFor(AcceptedApplications)
final acceptedApplicationsProvider = AutoDisposeAsyncNotifierProvider<
  AcceptedApplications,
  PaginatedResponse<Application>?
>.internal(
  AcceptedApplications.new,
  name: r'acceptedApplicationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$acceptedApplicationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AcceptedApplications =
    AutoDisposeAsyncNotifier<PaginatedResponse<Application>?>;
String _$rejectedApplicationsHash() =>
    r'861166796085555b4c8eeaf46f79d97be12faab4';

/// See also [RejectedApplications].
@ProviderFor(RejectedApplications)
final rejectedApplicationsProvider = AutoDisposeAsyncNotifierProvider<
  RejectedApplications,
  PaginatedResponse<Application>?
>.internal(
  RejectedApplications.new,
  name: r'rejectedApplicationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$rejectedApplicationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RejectedApplications =
    AutoDisposeAsyncNotifier<PaginatedResponse<Application>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
