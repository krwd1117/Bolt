import 'package:bolt/features/memo/presentation/memo_filter_controller.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoFilterBar extends ConsumerStatefulWidget {
  const MemoFilterBar({super.key});

  @override
  ConsumerState<MemoFilterBar> createState() => _MemoFilterBarState();
}

class _MemoFilterBarState extends ConsumerState<MemoFilterBar> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        // Clear search when collapsing
        _searchController.clear();
        ref.read(memoFilterControllerProvider.notifier).setSearchQuery('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final filterController = ref.read(memoFilterControllerProvider.notifier);
    final filterState = ref.watch(memoFilterControllerProvider);
    final hasSelectedDate = filterState.selectedDate != null;
    final availableTags = ref.watch(availableTagsProvider);

    // Keep expanded if there is text
    final isSearchActive =
        _isSearchExpanded || _searchController.text.isNotEmpty;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Collapsible Search Field
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSearchActive ? 200 : 48,
            curve: Curves.easeInOut,
            child: isSearchActive
                ? TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      filterController.setSearchQuery(value);
                    },
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: _toggleSearch,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      isDense: true,
                    ),
                    style: theme.textTheme.bodyMedium,
                    autofocus: true,
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _toggleSearch,
                    tooltip: l10n.searchHint,
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Vertical Divider
          Container(
            width: 1,
            height: 24,
            color: theme.dividerColor.withValues(alpha: 0.2),
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          const SizedBox(width: 12),

          // Date Filters
          _FilterChip(
            label: l10n.filterAll,
            isSelected:
                filterState.dateFilter == DateFilter.all && !hasSelectedDate,
            onSelected: (selected) {
              if (selected) {
                filterController.setDateFilter(DateFilter.all);
              }
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: l10n.filterToday,
            isSelected: filterState.dateFilter == DateFilter.today,
            onSelected: (selected) {
              if (selected) {
                filterController.setDateFilter(DateFilter.today);
              }
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: l10n.filterUpcoming,
            isSelected: filterState.dateFilter == DateFilter.upcoming,
            onSelected: (selected) {
              if (selected) {
                filterController.setDateFilter(DateFilter.upcoming);
              }
            },
          ),
          const SizedBox(width: 8),

          // Dynamic Tag Filters
          if (availableTags.isNotEmpty) ...[
            Container(
              width: 1,
              height: 24,
              color: theme.dividerColor.withValues(alpha: 0.2),
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
            const SizedBox(width: 12),
            ...availableTags.map((tag) {
              final isSelected = filterState.selectedTypes.contains(tag);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(
                  label: '#$tag',
                  isSelected: isSelected,
                  onSelected: (selected) {
                    filterController.toggleType(tag);
                  },
                ),
              );
            }),
          ],

          // Clear Filter
          if (filterState.dateFilter != DateFilter.all ||
              filterState.statusFilter != StatusFilter.all ||
              filterState.selectedTypes.isNotEmpty ||
              filterState.searchQuery.isNotEmpty ||
              hasSelectedDate)
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () {
                filterController.clearFilters();
                _searchController.clear();
                setState(() {
                  _isSearchExpanded = false;
                });
              },
              tooltip: l10n.clearFilters,
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: false,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Colors.transparent
              : theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
