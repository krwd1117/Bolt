import 'package:bolt/features/memo/presentation/add_task_dialog.dart';
import 'package:bolt/features/memo/presentation/memo_controller.dart';
import 'package:bolt/features/memo/presentation/memo_filter_controller.dart';
import 'package:bolt/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';
import 'package:bolt/features/memo/presentation/widgets/memo_calendar.dart';
import 'package:bolt/features/memo/presentation/widgets/memo_filter_bar.dart';
import 'package:bolt/features/memo/presentation/widgets/memo_animated_sliver_list.dart';

class MemoScreen extends ConsumerWidget {
  const MemoScreen({super.key});

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noMemosFound,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToAdd,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                l10n.appTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              floating: true,
              pinned: true,
              actions: [
                // Refresh Button
                IconButton(
                  onPressed: () {
                    ref.invalidate(memoControllerProvider);
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
                  tooltip: 'Refresh',
                ),
                // Sort Button
                Consumer(
                  builder: (context, ref, child) {
                    final currentSort = ref.watch(
                      memoFilterControllerProvider.select((s) => s.sortOption),
                    );
                    return PopupMenuButton<SortOption>(
                      icon: Icon(
                        Icons.sort_rounded,
                        color: theme.colorScheme.onSurface,
                      ),
                      tooltip: 'Sort',
                      onSelected: (option) {
                        ref
                            .read(memoFilterControllerProvider.notifier)
                            .setSortOption(option);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: SortOption.dueDateNearest,
                          child: Row(
                            children: [
                              Icon(
                                currentSort == SortOption.dueDateNearest
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(l10n.sortByDueDateNearest),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: SortOption.dueDateFarthest,
                          child: Row(
                            children: [
                              Icon(
                                currentSort == SortOption.dueDateFarthest
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(l10n.sortByDueDateFarthest),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: SortOption.name,
                          child: Row(
                            children: [
                              Icon(
                                currentSort == SortOption.name
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(l10n.sortByName),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Calendar Toggle
                Consumer(
                  builder: (context, ref, child) {
                    final filter = ref.watch(memoFilterControllerProvider);
                    final isCalendarActive = filter.selectedDate != null;
                    return IconButton(
                      onPressed: () {
                        if (isCalendarActive) {
                          ref
                              .read(memoFilterControllerProvider.notifier)
                              .setSelectedDate(null);
                        } else {
                          ref
                              .read(memoFilterControllerProvider.notifier)
                              .setSelectedDate(DateTime.now());
                        }
                      },
                      icon: Icon(
                        isCalendarActive
                            ? Icons.calendar_month
                            : Icons.calendar_month_outlined,
                        color: isCalendarActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                      tooltip: l10n.calendarToggleTooltip,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () => const SettingsRoute().push(context),
                ),
                const SizedBox(width: 8),
              ],
            ),
            // Calendar Widget (Conditionally Visible)
            const SliverToBoxAdapter(child: MemoCalendar()),
          ];
        },
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Filter Bar
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    minHeight: 70,
                    maxHeight: 70,
                    child: const MemoFilterBar(),
                  ),
                  pinned: true,
                ),

                // Memo List
                // Memo List
                Consumer(
                  builder: (context, ref, child) {
                    final memoState = ref.watch(filteredMemosProvider);
                    if (memoState.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(context, l10n),
                      );
                    }

                    final todoMemos = memoState
                        .where((m) => !m.isDone)
                        .toList();
                    final doneMemos = memoState.where((m) => m.isDone).toList();

                    final hasBoth =
                        todoMemos.isNotEmpty && doneMemos.isNotEmpty;

                    return SliverMainAxisGroup(
                      slivers: [
                        MemoAnimatedSliverList(memos: todoMemos, ref: ref),

                        if (doneMemos.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (hasBoth) const Divider(height: 32),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    l10n.filterDone,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MemoAnimatedSliverList(memos: doneMemos, ref: ref),
                        ],
                      ],
                    );
                  },
                ),
                // Bottom Padding
                const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTaskSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
