import 'package:bolt/features/memo/domain/memo.dart';
import 'package:bolt/features/memo/presentation/memo_controller.dart';
import 'package:bolt/features/memo/presentation/memo_list_item.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoAnimatedSliverList extends StatefulWidget {
  final List<Memo> memos;
  final WidgetRef
  ref; // Passed from parent since this might be deep in render tree, actually ConsumerStatefulWidget is better.

  const MemoAnimatedSliverList({
    super.key,
    required this.memos,
    required this.ref,
  });

  @override
  State<MemoAnimatedSliverList> createState() => _MemoAnimatedSliverListState();
}

class _MemoAnimatedSliverListState extends State<MemoAnimatedSliverList> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  late List<Memo> _items;
  final Set<int> _justDismissedIds = {};

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.memos);
  }

  @override
  void didUpdateWidget(MemoAnimatedSliverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateList(oldWidget.memos, widget.memos);
  }

  void _updateList(List<Memo> oldList, List<Memo> newList) {
    // We want to detect removals and insertions.
    // Simplifying assumption: Order is relatively stable, primary change is add/remove.
    // Complex diffing (Myer's algorithm) is overkill for this specific "move to done" toggle usecase,
    // but we need to handle index shifts correctly.

    // A simple strategy for this specific UX (Todo <-> Done):
    // Items are uniquely identified by ID.

    final newIds = newList.map((e) => e.id).toSet();

    // 1. Handle Removals
    // Iterate backwards to keep indices valid.
    for (int i = _items.length - 1; i >= 0; i--) {
      final item = _items[i];
      if (!newIds.contains(item.id)) {
        // Removed
        if (_justDismissedIds.contains(item.id)) {
          // If dismissed by user, it's already gone visually.
          // We remove it from internal list and notify AnimatedList to "remove" it without animation.
          _items.removeAt(i);
          _justDismissedIds.remove(item.id);
          _listKey.currentState?.removeItem(
            i,
            (context, animation) => const SizedBox.shrink(),
          );
        } else {
          final removedItem = item;
          _listKey.currentState?.removeItem(
            i,
            (context, animation) =>
                _buildRemovedItem(removedItem, context, animation),
            duration: const Duration(milliseconds: 300),
          );
          _items.removeAt(i);
        }
      }
    }

    // 2. Handle Insertions
    // We iterate through the NEW list. If an item is not in our current tracking list (_items), it's new.
    // But since _items matches the "visual" state (minus removed ones), we need to insert them at the correct positions.
    for (int i = 0; i < newList.length; i++) {
      final newItem = newList[i];
      // If current index is out of bounds (append) or item doesn't match
      if (i >= _items.length || _items[i].id != newItem.id) {
        // Check if it's strictly a new item (not just a reorder - though we treat reorder as Del/Add here implicitly if simplistic)
        // But wait, if we just skipped reorder check, we might get out of sync.
        // For "Todo <-> Done", reordering is rare unless the filtered list itself reorders.
        // Let's rely on the fact that we removed all "not in newIds" items.
        // So _items now ONLY contains items that SHOULD exist in newList.

        // If _items[i] exists but is different ID, it implies an insertion at this index (pushing existing down).
        _items.insert(i, newItem);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        // Update the data content for the existing item (e.g. content change, but not structural change)
        _items[i] = newItem;
      }
    }
  }

  Widget _buildRemovedItem(
    Memo memo,
    BuildContext context,
    Animation<double> animation,
  ) {
    // During removal, we build the item but wrapped in transition.
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: FadeTransition(opacity: animation, child: _buildItem(memo)),
    );
  }

  Widget _buildItem(Memo memo) {
    // Need l10n and ref logic
    // Since we are inside a State, we can access context.
    final l10n = AppLocalizations.of(context)!;

    // Logic copied from MemoScreen's _buildMemoItem
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey('${memo.id}_${memo.isDone}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 32),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
      ),
      onDismissed: (_) {
        // We trigger the delete action.
        // The Riverpod provider will update, causing a parent rebuild.
        // `didUpdateWidget` will be called with the new list (without this item).
        // `_updateList` will see it missing and trigger `removeItem`.
        // BUT `Dismissible` also removes it from the tree visually immediately.
        // If we duplicate the animation, it might glitch.
        // However, Dismissible usually requires the subtree to be removed.
        // Syncing Dismissible with AnimatedList is tricky.
        // Standard practice: Perform the mutation, and let AnimatedList react.
        // But Dismissible expects the widget to be removed from the tree by the time `onDismissed` returns/completes.

        _justDismissedIds.add(memo.id);
        widget.ref.read(memoControllerProvider.notifier).deleteTask(memo);

        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.msgTaskDeleted),
            action: SnackBarAction(
              label: l10n.actionUndo,
              onPressed: () {
                widget.ref
                    .read(memoControllerProvider.notifier)
                    .undoDeleteTask(memo);
              },
            ),
          ),
        );
      },
      child: MemoListItem(
        key: ValueKey('${memo.id}_${memo.isDone}'),
        memo: memo,
        onToggle: (m) =>
            widget.ref.read(memoControllerProvider.notifier).toggleDone(m),
        onLongPress: () => _showDeleteDialog(context, memo, l10n),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Memo memo,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.dialogDeleteTaskTitle),
        content: Text(l10n.dialogDeleteTaskContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.ref.read(memoControllerProvider.notifier).deleteTask(memo);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.msgTaskDeleted)));
            },
            child: Text(
              l10n.actionDelete,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        if (index >= _items.length) return const SizedBox.shrink();
        final memo = _items[index];
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(opacity: animation, child: _buildItem(memo)),
        );
      },
    );
  }
}
