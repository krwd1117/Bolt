import 'package:bolt/features/memo/data/database/database.dart';
import 'package:bolt/features/memo/data/database/tables.dart';
import 'package:bolt/features/memo/domain/memo.dart';
import 'package:drift/drift.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_repository.g.dart';

abstract class MemoRepository {
  Future<int> addMemo(String content, {String? targetDbId});
  Future<List<Memo>> getPendingMemos();
  Future<void> updateMemoStatus(int id, SyncStatus status);
  Future<void> saveSyncedMemos(List<String> contents, String? databaseId);
  Stream<List<Memo>> watchMemos();
}

class MemoRepositoryImpl implements MemoRepository {
  final AppDatabase _db;

  MemoRepositoryImpl(this._db);

  Memo _mapToEntity(MemoItem item) {
    return Memo(
      id: item.id,
      content: item.content,
      targetDbId: item.targetDbId,
      createdAt: item.createdAt,
      status: item.status,
      retryCount: item.retryCount,
      type: null,
      dueDate: null,
    );
  }

  @override
  Future<int> addMemo(String content, {String? targetDbId}) {
    return _db
        .into(_db.memoItems)
        .insert(
          MemoItemsCompanion.insert(
            content: content,
            targetDbId: Value(targetDbId),
            status: const Value(SyncStatus.pending),
          ),
        );
  }

  @override
  Future<List<Memo>> getPendingMemos() async {
    final items = await (_db.select(
      _db.memoItems,
    )..where((t) => t.status.equalsValue(SyncStatus.pending))).get();
    return items.map(_mapToEntity).toList();
  }

  @override
  Future<void> updateMemoStatus(int id, SyncStatus status) {
    return (_db.update(_db.memoItems)..where((t) => t.id.equals(id))).write(
      MemoItemsCompanion(status: Value(status)),
    );
  }

  @override
  Future<void> saveSyncedMemos(
    List<String> contents,
    String? databaseId,
  ) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.memoItems,
        contents.map(
          (content) => MemoItemsCompanion.insert(
            content: content,
            targetDbId: Value(databaseId),
            status: const Value(SyncStatus.synced),
            // We rely on autoIncrement ID and default createdAt
          ),
        ),
      );
    });
  }

  @override
  Stream<List<Memo>> watchMemos() {
    return (_db.select(_db.memoItems)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((items) => items.map(_mapToEntity).toList());
  }
}

@riverpod
MemoRepository memoRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return MemoRepositoryImpl(db);
}
