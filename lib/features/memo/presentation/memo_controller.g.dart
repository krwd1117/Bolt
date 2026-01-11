// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MemoController)
final memoControllerProvider = MemoControllerProvider._();

final class MemoControllerProvider
    extends $AsyncNotifierProvider<MemoController, List<Memo>> {
  MemoControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoControllerHash();

  @$internal
  @override
  MemoController create() => MemoController();
}

String _$memoControllerHash() => r'3dfd8e89d8f77d82139ec569aa18571fbb492458';

abstract class _$MemoController extends $AsyncNotifier<List<Memo>> {
  FutureOr<List<Memo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Memo>>, List<Memo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Memo>>, List<Memo>>,
              AsyncValue<List<Memo>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
