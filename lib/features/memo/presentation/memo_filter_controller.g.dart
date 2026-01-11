// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'3e1f81e01d1ff9e47b45d86affd7090b02d7993d';

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

String _$filteredMemosHash() => r'817bac4aa02832d8a194540ab9a18d59723694d2';
