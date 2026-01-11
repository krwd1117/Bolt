import 'package:bolt/features/memo/data/database/tables.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo.freezed.dart';

@freezed
sealed class Memo with _$Memo {
  const factory Memo({
    required int id,
    required String content,
    String? targetDbId,
    required DateTime createdAt,
    required SyncStatus status,
    required int retryCount,
    String? notionPageId,
    @Default(false) bool isDone,
    String? type,
    DateTime? dueDate,
  }) = _Memo;
}
