// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MemoItemsTable extends MemoItems
    with TableInfo<$MemoItemsTable, MemoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDbIdMeta = const VerificationMeta(
    'targetDbId',
  );
  @override
  late final GeneratedColumn<String> targetDbId = GeneratedColumn<String>(
    'target_db_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<SyncStatus>($MemoItemsTable.$converterstatus);
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    targetDbId,
    createdAt,
    status,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memo_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('target_db_id')) {
      context.handle(
        _targetDbIdMeta,
        targetDbId.isAcceptableOrUnknown(
          data['target_db_id']!,
          _targetDbIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      targetDbId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_db_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: $MemoItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $MemoItemsTable createAlias(String alias) {
    return $MemoItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, int, int> $converterstatus =
      const EnumIndexConverter<SyncStatus>(SyncStatus.values);
}

class MemoItem extends DataClass implements Insertable<MemoItem> {
  final int id;
  final String content;
  final String? targetDbId;
  final DateTime createdAt;
  final SyncStatus status;
  final int retryCount;
  const MemoItem({
    required this.id,
    required this.content,
    this.targetDbId,
    required this.createdAt,
    required this.status,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || targetDbId != null) {
      map['target_db_id'] = Variable<String>(targetDbId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['status'] = Variable<int>(
        $MemoItemsTable.$converterstatus.toSql(status),
      );
    }
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  MemoItemsCompanion toCompanion(bool nullToAbsent) {
    return MemoItemsCompanion(
      id: Value(id),
      content: Value(content),
      targetDbId: targetDbId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDbId),
      createdAt: Value(createdAt),
      status: Value(status),
      retryCount: Value(retryCount),
    );
  }

  factory MemoItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoItem(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      targetDbId: serializer.fromJson<String?>(json['targetDbId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: $MemoItemsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'targetDbId': serializer.toJson<String?>(targetDbId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<int>(
        $MemoItemsTable.$converterstatus.toJson(status),
      ),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  MemoItem copyWith({
    int? id,
    String? content,
    Value<String?> targetDbId = const Value.absent(),
    DateTime? createdAt,
    SyncStatus? status,
    int? retryCount,
  }) => MemoItem(
    id: id ?? this.id,
    content: content ?? this.content,
    targetDbId: targetDbId.present ? targetDbId.value : this.targetDbId,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
  );
  MemoItem copyWithCompanion(MemoItemsCompanion data) {
    return MemoItem(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      targetDbId: data.targetDbId.present
          ? data.targetDbId.value
          : this.targetDbId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoItem(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('targetDbId: $targetDbId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, targetDbId, createdAt, status, retryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoItem &&
          other.id == this.id &&
          other.content == this.content &&
          other.targetDbId == this.targetDbId &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.retryCount == this.retryCount);
}

class MemoItemsCompanion extends UpdateCompanion<MemoItem> {
  final Value<int> id;
  final Value<String> content;
  final Value<String?> targetDbId;
  final Value<DateTime> createdAt;
  final Value<SyncStatus> status;
  final Value<int> retryCount;
  const MemoItemsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.targetDbId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  MemoItemsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.targetDbId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
  }) : content = Value(content);
  static Insertable<MemoItem> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? targetDbId,
    Expression<DateTime>? createdAt,
    Expression<int>? status,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (targetDbId != null) 'target_db_id': targetDbId,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  MemoItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String?>? targetDbId,
    Value<DateTime>? createdAt,
    Value<SyncStatus>? status,
    Value<int>? retryCount,
  }) {
    return MemoItemsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      targetDbId: targetDbId ?? this.targetDbId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (targetDbId.present) {
      map['target_db_id'] = Variable<String>(targetDbId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $MemoItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoItemsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('targetDbId: $targetDbId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MemoItemsTable memoItems = $MemoItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [memoItems];
}

typedef $$MemoItemsTableCreateCompanionBuilder =
    MemoItemsCompanion Function({
      Value<int> id,
      required String content,
      Value<String?> targetDbId,
      Value<DateTime> createdAt,
      Value<SyncStatus> status,
      Value<int> retryCount,
    });
typedef $$MemoItemsTableUpdateCompanionBuilder =
    MemoItemsCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String?> targetDbId,
      Value<DateTime> createdAt,
      Value<SyncStatus> status,
      Value<int> retryCount,
    });

class $$MemoItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MemoItemsTable> {
  $$MemoItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetDbId => $composableBuilder(
    column: $table.targetDbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemoItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoItemsTable> {
  $$MemoItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetDbId => $composableBuilder(
    column: $table.targetDbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoItemsTable> {
  $$MemoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get targetDbId => $composableBuilder(
    column: $table.targetDbId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$MemoItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoItemsTable,
          MemoItem,
          $$MemoItemsTableFilterComposer,
          $$MemoItemsTableOrderingComposer,
          $$MemoItemsTableAnnotationComposer,
          $$MemoItemsTableCreateCompanionBuilder,
          $$MemoItemsTableUpdateCompanionBuilder,
          (MemoItem, BaseReferences<_$AppDatabase, $MemoItemsTable, MemoItem>),
          MemoItem,
          PrefetchHooks Function()
        > {
  $$MemoItemsTableTableManager(_$AppDatabase db, $MemoItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> targetDbId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<SyncStatus> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => MemoItemsCompanion(
                id: id,
                content: content,
                targetDbId: targetDbId,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<String?> targetDbId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<SyncStatus> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => MemoItemsCompanion.insert(
                id: id,
                content: content,
                targetDbId: targetDbId,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoItemsTable,
      MemoItem,
      $$MemoItemsTableFilterComposer,
      $$MemoItemsTableOrderingComposer,
      $$MemoItemsTableAnnotationComposer,
      $$MemoItemsTableCreateCompanionBuilder,
      $$MemoItemsTableUpdateCompanionBuilder,
      (MemoItem, BaseReferences<_$AppDatabase, $MemoItemsTable, MemoItem>),
      MemoItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MemoItemsTableTableManager get memoItems =>
      $$MemoItemsTableTableManager(_db, _db.memoItems);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'4db1c5efe1a73afafa926c6e91d12e49a68b1abc';
