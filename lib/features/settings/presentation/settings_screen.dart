import 'package:bolt/features/auth/presentation/auth_controller.dart';
import 'package:bolt/features/settings/presentation/database_selection_screen.dart';
import 'package:bolt/features/settings/presentation/property_mapping_screen.dart';
import 'package:bolt/features/settings/presentation/settings_controller.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final databasesAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, l10n.sectionNotionSync),
            _buildNotionSection(context, ref, databasesAsync, l10n),

            const SizedBox(height: 32),

            _buildSectionHeader(context, l10n.sectionAccount),
            _buildAccountSection(context, ref, l10n),

            const SizedBox(height: 32),
            Center(
              child: Text(
                '${l10n.labelVersion} 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNotionSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<dynamic>> databasesAsync,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Selected Database
          FutureBuilder<String?>(
            future: ref
                .read(settingsControllerProvider.notifier)
                .getSelectedDatabaseId(),
            builder: (context, snapshot) {
              final selectedId = snapshot.data;
              String subtitle = l10n.msgSelectDatabase;

              if (selectedId != null) {
                databasesAsync.maybeWhen(
                  data: (dbs) {
                    final found = dbs
                        .where((d) => d.id == selectedId)
                        .firstOrNull;
                    if (found != null) subtitle = found.title;
                  },
                  orElse: () {},
                );
              }

              return _buildSettingTile(
                context,
                icon: Icons.storage_rounded,
                title: l10n.labelDatabase,
                subtitle: subtitle,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DatabaseSelectionScreen(),
                    ),
                  ).then((_) {
                    // Force rebuild property mapping availability check?
                    // FutureBuilder will re-run when build runs, but we might need
                    // state changes to trigger rebuild.
                    // Ideally check riverpod state.
                  });
                },
              );
            },
          ),
          _buildDivider(context),
          // Property Mapping
          FutureBuilder<String?>(
            future: ref
                .read(settingsControllerProvider.notifier)
                .getSelectedDatabaseId(),
            builder: (context, snapshot) {
              final selectedId = snapshot.data;
              return _buildSettingTile(
                context,
                icon: Icons.tune_rounded,
                title: l10n.labelConfigureProperties,
                onTap: selectedId != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PropertyMappingScreen(databaseId: selectedId),
                          ),
                        );
                      }
                    : null,
                isLabel: selectedId == null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSettingTile(
            context,
            icon: Icons.logout_rounded,
            title: l10n.btnLogout,
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            onTap: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
    bool isLabel = false,
  }) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? theme.colorScheme.primary).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isEnabled
                      ? (iconColor ?? theme.colorScheme.primary)
                      : theme.disabledColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isEnabled
                            ? (textColor ?? theme.colorScheme.onSurface)
                            : theme.disabledColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isEnabled && !isLabel)
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56, // Align with text start
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    );
  }
}
