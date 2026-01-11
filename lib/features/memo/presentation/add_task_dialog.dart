import 'package:bolt/features/memo/data/notion/notion_repository.dart';
import 'package:bolt/features/memo/presentation/memo_controller.dart';
import 'package:bolt/features/settings/presentation/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:bolt/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _nameController =
      TextEditingController(); // For 'Name' property if separate

  // Property values
  DateTime? _dateValue;
  String? _typeValue;

  bool _loading = true;
  String? _dbId;
  Map<String, dynamic>? _schema;
  Map<String, String>? _mapping;
  final Set<String> _renderedProperties = {};

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    final settingsNotifier = ref.read(settingsControllerProvider.notifier);
    _dbId = await settingsNotifier.getSelectedDatabaseId();
    if (_dbId != null) {
      try {
        final repo = ref.read(notionRepositoryProvider);
        _schema = await repo.getDatabaseProperties(_dbId!);
        _mapping = await settingsNotifier.getPropertyMapping(_dbId!);
      } catch (e) {
        print('Error loading metadata: $e');
      }
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle keyboard with bottom sheet
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (_dbId == null) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(l10n.msgNoDatabaseSelected),
      );
    }

    _renderedProperties.clear();
    // Register Title
    if (_mapping != null && _mapping!.containsKey('title')) {
      _renderedProperties.add(_mapping!['title']!);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        // mainAxisSize: MainAxisSize.min, // This is not a property of SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              l10n.addTaskTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: l10n.hintWhatNeedsToBeDone,
                hintText: l10n.addTaskHint,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 20),

            if (_shouldShowField('type')) _buildTypeDropdown(l10n),
            if (_shouldShowField('date')) _buildDatePicker(l10n),
            // Done checkbox removed as requested
            if (_shouldShowField('name')) _buildNameField(l10n),

            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => _saveTask(l10n),
                child: Text(l10n.btnCreateTask),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Track which Notion properties have been rendered to avoid duplicates
  // final Set<String> _renderedProperties = {}; // Moved to top

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No-op, just good practice if we used InheritedWidgets
  }

  bool _shouldShowField(String mapKey) {
    if (_mapping == null) return false;
    final propKey = _mapping![mapKey];
    if (propKey == null) return false;

    // Check if this property has already been rendered by a previous field
    if (_renderedProperties.contains(propKey)) {
      return false;
    }

    _renderedProperties.add(propKey);
    return true;
  }

  // Build method helper to reset tracker
  // void _resetRenderedProperties() { // Removed and integrated into build
  //   _renderedProperties.clear();
  //   // Register the Title property as it is always rendered at the top
  //   if (_mapping != null && _mapping!.containsKey('title')) {
  //     _renderedProperties.add(_mapping!['title']!);
  //   }
  // }

  Widget _buildTypeDropdown(AppLocalizations l10n) {
    return _buildSelectDropdown(
      l10n.labelType,
      _mapping!['type']!,
      _typeValue,
      (val) {
        setState(() => _typeValue = val);
      },
    );
  }

  Widget _buildSelectDropdown(
    String label,
    String propKey,
    String? groupValue,
    ValueChanged<String?> onChanged,
  ) {
    final propDef = _schema?[propKey];
    if (propDef == null) return const SizedBox.shrink();

    // Check if it's select or multi_select
    final type = propDef['type'];
    List<dynamic> options = [];
    if (type == 'select') {
      options = propDef['select']['options'] ?? [];
    } else if (type == 'multi_select') {
      options = propDef['multi_select']['options'] ?? [];
    }

    if (options.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: groupValue,
            isExpanded: true,
            isDense: true,
            items: options.map<DropdownMenuItem<String>>((opt) {
              return DropdownMenuItem(
                value: opt['name'],
                child: Text(opt['name']),
              );
            }).toList(),
            onChanged: onChanged,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: _dateValue ?? now,
            firstDate: now.subtract(const Duration(days: 365)),
            lastDate: now.add(const Duration(days: 365)),
          );
          if (picked != null) {
            setState(() => _dateValue = picked);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: l10n.labelDueDate,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            _dateValue == null
                ? l10n.labelSelectDate
                : _dateValue!.toIso8601String().split('T')[0],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: l10n.labelName,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _saveTask(AppLocalizations l10n) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final properties = <String, dynamic>{};

    if (_typeValue != null) properties['Type'] = _typeValue;
    if (_mapping != null && _mapping!.containsKey('date')) {
      final now = DateTime.now();
      final dateToSend = _dateValue ?? DateTime(now.year, now.month, now.day);
      properties['Date'] = dateToSend.toIso8601String();
    }
    // Done logic removed
    if (_nameController.text.isNotEmpty) {
      properties['Name'] = _nameController.text.trim();
    }

    Navigator.pop(context); // Close dialog

    try {
      await ref
          .read(memoControllerProvider.notifier)
          .addTask(content: title, properties: properties);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.msgTaskAdded)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.msgTaskFailed(e.toString()))),
        );
      }
    }
  }
}
