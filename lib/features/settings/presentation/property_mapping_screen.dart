import 'package:bolt/features/memo/data/notion/notion_repository.dart';
import 'package:bolt/features/settings/presentation/settings_controller.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyMappingScreen extends ConsumerStatefulWidget {
  final String databaseId;

  const PropertyMappingScreen({super.key, required this.databaseId});

  @override
  ConsumerState<PropertyMappingScreen> createState() =>
      _PropertyMappingScreenState();
}

class _PropertyMappingScreenState extends ConsumerState<PropertyMappingScreen> {
  Map<String, dynamic>? _properties;
  bool _loading = true;

  // Selected property names
  String? _titleProp;
  String? _statusProp;
  String? _dateProp;
  String? _doneProp;
  String? _typeProp;
  String? _nameProp;
  String? _doneDateProp;
  String? _createdDateProp;

  @override
  void initState() {
    super.initState();
    _loadSchema();
  }

  Future<void> _loadSchema() async {
    try {
      final repo = ref.read(notionRepositoryProvider);
      final props = await repo.getDatabaseProperties(widget.databaseId);

      // Load existing mapping if any
      final mapping = await ref
          .read(settingsControllerProvider.notifier)
          .getPropertyMapping(widget.databaseId);

      setState(() {
        _properties = props;
        _loading = false;

        // Auto-select based on type or name matches, or load saved
        _titleProp =
            mapping['title'] ??
            _findBestMatch(props, ['title'], ['Name', 'Title', 'Topic']);

        _statusProp =
            mapping['status'] ??
            _findBestMatch(props, ['status', 'select'], ['Status', 'State']);

        _dateProp =
            mapping['date'] ??
            _findBestMatch(props, ['date'], ['Date', 'Due Date', 'When']);

        _doneProp =
            mapping['done'] ??
            _findBestMatch(props, ['checkbox'], ['Done', 'Completed', 'Check']);

        _typeProp =
            mapping['type'] ??
            _findBestMatch(
              props,
              ['select', 'multi_select'],
              ['Type', 'Category', 'Tag'],
            );

        _nameProp =
            mapping['name'] ??
            _findBestMatch(
              props,
              ['rich_text', 'title'],
              ['Name', 'Description', 'Subject'],
            );

        _doneDateProp =
            mapping['done_date'] ??
            _findBestMatch(
              props,
              ['date', 'last_edited_time', 'created_time'],
              ['Done Date', 'Completed At', 'Finished At'],
            );

        _createdDateProp =
            mapping['created_date'] ??
            _findBestMatch(
              props,
              ['created_time', 'date'],
              ['Created Time', 'Created At', 'Date Created'],
            );
      });
    } catch (e) {
      if (mounted) {
        // AppLocalizations might fail if context is not valid, but in async after initState,
        // if mounted, context should be good. But AppLocalizations.of(context) inside async method might be risky?
        // It's generally okay if context is mounted.
        final l10n = AppLocalizations.of(context);
        if (l10n != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.msgErrorLoadingProperties(e.toString())),
            ),
          );
        }
        setState(() => _loading = false);
      }
    }
  }

  String? _findBestMatch(
    Map<String, dynamic> props,
    List<String> preferredTypes,
    List<String> preferredNames,
  ) {
    // 1. Exact Name + Type Match (Highest Priority)
    for (final name in preferredNames) {
      if (props.containsKey(name)) {
        final type = props[name]['type'];
        if (preferredTypes.contains(type)) {
          return name;
        }
      }
    }

    // 2. Exact Name Match (if type matches one of preferred, or if no strict type checking needed but passed types suggest intent)
    // Actually, strict type compliance is often better. Let's look for Name match if type is acceptable.
    for (final name in preferredNames) {
      if (props.containsKey(name)) {
        final type = props[name]['type'];
        if (preferredTypes.contains(type)) {
          return name;
        }
      }
    }

    // 3. Exact Type Match (Iterate properties and find first matching type)
    // Preference order of types matters if multiple available.
    for (final type in preferredTypes) {
      for (final entry in props.entries) {
        if (entry.value['type'] == type) {
          // If we haven't matched by name, maybe this is it?
          // Check if this property name is NOT in our preferred names of OTHER properties to avoid stealing?
          // For simplicity, just return found type.
          return entry.key;
        }
      }
    }

    // 4. (Optional) Fuzzy Name Match? Leaving out for now.

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.labelConfigureProperties),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loading = true);
              _loadSchema();
            },
            tooltip: l10n.tooltipRefresh,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _properties == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.msgFailedToLoadProperties),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadSchema,
                    child: Text(l10n.btnRetry),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, l10n.sectionCoreProperties),
                  _buildCard(context, [
                    _buildDropdownItem(
                      context,
                      l10n.propTaskTitle,
                      'title',
                      _titleProp,
                      (val) => setState(() => _titleProp = val),
                      icon: Icons.title,
                      allowedTypes: ['title'],
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propStatus,
                      'status',
                      _statusProp,
                      (val) => setState(() => _statusProp = val),
                      icon: Icons.check_circle_outline,
                      allowedTypes: ['select', 'status'],
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propDueDate,
                      'date',
                      _dateProp,
                      (val) => setState(() => _dateProp = val),
                      icon: Icons.calendar_today,
                      allowedTypes: ['date'],
                    ),

                    _buildDropdownItem(
                      context,
                      l10n.propType,
                      'type',
                      _typeProp,
                      (val) => setState(() => _typeProp = val),
                      icon: Icons.category,
                      allowedTypes: ['select', 'multi_select'],
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propName,
                      'name',
                      _nameProp,
                      (val) => setState(() => _nameProp = val),
                      icon: Icons.text_fields,
                      allowedTypes: ['rich_text', 'title'],
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context,
                    l10n.sectionAutomationProperties,
                  ),
                  _buildCard(context, [
                    _buildDropdownItem(
                      context,
                      l10n.propDoneCheckbox,
                      'done',
                      _doneProp,
                      (val) => setState(() => _doneProp = val),
                      icon: Icons.check_box,
                      allowedTypes: ['checkbox'],
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propDoneDate,
                      'done_date',
                      _doneDateProp,
                      (val) => setState(() => _doneDateProp = val),
                      icon: Icons.event_available,
                      allowedTypes: [
                        'date',
                        'last_edited_time',
                        'created_time',
                      ],
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propCreatedDate,
                      'created_date',
                      _createdDateProp,
                      (val) => setState(() => _createdDateProp = val),
                      icon: Icons.access_time,
                      allowedTypes: ['created_time', 'date'],
                    ),
                  ]),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveMapping,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.btnSaveConfiguration),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: children),
    );
  }

  Widget _buildDropdownItem(
    BuildContext context,
    String label,
    String mapKey,
    String? currentValue,
    ValueChanged<String?> onChanged, {
    required IconData icon,
    List<String>? allowedTypes,
  }) {
    // Filter options based on allowedTypes
    final options = _properties!.entries
        .where(
          (entry) =>
              allowedTypes == null ||
              allowedTypes.contains(entry.value['type']),
        )
        .map((entry) => entry.key)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            dropdownColor: Theme.of(context).cardColor,
            value: options.contains(currentValue) ? currentValue : null,
            items: options.map((key) {
              final type = _properties![key]['type'];
              return DropdownMenuItem(
                value: key,
                child: Text(
                  '$key ($type)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down_rounded),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Future<void> _saveMapping() async {
    final mapping = <String, String>{};
    if (_titleProp != null) mapping['title'] = _titleProp!;
    if (_statusProp != null) mapping['status'] = _statusProp!;
    if (_dateProp != null) mapping['date'] = _dateProp!;
    if (_doneProp != null) mapping['done'] = _doneProp!;
    if (_typeProp != null) mapping['type'] = _typeProp!;
    if (_nameProp != null) mapping['name'] = _nameProp!;
    if (_doneDateProp != null) mapping['done_date'] = _doneDateProp!;

    if (_createdDateProp != null) mapping['created_date'] = _createdDateProp!;

    await ref
        .read(settingsControllerProvider.notifier)
        .savePropertyMapping(widget.databaseId, mapping);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.msgConfigurationSaved)));
      Navigator.pop(context); // Go back to Settings
    }
  }
}
