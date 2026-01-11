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
        _titleProp = mapping['title'] ?? _findPropByType(props, 'title');
        _statusProp =
            mapping['status'] ??
            _findPropByType(props, 'status') ??
            _findPropByType(props, 'select');
        _dateProp = mapping['date'] ?? _findPropByType(props, 'date');
        _doneProp = mapping['done'] ?? _findPropByType(props, 'checkbox');
        _typeProp =
            mapping['type'] ??
            _findPropByName(props, 'Type') ??
            _findPropByType(props, 'select');
        _nameProp =
            mapping['name'] ??
            _findPropByName(props, 'Name') ??
            _findPropByType(props, 'rich_text');

        _doneDateProp =
            mapping['done_date'] ??
            _findPropByName(props, 'Done Date') ??
            _findPropByName(props, 'Completed At'); // Heuristic

        _createdDateProp =
            mapping['created_date'] ??
            _findPropByName(props, 'Created Date') ??
            _findPropByType(props, 'created_time');
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

  String? _findPropByType(Map<String, dynamic> props, String type) {
    for (final entry in props.entries) {
      if (entry.value['type'] == type) return entry.key;
    }
    return null;
  }

  String? _findPropByName(Map<String, dynamic> props, String name) {
    if (props.containsKey(name)) return name;
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
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propStatus,
                      'status',
                      _statusProp,
                      (val) => setState(() => _statusProp = val),
                      icon: Icons.check_circle_outline,
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propDueDate,
                      'date',
                      _dateProp,
                      (val) => setState(() => _dateProp = val),
                      icon: Icons.calendar_today,
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propType,
                      'type',
                      _typeProp,
                      (val) => setState(() => _typeProp = val),
                      icon: Icons.category,
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propName,
                      'name',
                      _nameProp,
                      (val) => setState(() => _nameProp = val),
                      icon: Icons.text_fields,
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
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propDoneDate,
                      'done_date',
                      _doneDateProp,
                      (val) => setState(() => _doneDateProp = val),
                      icon: Icons.event_available,
                    ),
                    _buildDropdownItem(
                      context,
                      l10n.propCreatedDate,
                      'created_date',
                      _createdDateProp,
                      (val) => setState(() => _createdDateProp = val),
                      icon: Icons.access_time,
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
  }) {
    final options = _properties!.keys.toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
        dropdownColor: Theme.of(context).cardColor,
        value: options.contains(currentValue) ? currentValue : null,
        items: options.map((key) {
          final type = _properties![key]['type'];
          // Show icon based on type if fancy, or just text
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
