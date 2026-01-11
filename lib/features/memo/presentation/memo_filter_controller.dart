import 'package:bolt/features/memo/domain/memo.dart';
import 'package:bolt/features/memo/presentation/memo_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_filter_controller.freezed.dart';
part 'memo_filter_controller.g.dart';

enum DateFilter { all, today, upcoming, overdue, noDate }

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
    @Default({}) Set<String> selectedTypes,
  }) = _MemoFilterState;
}

@riverpod
class MemoFilterController extends _$MemoFilterController {
  @override
  MemoFilterState build() => const MemoFilterState();

  void setDateFilter(DateFilter filter) {
    state = state.copyWith(dateFilter: filter);
  }

  void toggleType(String type) {
    final current = state.selectedTypes;
    if (current.contains(type)) {
      state = state.copyWith(selectedTypes: current.difference({type}));
    } else {
      state = state.copyWith(selectedTypes: {...current, type});
    }
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
      return memos.where((memo) {
        // 1. Type Filter
        if (filter.selectedTypes.isNotEmpty) {
          if (memo.type == null || !filter.selectedTypes.contains(memo.type)) {
            return false;
          }
        }

        // 2. Date Filter
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
            // For overdue, usually we only care if it's NOT done, or just date?
            // "Overdue" implies past date. Let's strictly check date.
            return date.isBefore(today);
          default:
            return true;
        }
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}
