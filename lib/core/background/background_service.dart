import 'package:bolt/core/network/dio_provider.dart';
import 'package:bolt/features/memo/data/database/database.dart';
import 'package:bolt/features/memo/data/memo_repository.dart';
import 'package:bolt/features/memo/data/notion/notion_repository.dart';
import 'package:bolt/features/memo/data/notion_sync_service.dart';

import 'package:workmanager/workmanager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Need to initialize dependencies manually since we are in a background isolate
    final container = ProviderContainer();

    // We can re-use NotionSyncService logic, but we need to construct it carefully
    // because Riverpod providers might depend on Flutter widgets or secure storage which has platform channel issues in bg
    // FlutterSecureStorage works in background on Android but needs careful handling.

    try {
      final dio = container.read(dioProvider);
      // We need a fresh database instance
      // Assuming AppDatabase can be opened in background
      final db = AppDatabase();
      final repository = MemoRepositoryImpl(db);
      final notionRepository = NotionRepository(dio);
      final service = NotionSyncService(notionRepository, repository);

      await service.syncPendingMemos();

      return Future.value(true);
    } catch (e) {
      print('Background Sync Failed: $e');
      return Future.value(false);
    } finally {
      container.dispose();
    }
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      "bolt.sync.periodic",
      "syncMemos",
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Future<void> triggerOneOffSync() async {
    await Workmanager().registerOneOffTask(
      "bolt.sync.oneoff.${DateTime.now().millisecondsSinceEpoch}",
      "syncMemos",
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
