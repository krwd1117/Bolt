// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(availableTags)
final availableTagsProvider = AvailableTagsProvider._();

final class AvailableTagsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  AvailableTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableTagsHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return availableTags(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$availableTagsHash() => r'a8136e93e75aeacc2231ce7b56948eebaf1a6a07';

@ProviderFor(MemoFilterController)
final memoFilterControllerProvider = MemoFilterControllerProvider._();

final class MemoFilterControllerProvider
    extends $NotifierProvider<MemoFilterController, MemoFilterState> {
  MemoFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoFilterControllerHash();

  @$internal
  @override
  MemoFilterController create() => MemoFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoFilterState>(value),
    );
  }
}

String _$memoFilterControllerHash() =>
    r'3ebbf0cefdb772a8cb809278de4b52d3aa172150';

abstract class _$MemoFilterController extends $Notifier<MemoFilterState> {
  MemoFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MemoFilterState, MemoFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MemoFilterState, MemoFilterState>,
              MemoFilterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredMemos)
final filteredMemosProvider = FilteredMemosProvider._();

final class FilteredMemosProvider
    extends $FunctionalProvider<List<Memo>, List<Memo>, List<Memo>>
    with $Provider<List<Memo>> {
  FilteredMemosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMemosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMemosHash();

  @$internal
  @override
  $ProviderElement<List<Memo>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Memo> create(Ref ref) {
    return filteredMemos(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Memo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Memo>>(value),
    );
  }
}

String _$filteredMemosHash() => r'5e2cf19ad315843bd351cbae4e06c4aa7a441510';
