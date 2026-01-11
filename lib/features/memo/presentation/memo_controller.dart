import 'package:bolt/features/memo/data/database/tables.dart';
import 'package:bolt/features/memo/data/notion/notion_repository.dart';
import 'package:bolt/features/memo/domain/memo.dart';
import 'package:bolt/features/settings/presentation/settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_controller.g.dart';

@riverpod
class MemoController extends _$MemoController {
  @override
  FutureOr<List<Memo>> build() async {
    final settingsNotifier = ref.watch(settingsControllerProvider.notifier);
    final dbId = await settingsNotifier.getSelectedDatabaseId();

    if (dbId == null) {
      return [];
    }

    return await _fetchMemos(dbId);
  }

  Future<void> addTask({
    required String content,
    Map<String, dynamic>? properties, // New: additional properties
  }) async {
    if (content.trim().isEmpty) return;

    final settingsNotifier = ref.read(settingsControllerProvider.notifier);
    final dbId = await settingsNotifier.getSelectedDatabaseId();
    if (dbId == null) throw Exception('No database selected');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final notionRepo = ref.read(notionRepositoryProvider);

      // Get property mapping
      final mapping = await settingsNotifier.getPropertyMapping(dbId);
      final titleKey = mapping['title'];

      // Prepare additional properties based on mapping
      final additionalProps = <String, dynamic>{};
      if (properties != null) {
        // Map 'status', 'date', 'done', 'type', 'name'
        if (properties.containsKey('Status') && mapping['status'] != null) {
          additionalProps[mapping['status']!] = {
            'select': {'name': properties['Status']},
          };
        }
        if (properties.containsKey('Date') && mapping['date'] != null) {
          additionalProps[mapping['date']!] = {
            'date': {'start': properties['Date']},
          };
        }
        if (properties.containsKey('Done') && mapping['done'] != null) {
          additionalProps[mapping['done']!] = {'checkbox': properties['Done']};
        }
        if (properties.containsKey('Type') && mapping['type'] != null) {
          additionalProps[mapping['type']!] = {
            'select': {'name': properties['Type']},
          };
        }
        if (properties.containsKey('Name') &&
            mapping['name'] != null &&
            mapping['name'] != titleKey) {
          // If User mapped 'Name' to a Text property different from Title
          additionalProps[mapping['name']!] = {
            'rich_text': [
              {
                'text': {'content': properties['Name']},
              },
            ],
          };
        }
      }

      // Add Created Date to payload if mapped
      if (mapping['created_date'] != null) {
        additionalProps[mapping['created_date']!] = {
          'date': {'start': DateTime.now().toIso8601String()},
        };
      }

      await notionRepo.createPage(
        databaseId: dbId,
        content: content,
        titlePropName: titleKey,
        additionalProperties: additionalProps,
      );

      return await _fetchMemos(dbId);
    });
  }

  // Helper to re-use fetch logic if needed, or just let build handle it by ref.invalidateSelf().
  // Actually, simplest is to just invalidate self or re-run the build logic.
  // But since we are inside AsyncValue.guard, we need to return the new state value.
  Future<void> toggleDone(Memo memo) async {
    if (memo.notionPageId == null) return;

    final settingsNotifier = ref.read(settingsControllerProvider.notifier);
    final dbId = memo.targetDbId;
    if (dbId == null) return;

    // Optimistic update
    final previousState = state;
    final newState = previousState.value?.map((m) {
      if (m.id == memo.id) {
        return m.copyWith(isDone: !m.isDone);
      }
      return m;
    }).toList();
    state = AsyncData(newState ?? []);

    // Prepare for update
    final notionRepo = ref.read(notionRepositoryProvider);
    Map<String, dynamic> mapping;
    try {
      mapping = await settingsNotifier.getPropertyMapping(dbId);
    } catch (e) {
      state = previousState;
      return;
    }

    final doneKey = mapping['done'];
    final doneDateKey = mapping['done_date'];

    final newDoneState = !memo.isDone;
    final properties = <String, dynamic>{};

    if (doneKey != null) {
      properties[doneKey] = {'checkbox': newDoneState};
    }

    if (doneDateKey != null) {
      properties[doneDateKey] = newDoneState
          ? {
              'date': {'start': DateTime.now().toIso8601String()},
            }
          : null;
    }

    try {
      if (properties.isNotEmpty) {
        await notionRepo.updatePageProperties(
          pageId: memo.notionPageId!,
          properties: properties,
        );
      }
    } catch (e) {
      // Retry logic: If unchecking failed (likely due to read-only/invalid Date property clearing),
      // try to update ONLY the checkbox status.
      // This handles cases where 'Done Date' is mapped to a non-writable property (e.g. Last Edited Time).
      if (!newDoneState &&
          doneDateKey != null &&
          properties.containsKey(doneDateKey)) {
        properties.remove(doneDateKey);
        if (properties.isNotEmpty) {
          try {
            await notionRepo.updatePageProperties(
              pageId: memo.notionPageId!,
              properties: properties,
            );
            return; // Success on retry
          } catch (retryError) {
            // Retry failed, proceed to revert
          }
        }
      }

      // Revert if failed
      state = previousState;
      rethrow;
    }
  }

  Future<void> deleteTask(Memo memo) async {
    if (memo.notionPageId == null) return;

    final previousState = state;
    // Optimistic delete
    state = AsyncData(
      previousState.value?.where((m) => m.id != memo.id).toList() ?? [],
    );

    try {
      final notionRepo = ref.read(notionRepositoryProvider);
      await notionRepo.deletePage(memo.notionPageId!);
    } catch (e) {
      // Revert
      state = previousState;
      rethrow;
    }
  }

  Future<List<Memo>> _fetchMemos(String dbId) async {
    final notionRepo = ref.read(notionRepositoryProvider);
    final settingsNotifier = ref.read(settingsControllerProvider.notifier);
    final mapping = await settingsNotifier.getPropertyMapping(dbId);

    final pages = await notionRepo.queryDatabase(dbId);

    final doneKey = mapping['done'];

    return pages.map((page) {
      final properties = page['properties'] as Map<String, dynamic>;
      String content = 'Untitled';
      bool isDone = false;

      // Extract Title
      for (final propValue in properties.values) {
        if (propValue['type'] == 'title') {
          final titleList = propValue['title'] as List?;
          if (titleList != null && titleList.isNotEmpty) {
            content = titleList.map((t) => t['plain_text']).join('');
          }
          break;
        }
      }

      // Extract Done status if mapped
      if (doneKey != null && properties.containsKey(doneKey)) {
        final doneProp = properties[doneKey];
        if (doneProp['type'] == 'checkbox') {
          isDone = doneProp['checkbox'] == true;
        }
      }

      // Extract Type
      String? type;
      final typeKey = mapping['type'];
      if (typeKey != null && properties.containsKey(typeKey)) {
        final typeProp = properties[typeKey];
        if (typeProp['type'] == 'select') {
          type = typeProp['select']?['name'];
        }
      }

      // Extract Due Date
      DateTime? dueDate;
      final dateKey = mapping['date'];
      if (dateKey != null && properties.containsKey(dateKey)) {
        final dateProp = properties[dateKey];
        if (dateProp['type'] == 'date') {
          final start = dateProp['date']?['start'];
          if (start != null) {
            dueDate = DateTime.tryParse(start);
          }
        }
      }

      return Memo(
        id: (page['id'] as String).hashCode,
        content: content,
        createdAt:
            DateTime.tryParse(page['created_time'] ?? '') ?? DateTime.now(),
        status: SyncStatus.synced,
        retryCount: 0,
        targetDbId: dbId,
        notionPageId: page['id'],
        isDone: isDone,
        type: type,
        dueDate: dueDate,
      );
    }).toList();
  }
}
