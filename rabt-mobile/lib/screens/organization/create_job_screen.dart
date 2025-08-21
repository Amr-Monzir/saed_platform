import 'package:flutter/material.dart';
import '../../constants/lookups.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';
import '../../state/jobs/jobs_repository.dart';
import '../../models/advert.dart';
import '../../models/enums.dart';
import '../../models/organizer.dart';
// import '../../state/auth/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  FrequencyType _frequency = FrequencyType.oneOff;
  String? _category;
  final Set<String> _skills = {};
  String? _timeCommitment;
  String? _timeOfDay;
  int? _distance;
  DateTime? _startDate;
  DateTime? _endDate;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Job')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppTextField(
              controller: _titleController,
              label: 'Title',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _frequency.name,
              items: FrequencyType.values.map((e) => DropdownMenuItem(value: e.name, child: Text(e.displayName))).toList(),
              onChanged: (v) => setState(() => _frequency = v == null ? FrequencyType.oneOff : FrequencyType.values.byName(v)),
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _category,
              items: kCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _category = v),
              decoration: const InputDecoration(labelText: 'Category'),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            const Text('Skills Required'),
            Wrap(
              spacing: 8,
              children:
                  kSkills.map((s) {
                    final selected = _skills.contains(s);
                    return FilterChip(
                      label: Text(s),
                      selected: selected,
                      onSelected:
                          (v) => setState(() {
                            if (v) {
                              _skills.add(s);
                            } else {
                              _skills.remove(s);
                            }
                          }),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _timeCommitment,
              items:
                  (_frequency == FrequencyType.oneOff ? kTimeCommitmentOneOff : kTimeCommitmentRecurring)
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (v) => setState(() => _timeCommitment = v),
              decoration: const InputDecoration(labelText: 'Time Commitment'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _timeOfDay,
              items: kTimesOfDay.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _timeOfDay = v),
              decoration: const InputDecoration(labelText: 'Time of Day'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _distance,
              items: kDistancesMiles.map((e) => DropdownMenuItem(value: e, child: Text('$e miles'))).toList(),
              onChanged: (v) => setState(() => _distance = v),
              decoration: const InputDecoration(labelText: 'Distance From User'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now.subtract(const Duration(days: 0)),
                        lastDate: now.add(const Duration(days: 365 * 2)),
                        initialDate: _startDate ?? now,
                      );
                      if (picked != null) setState(() => _startDate = picked);
                    },
                    child: Text('Start: ${_startDate == null ? 'Pick' : _startDate!.toLocal().toString().split(' ').first}'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now.subtract(const Duration(days: 0)),
                        lastDate: now.add(const Duration(days: 365 * 2)),
                        initialDate: _endDate ?? now,
                      );
                      if (picked != null) setState(() => _endDate = picked);
                    },
                    child: Text('End: ${_endDate == null ? 'Pick' : _endDate!.toLocal().toString().split(' ').first}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _descController,
              maxLines: 4,
              label: 'Description',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            AppButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                // Minimal create mirroring response shape for api
                final advert = AdvertResponse(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  category: _category ?? kCategories.first,
                  frequency: _frequency,
                  numberOfVolunteers: 1,
                  locationType: LocationType.onSite,
                  isActive: true,
                  organizer: OrganizerProfile(id: 1, name: 'Me'),
                  requiredSkills: const [],
                  oneoffDetails:
                      _frequency == FrequencyType.oneOff
                          ? OneOffAdvertDetails(
                            eventDatetime: _startDate ?? DateTime.now(),
                            timeCommitment: TimeCommitment.oneToTwo,
                            applicationDeadline: _endDate ?? DateTime.now().add(const Duration(days: 7)),
                          )
                          : null,
                  recurringDetails:
                      _frequency == FrequencyType.recurring
                          ? RecurringAdvertDetails(
                            recurrence: RecurrenceType.weekly,
                            timeCommitmentPerSession: TimeCommitment.oneToTwo,
                            duration: DurationType.oneMonth,
                            specificDays: [
                              RecurringDays(day: 'Monday', periods: [DayTimePeriod.am]),
                            ],
                          )
                          : null,
                  createdAt: DateTime.now(),
                );
                ref.read(advertsRepositoryProvider).create(advert);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job created')));
              },
              label: 'Create Job',
            ),
          ],
        ),
      ),
    );
  }
}
