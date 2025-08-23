import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/constants/lookups.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/adverts/adverts_repository.dart';

class AdvertsFiltersBar extends ConsumerWidget {
  const AdvertsFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(advertsFilterProvider);
    final ctrl = ref.read(advertsFilterProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _DropdownChip<FrequencyType>(
            label: 'Frequency',
            value: filters.frequency,
            items: FrequencyType.values,
            onChanged: ctrl.setFrequency,
            display: (v) => v == null ? 'Any' : v.displayName,
          ),
          _DropdownChip<String>(label: 'Category', value: filters.category, items: kCategories, onChanged: ctrl.setCategory),
          _DropdownChip<DayTimePeriod>(
            label: 'Time of day',
            value: filters.timeOfDay,
            items: DayTimePeriod.values,
            onChanged: ctrl.setTimeOfDay,
            display: (v) => v == null ? 'Any' : v.displayName,
          ),
          _DropdownChip<int>(
            label: 'Distance',
            value: filters.distanceMiles,
            items: kDistancesMiles,
            onChanged: ctrl.setDistance,
            display: (v) => v == null ? 'Any' : '${v}mi',
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: ctrl.clear, icon: const Icon(Icons.filter_alt_off_outlined), label: const Text('Clear')),
        ],
      ),
    );
  }
}

class _DropdownChip<T> extends StatelessWidget {
  const _DropdownChip({required this.label, required this.value, required this.items, required this.onChanged, this.display});
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
