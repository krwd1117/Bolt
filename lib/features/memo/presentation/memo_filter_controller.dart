import 'package:bolt/features/memo/domain/memo.dart';
import 'package:bolt/features/memo/presentation/memo_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_filter_controller.freezed.dart';
part 'memo_filter_controller.g.dart';

enum DateFilter { all, today, upcoming, overdue, noDate }

enum StatusFilter { all, todo, done }

enum SortOption { name, dueDateNearest, dueDateFarthest }

extension DateFilterExt on DateFilter {
  String get label {
    switch (this) {
      case DateFilter.all:
        return 'All';
      case DateFilter.today:
        return 'Today';
      case DateFilter.upcoming:
        return 'Upcoming';
      case DateFilter.overdue:
        return 'Overdue';
      case DateFilter.noDate:
        return 'No Date';
    }
  }
}

@freezed
sealed class MemoFilterState with _$MemoFilterState {
  const factory MemoFilterState({
    @Default(DateFilter.all) DateFilter dateFilter,
    @Default(StatusFilter.all) StatusFilter statusFilter,
    DateTime? selectedDate, // Custom date filter
    @Default('') String searchQuery,
    @Default({}) Set<String> selectedTypes,
    @Default(SortOption.dueDateNearest) SortOption sortOption,
  }) = _MemoFilterState;
}

@riverpod
List<String> availableTags(Ref ref) {
  final memosAsync = ref.watch(memoControllerProvider);
  return memosAsync.maybeWhen(
    data: (memos) {
      final tags = <String>{};
      for (final memo in memos) {
        if (memo.type != null && memo.type!.isNotEmpty) {
          tags.add(memo.type!);
        }
      }
      return tags.toList()..sort();
    },
    orElse: () => [],
  );
}

@riverpod
class MemoFilterController extends _$MemoFilterController {
  @override
  MemoFilterState build() => const MemoFilterState();

  void setDateFilter(DateFilter filter) {
    // If setting a preset, clear custom date
    state = state.copyWith(dateFilter: filter, selectedDate: null);
  }

  void setStatusFilter(StatusFilter filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void setSelectedDate(DateTime? date) {
    if (date == null) {
      // If clearing date, go back to All (or keep current if it wasn't custom?)
      // Let's explicitly set to all when clearing custom logic
      state = state.copyWith(selectedDate: null, dateFilter: DateFilter.all);
    } else {
      // If setting a specific date, specific logic applies
      // Use 'all' as base enum but selectedDate will override in logic
      state = state.copyWith(selectedDate: date, dateFilter: DateFilter.all);
    }
  }

  void toggleType(String type) {
    final current = state.selectedTypes;
    if (current.contains(type)) {
      state = state.copyWith(selectedTypes: current.difference({type}));
    } else {
      state = state.copyWith(selectedTypes: {...current, type});
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void clearFilters() {
    state = const MemoFilterState();
  }
}

@riverpod
List<Memo> filteredMemos(Ref ref) {
  final memosAsync = ref.watch(memoControllerProvider);
  final filter = ref.watch(memoFilterControllerProvider);

  return memosAsync.when(
    data: (memos) {
      var filtered = memos.where((memo) {
        // 0. Search Filter
        if (filter.searchQuery.isNotEmpty) {
          if (!memo.content.toLowerCase().contains(
            filter.searchQuery.toLowerCase(),
          )) {
            return false;
          }
        }

        // 1. Type Filter
        if (filter.selectedTypes.isNotEmpty) {
          if (memo.type == null || !filter.selectedTypes.contains(memo.type)) {
            return false;
          }
        }

        // 2. Status Filter
        if (filter.statusFilter != StatusFilter.all) {
          if (filter.statusFilter == StatusFilter.todo && memo.isDone) {
            return false;
          }
          if (filter.statusFilter == StatusFilter.done && !memo.isDone) {
            return false;
          }
        }

        // 3. Custom Date Filter (Overrides presets)
        if (filter.selectedDate != null) {
          if (memo.dueDate == null) return false;
          final selected = DateTime(
            filter.selectedDate!.year,
            filter.selectedDate!.month,
            filter.selectedDate!.day,
          );
          final date = DateTime(
            memo.dueDate!.year,
            memo.dueDate!.month,
            memo.dueDate!.day,
          );
          // Exact match for calendar selection
          return date.isAtSameMomentAs(selected);
        }

        // 4. Preset Date Filters
        if (filter.dateFilter == DateFilter.all) return true;

        if (memo.dueDate == null) {
          return filter.dateFilter == DateFilter.noDate;
        }

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final date = DateTime(
          memo.dueDate!.year,
          memo.dueDate!.month,
          memo.dueDate!.day,
        );

        switch (filter.dateFilter) {
          case DateFilter.today:
            return date.isAtSameMomentAs(today);
          case DateFilter.upcoming:
            return date.isAfter(today);
          case DateFilter.overdue:
            return date.isBefore(today) && !memo.isDone;
          default:
            return true;
        }
      }).toList();

      // Apply sorting
      switch (filter.sortOption) {
        case SortOption.name:
          filtered.sort((a, b) => a.content.compareTo(b.content));
          break;
        case SortOption.dueDateNearest:
          filtered.sort((a, b) {
            // Null dates go to the end
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });
          break;
        case SortOption.dueDateFarthest:
          filtered.sort((a, b) {
            // Null dates go to the end
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return b.dueDate!.compareTo(a.dueDate!);
          });
          break;
      }

      return filtered;
    },
    loading: () => [],
    error: (_, _) => [],
  );
}
