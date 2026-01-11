import 'package:drift/drift.dart';

enum SyncStatus { pending, syncing, failed, synced }

class MemoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get targetDbId => text().nullable()(); // Nullable initially if not selected
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get status => intEnum<SyncStatus>().withDefault(const Constant(0))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
