import 'package:bolt/features/memo/data/notion/notion_repository.dart';
import 'package:bolt/features/memo/domain/notion_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  static const _selectedDbKey = 'selected_notion_db_id';

  static const _propertyMappingPrefix = 'property_mapping_';

  @override
  FutureOr<List<NotionDatabase>> build() async {
    // Load databases
    final repo = ref.watch(notionRepositoryProvider);
    return repo.searchDatabases();
  }

  Future<void> selectDatabase(String dbId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedDbKey, dbId);
  }

  Future<String?> getSelectedDatabaseId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedDbKey);
  }

  Future<void> savePropertyMapping(
    String dbId,
    Map<String, String> mapping,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in mapping.entries) {
      await prefs.setString(
        '$_propertyMappingPrefix${dbId}_${entry.key}',
        entry.value,
      );
    }
  }

  Future<Map<String, String>> getPropertyMapping(String dbId) async {
    final prefs = await SharedPreferences.getInstance();
    final mapping = <String, String>{};
    final keys = [
      'title',
      'status',
      'date',
      'done',
      'type',
      'name',
      'done_date',
      'created_date',
    ];
    for (final key in keys) {
      final val = prefs.getString('$_propertyMappingPrefix${dbId}_$key');
      if (val != null) {
        mapping[key] = val;
      }
    }
    return mapping;
  }
}
