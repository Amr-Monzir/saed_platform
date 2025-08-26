import 'package:flutter/material.dart';
import 'package:rabt_mobile/constants/lookups.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/widgets/app_text_field.dart';

class BasicInfoStep extends StatelessWidget {
  const BasicInfoStep({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descController,
    required this.category,
    required this.frequency,
    required this.numberOfVolunteers,
    required this.onCategoryChanged,
    required this.onFrequencyChanged,
    required this.onVolunteersChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final String? category;
  final FrequencyType frequency;
  final int numberOfVolunteers;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<FrequencyType?> onFrequencyChanged;
  final ValueChanged<int?> onVolunteersChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: titleController,
              label: 'Title *',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: descController,
              label: 'Description *',
              maxLines: 4,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: category,
              items: kCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onCategoryChanged,
              decoration: const InputDecoration(labelText: 'Category *'),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<FrequencyType>(
              initialValue: frequency,
              items: FrequencyType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
              onChanged: onFrequencyChanged,
              decoration: const InputDecoration(labelText: 'Frequency *'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: numberOfVolunteers,
              items: List.generate(10, (i) => i + 1).map((e) => DropdownMenuItem(value: e, child: Text('$e volunteer${e > 1 ? 's' : ''}'))).toList(),
              onChanged: onVolunteersChanged,
              decoration: const InputDecoration(labelText: 'Number of Volunteers *'),
            ),
          ],
        ),
      ),
    );
  }
}
