import 'package:bolt/features/memo/data/database/tables.dart';
import 'package:bolt/features/memo/data/memo_repository.dart';
import 'package:bolt/features/memo/data/notion/notion_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// part 'notion_sync_service.g.dart';

class NotionSyncService {
  final NotionRepository _notionRepository;
  final MemoRepository _memoRepository;

  NotionSyncService(this._notionRepository, this._memoRepository);

  // TODO: This should be retrieved from user settings in the future
  static const _defaultDatabaseId = 'YOUR_NOTION_DATABASE_ID';

  Future<void> syncPendingMemos() async {
    final pendingMemos = await _memoRepository.getPendingMemos();

    if (pendingMemos.isEmpty) return;

    for (final memo in pendingMemos) {
      // Mark as syncing
      await _memoRepository.updateMemoStatus(memo.id, SyncStatus.syncing);

      try {
        final databaseId = memo.targetDbId ?? _defaultDatabaseId;

        await _notionRepository.createPage(
          databaseId: databaseId,
          content: memo.content,
        );

        // Success
        await _memoRepository.updateMemoStatus(memo.id, SyncStatus.synced);
      } catch (e) {
        // Failed
        print('Sync failed for memo ${memo.id}: $e');
        await _memoRepository.updateMemoStatus(memo.id, SyncStatus.failed);
      }
    }
  }

  Future<void> importFromNotion(String databaseId) async {
    try {
      final pages = await _notionRepository.queryDatabase(databaseId);

      final contents = <String>[];
      for (final page in pages) {
        final properties = page['properties'] as Map<String, dynamic>;

        // Find property of type 'title'
        String? titleContent;
        for (final propValue in properties.values) {
          if (propValue['type'] == 'title') {
            final titleList = propValue['title'] as List?;
            if (titleList != null && titleList.isNotEmpty) {
              titleContent = titleList[0]['plain_text']; // simplistic
              // Concatenate if multiple chunks? Notion rich text is a list.
              titleContent = titleList.map((t) => t['plain_text']).join('');
            }
            break; // Found the title property
          }
        }

        if (titleContent != null && titleContent.isNotEmpty) {
          contents.add(titleContent);
        }
      }

      if (contents.isNotEmpty) {
        // Reverse to keep order somewhat logical if needed, or just insert.
        // Notion query returns desc by last_edited.
        await _memoRepository.saveSyncedMemos(contents, databaseId);
      }
    } catch (e) {
      print('Import failed: $e');
      throw e; // Rethrow to let UI show error
    }
  }
}

final notionSyncServiceProvider = Provider<NotionSyncService>((ref) {
  final notionRepo = ref.watch(notionRepositoryProvider);
  final memoRepo = ref.watch(memoRepositoryProvider);
  return NotionSyncService(notionRepo, memoRepo);
});
