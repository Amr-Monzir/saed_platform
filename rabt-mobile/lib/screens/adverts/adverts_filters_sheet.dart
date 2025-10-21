import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/constants/lookups.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/state/skills/skills_providers.dart';

class AdvertsFiltersSheet extends ConsumerStatefulWidget {
  const AdvertsFiltersSheet({super.key});

  @override
  ConsumerState<AdvertsFiltersSheet> createState() => _AdvertsFiltersSheetState();
}

class _AdvertsFiltersSheetState extends ConsumerState<AdvertsFiltersSheet> {
  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(advertsFilterProvider);
    final ctrl = ref.read(advertsFilterProvider.notifier);
    final skillsAsync = ref.watch(allSkillsProvider);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () {
                      ctrl.clear();
                    },
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<FrequencyType>(
                value: filters.frequency,
                items: [
                  const DropdownMenuItem(child: Text('Any')),
                  ...FrequencyType.values.map((x) => DropdownMenuItem(value: x, child: Text(x.displayName))),
                ],
                onChanged: ctrl.setFrequency,
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    filters.frequency == FrequencyType.recurring
                        ? Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DropdownButtonFormField<RecurrenceType>(
                            value: filters.recurrence,
                            items: [
                              const DropdownMenuItem(child: Text('Any')),
                              ...RecurrenceType.values.map((x) => DropdownMenuItem(value: x, child: Text(x.displayName))),
                            ],
                            onChanged: ctrl.setRecurrence,
                            decoration: const InputDecoration(labelText: 'Recurrence'),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
              DropdownButtonFormField<LocationType>(
                value: filters.locationType,
                items: [
                  const DropdownMenuItem(child: Text('Any')),
                  ...LocationType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))),
                ],
                onChanged: ctrl.setLocationType,
                decoration: const InputDecoration(labelText: 'Location Type'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: filters.category,
                items: [
                  const DropdownMenuItem(child: Text('Any')),
                  ...kCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))),
                ],
                onChanged: ctrl.setCategory,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TimeCommitment>(
                value: filters.timeCommitment,
                items: [
                  const DropdownMenuItem(child: Text('Any')),
                  ...TimeCommitment.values.map((x) => DropdownMenuItem(value: x, child: Text(x.displayName))),
                ],
                onChanged: ctrl.setTimeCommitment,
                decoration: const InputDecoration(labelText: 'Time commitment'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DayTimePeriod>(
                value: filters.timeOfDay,
                items: [
                  const DropdownMenuItem(child: Text('Any')),
                  ...DayTimePeriod.values.map((x) => DropdownMenuItem(value: x, child: Text(x.displayName))),
                ],
                onChanged: ctrl.setTimeOfDay,
                decoration: const InputDecoration(labelText: 'Time of day'),
              ),
              const SizedBox(height: 12),
              Text('Skills', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              skillsAsync.when(
                data:
                    (skills) => Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children:
                          skills.map((s) {
                            final selected = filters.skills.contains(s.name);
                            return FilterChip(
                              label: Text(s.name),
                              selected: selected,
                              onSelected: (_) => ctrl.toggleSkill(s.name),
                            );
                          }).toList(),
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading skills: $error'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Apply filters')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
