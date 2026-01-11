import 'package:bolt/core/network/dio_provider.dart';
import 'package:bolt/features/memo/domain/notion_database.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// part 'notion_repository.g.dart';

class NotionRepository {
  final Dio _dio;

  NotionRepository(this._dio);

  /// Search for databases that the integration has access to.
  Future<List<NotionDatabase>> searchDatabases() async {
    try {
      final response = await _dio.post(
        '/search',
        data: {
          'filter': {'value': 'database', 'property': 'object'},
          'sort': {'direction': 'descending', 'timestamp': 'last_edited_time'},
        },
      );

      final results = response.data['results'] as List;
      return results.map((e) {
        final titleList = e['title'] as List?;
        String title = 'Untitled';
        if (titleList != null && titleList.isNotEmpty) {
          title = titleList[0]['plain_text'] ?? 'Untitled';
        }
        return NotionDatabase(id: e['id'], title: title);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search databases: $e');
    }
  }

  Future<Map<String, dynamic>> getDatabaseProperties(String databaseId) async {
    try {
      final response = await _dio.get('/databases/$databaseId');
      return response.data['properties'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch database properties: $e');
    }
  }

  Future<String> _fetchTitlePropertyName(String databaseId) async {
    try {
      final properties = await getDatabaseProperties(databaseId);
      for (final entry in properties.entries) {
        if (entry.value['type'] == 'title') {
          return entry.key;
        }
      }
      return 'Name'; // Fallback default
    } catch (e) {
      print('Error fetching database schema: $e');
      return 'Name'; // Fallback if fetch fails
    }
  }

  /// Create a page (memo) in the specified database.
  Future<void> createPage({
    required String databaseId,
    required String content,
    String? titlePropName,
    Map<String, dynamic>? additionalProperties,
  }) async {
    final titleKey = titlePropName ?? await _fetchTitlePropertyName(databaseId);

    final properties = <String, dynamic>{
      titleKey: {
        'title': [
          {
            'text': {'content': content},
          },
        ],
      },
    };

    if (additionalProperties != null) {
      properties.addAll(additionalProperties);
    }

    await _dio.post(
      '/pages',
      data: {
        'parent': {'database_id': databaseId},
        'properties': properties,
      },
    );
  }

  /// Update page properties
  Future<void> updatePageProperties({
    required String pageId,
    required Map<String, dynamic> properties,
  }) async {
    try {
      await _dio.patch('/pages/$pageId', data: {'properties': properties});
    } catch (e) {
      throw Exception('Failed to update page properties: $e');
    }
  }

  /// Archive (delete) a page
  Future<void> deletePage(String pageId) async {
    try {
      await _dio.patch('/pages/$pageId', data: {'archived': true});
    } catch (e) {
      throw Exception('Failed to delete (archive) page: $e');
    }
  }

  Future<void> restorePage(String pageId) async {
    try {
      await _dio.patch('/pages/$pageId', data: {'archived': false});
    } catch (e) {
      throw Exception('Failed to restore page: $e');
    }
  }

  /// Query a database to retrieve pages.
  Future<List<Map<String, dynamic>>> queryDatabase(String databaseId) async {
    try {
      final response = await _dio.post(
        '/databases/$databaseId/query',
        data: {
          'page_size': 100, // Limit for now
          // We can add sorts/filters here
          'sorts': [
            {'timestamp': 'last_edited_time', 'direction': 'descending'},
          ],
        },
      );

      return List<Map<String, dynamic>>.from(response.data['results']);
    } catch (e) {
      throw Exception('Failed to query database: $e');
    }
  }
}

final notionRepositoryProvider = Provider<NotionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NotionRepository(dio);
});
