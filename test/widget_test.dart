import 'dart:async';

import 'package:bolt/features/auth/data/auth_repository.dart';
import 'package:bolt/features/memo/data/database/tables.dart';
import 'package:bolt/features/memo/data/memo_repository.dart';
import 'package:bolt/features/memo/domain/memo.dart';
import 'package:bolt/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class FakeAuthRepository implements AuthRepository {
  String? _token;

  @override
  Future<String?> getAccessToken() async => _token;

  @override
  Future<void> saveAccessToken(String token) async {
    _token = token;
  }

  @override
  Future<void> deleteAccessToken() async {
    _token = null;
  }

  @override
  Future<String> exchangeCodeForToken(String authCode) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return 'fake_token';
  }

  @override
  Uri getAuthorizationUrl() {
    return Uri.parse('https://example.com/auth');
  }
}

class FakeMemoRepository implements MemoRepository {
  final List<Memo> _items = [];
  final _controller = StreamController<List<Memo>>.broadcast();

  FakeMemoRepository() {
    _controller.add([]);
  }

  @override
  Future<int> addMemo(String content, {String? targetDbId}) async {
    final item = Memo(
      id: _items.length + 1,
      content: content,
      targetDbId: targetDbId,
      createdAt: DateTime.now(),
      status: SyncStatus.pending,
      retryCount: 0,
      type: null,
      dueDate: null,
    );
    _items.add(item);
    // Sort by createdAt desc
    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _controller.add(List.from(_items));
    return item.id;
  }

  @override
  Stream<List<Memo>> watchMemos() async* {
    yield List.from(_items);
    yield* _controller.stream;
  }

  @override
  Future<List<Memo>> getPendingMemos() async => _items;

  @override
  Future<void> updateMemoStatus(int id, SyncStatus status) async {
    final index = _items.indexWhere((m) => m.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(status: status);
      _controller.add(List.from(_items));
    }
  }

  @override
  Future<void> saveSyncedMemos(
    List<String> contents,
    String? databaseId,
  ) async {
    for (final content in contents) {
      final item = Memo(
        id: _items.length + 1,
        content: content,
        targetDbId: databaseId,
        createdAt: DateTime.now(),
        status: SyncStatus.synced,
        retryCount: 0,
        type: null,
        dueDate: null,
      );
      _items.add(item);
    }
    // Sort by createdAt desc
    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _controller.add(List.from(_items));
  }
}

void main() {
  testWidgets('Full Flow: Login -> Write Memo -> Save -> Verify List', (
    WidgetTester tester,
  ) async {
    final fakeMemoRepo = FakeMemoRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => FakeAuthRepository()),
          memoRepositoryProvider.overrideWith((ref) => fakeMemoRepo),
        ],
        child: const BoltApp(),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Login
    await tester.tap(find.text('Connect Notion'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // 2. Verify Memo Screen
    expect(find.text('Memo Screen'), findsNothing);
    expect(find.text('Bolt'), findsWidgets);
    expect(find.text('No memos yet. Write something!'), findsOneWidget);

    // 3. Write Memo
    await tester.enterText(find.byType(TextField), 'Hello Bolt');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // 4. Verify Saved
    await tester.pumpAndSettle();
    expect(find.text('Saved!'), findsOneWidget);
    expect(find.text('Hello Bolt'), findsOneWidget);
  });
}
