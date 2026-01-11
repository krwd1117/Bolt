// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memoRepository)
final memoRepositoryProvider = MemoRepositoryProvider._();

final class MemoRepositoryProvider
    extends $FunctionalProvider<MemoRepository, MemoRepository, MemoRepository>
    with $Provider<MemoRepository> {
  MemoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MemoRepository create(Ref ref) {
    return memoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoRepository>(value),
    );
  }
}

String _$memoRepositoryHash() => r'faf0a2a816965b59ddffe57234f65eef78196dc3';
