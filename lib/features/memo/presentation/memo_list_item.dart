import 'package:bolt/features/memo/data/database/tables.dart';
import 'package:bolt/features/memo/domain/memo.dart';
import 'package:flutter/material.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';

class MemoListItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDone = memo.isDone;

    // Subtle varying background for visual interest (optional, sticking to cardColor for consistency)
    final backgroundColor = theme.cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to detail/edit screen
          },
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Checkbox Area
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: _buildCustomCheckbox(context, isDone),
                ),
                const SizedBox(width: 16),

                // Content Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        memo.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: theme.colorScheme.onSurface
                              .withOpacity(0.3),
                          color: isDone
                              ? theme.colorScheme.onSurface.withOpacity(0.4)
                              : theme.colorScheme.onSurface,
                        ),
                      ),

                      // Metadata Row (Type, Date)
                      if (memo.type != null || memo.dueDate != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (memo.type != null) ...[
                              _buildTag(context, memo.type!),
                            ],

                            if (memo.type != null && memo.dueDate != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  '•',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.3),
                                    fontSize: 10,
                                  ),
                                ),
                              ),

                            if (memo.dueDate != null) ...[
                              _buildDateBadge(context, memo.dueDate!, l10n),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Optional: Sync Indicator (Dot)
                if (memo.status != SyncStatus.synced)
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withOpacity(0.5),
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

    return InkWell(
      onTap: () => onToggle(memo),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
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
                : theme.colorScheme.onSurface.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: isDone
            ? const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors
                    .black, // Primary is yellow, text/icon on it should be black
              )
            : null,
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
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#',
            style: TextStyle(
              color: theme.colorScheme.primary.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            type,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
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
    final isUrgent = isPast && !memo.isDone;

    final color = isUrgent
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface.withOpacity(0.6);

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
    final difference = date.difference(now);
    final days = difference.inDays;

    if (days == 0 && date.day == now.day) {
      return l10n.dateToday;
    }

    if (difference.isNegative) {
      // Past
      final pastDays = days.abs();
      if (pastDays < 7) {
        return l10n.dateDaysAgo(pastDays);
      }
    } else {
      // Future
      if (days == 1) return l10n.dateTomorrow;
      if (days < 7) return l10n.dateInDays(days);
    }

    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
