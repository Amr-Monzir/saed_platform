import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/constants/lookups.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';

class AdvertsFiltersSheet extends ConsumerWidget {
  const AdvertsFiltersSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(advertsFilterProvider);
    final ctrl = ref.read(advertsFilterProvider.notifier);

    final isOneOff = filters.frequency == FrequencyType.oneOff;
    final commitments = isOneOff ? kTimeCommitmentOneOff : kTimeCommitmentRecurring;

    return SafeArea(
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
                const DropdownMenuItem(value: null, child: Text('Any')),
                ...FrequencyType.values.map((x) => DropdownMenuItem(value: x, child: Text(x.displayName))),
              ],
              onChanged: (v) => ctrl.setFrequency(v),
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: filters.category,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any')),
                ...kCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))),
              ],
              onChanged: (v) => ctrl.setCategory(v),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TimeCommitment>(
              value: filters.timeCommitment,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any')),
                ...commitments.map((label) => DropdownMenuItem(value: TimeCommitment.values.byName(label), child: Text(label))),
              ],
              onChanged: (v) => ctrl.setTimeCommitment(v),
              decoration: const InputDecoration(labelText: 'Time commitment'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DayTimePeriod>(
              value: filters.timeOfDay,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any')),
                ...DayTimePeriod.values.map((x) => DropdownMenuItem(value: x, child: Text(x.displayName))),
              ],
              onChanged: (v) => ctrl.setTimeOfDay(v),
              decoration: const InputDecoration(labelText: 'Time of day'),
            ),
            const SizedBox(height: 12),
            Text('Skills', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  kSkills.map((s) {
                    final selected = filters.skills.contains(s);
                    return FilterChip(label: Text(s), selected: selected, onSelected: (_) => ctrl.toggleSkill(s));
                  }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Apply filters')),
            ),
          ],
        ),
      ),
    );
  }
}
