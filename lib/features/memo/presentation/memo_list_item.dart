import 'dart:async';

import 'package:bolt/features/memo/data/database/tables.dart';
import 'package:bolt/features/memo/domain/memo.dart';
import 'package:flutter/material.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';

class MemoListItem extends StatefulWidget {
  final Memo memo;
  final Function(Memo) onToggle;
  final VoidCallback? onLongPress;

  const MemoListItem({
    super.key,
    required this.memo,
    required this.onToggle,
    this.onLongPress,
  });

  @override
  State<MemoListItem> createState() => _MemoListItemState();
}

class _MemoListItemState extends State<MemoListItem> {
  late bool _isDone;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _isDone = widget.memo.isDone;
  }

  @override
  void didUpdateWidget(MemoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.memo.isDone != oldWidget.memo.isDone) {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }
      _isDone = widget.memo.isDone;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleToggle() {
    setState(() {
      _isDone = !_isDone;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_isDone != widget.memo.isDone) {
        widget.onToggle(widget.memo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Use local state _isDone for UI rendering
    final isDone = _isDone;

    final backgroundColor = theme.cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: _handleToggle,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Custom Checkbox Area
                _buildCustomCheckbox(context, isDone),
                const SizedBox(width: 16),

                // Content Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.memo.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: theme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                          color: isDone
                              ? theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                )
                              : theme.colorScheme.onSurface,
                        ),
                      ),

                      // Metadata Row (Type, Date)
                      if (widget.memo.type != null ||
                          widget.memo.dueDate != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (widget.memo.type != null) ...[
                              _buildTag(context, widget.memo.type!),
                            ],

                            if (widget.memo.type != null &&
                                widget.memo.dueDate != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  '•',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                                    fontSize: 10,
                                  ),
                                ),
                              ),

                            if (widget.memo.dueDate != null) ...[
                              _buildDateBadge(
                                context,
                                widget.memo.dueDate!,
                                l10n,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Optional: Sync Indicator (Dot)
                if (widget.memo.status != SyncStatus.synced)
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCheckbox(BuildContext context, bool isDone) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isDone ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDone
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isDone ? 1.0 : 0.0,
        curve: Curves.easeOutBack,
        child: const Icon(Icons.check_rounded, size: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String type) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#',
            style: TextStyle(
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            type,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBadge(
    BuildContext context,
    DateTime date,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    // Determine if overdue or close
    final now = DateTime.now();
    final isPast = date.isBefore(
      DateTime(now.year, now.month, now.day),
    ); // Simple check
    // However, if we marked it done locally, urgency should disappear visually.
    final visualIsUrgent = isPast && !_isDone;

    final color = visualIsUrgent
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_today_rounded, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          _formatDate(date, l10n),
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final days = targetDate.difference(today).inDays;

    if (days == 0) {
      return l10n.dateToday;
    }

    if (days > 0) {
      // Future
      if (days == 1) return l10n.dateTomorrow;
      // "MM.DD" format for other future dates (e.g., "12월 01일까지")
      return l10n.dateUntil(
        date.month.toString(),
        date.day.toString().padLeft(2, '0'),
      );
    } else {
      // Past
      final pastDays = days.abs();
      if (pastDays < 7) {
        return l10n.dateDaysAgo(pastDays);
      }
    }

    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
