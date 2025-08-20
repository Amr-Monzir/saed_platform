import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/lookups.dart';
import '../../state/jobs/jobs_providers.dart';

class JobsFiltersBar extends ConsumerWidget {
  const JobsFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(jobsFilterProvider);
    final ctrl = ref.read(jobsFilterProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _DropdownChip<String>(
            label: 'Frequency',
            value: filters.frequency,
            items: kFrequencies,
            onChanged: ctrl.setFrequency,
          ),
          _DropdownChip<String>(
            label: 'Category',
            value: filters.category,
            items: kCategories,
            onChanged: ctrl.setCategory,
          ),
          _DropdownChip<String>(
            label: 'Time of day',
            value: filters.timeOfDay,
            items: kTimesOfDay,
            onChanged: ctrl.setTimeOfDay,
          ),
          _DropdownChip<int>(
            label: 'Distance',
            value: filters.distanceMiles,
            items: kDistancesMiles,
            onChanged: ctrl.setDistance,
            display: (v) => v == null ? 'Any' : '${v}mi',
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: ctrl.clear,
            icon: const Icon(Icons.filter_alt_off_outlined),
            label: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _DropdownChip<T> extends StatelessWidget {
  const _DropdownChip({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.display,
  });
  final String label;
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T?)? display;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InputChip(
        label: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            hint: Text(label),
            onChanged: onChanged,
            items: [
              DropdownMenuItem<T>(value: null, child: const Text('Any')),
              ...items.map((e) => DropdownMenuItem<T>(value: e, child: Text(display?.call(e) ?? e.toString()))),
            ],
          ),
        ),
      ),
    );
  }
}


