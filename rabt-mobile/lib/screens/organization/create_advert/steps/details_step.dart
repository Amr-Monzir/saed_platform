import 'package:flutter/material.dart';
import 'package:rabt_mobile/models/enums.dart';

class DetailsStep extends StatelessWidget {
  const DetailsStep({
    super.key,
    required this.formKey,
    required this.frequency,
    // One-off fields
    required this.eventDateTime,
    required this.oneOffTimeCommitment,
    required this.applicationDeadline,
    required this.onEventDateTimeChanged,
    required this.onOneOffTimeCommitmentChanged,
    required this.onApplicationDeadlineChanged,
    // Recurring fields
    required this.recurrence,
    required this.recurringTimeCommitment,
    required this.duration,
    required this.specificDays,
    required this.onRecurrenceChanged,
    required this.onRecurringTimeCommitmentChanged,
    required this.onDurationChanged,
    required this.onDayPeriodToggled,
  });

  final GlobalKey<FormState> formKey;
  final FrequencyType frequency;
  
  // One-off fields
  final DateTime? eventDateTime;
  final TimeCommitment oneOffTimeCommitment;
  final DateTime? applicationDeadline;
  final ValueChanged<DateTime?> onEventDateTimeChanged;
  final ValueChanged<TimeCommitment?> onOneOffTimeCommitmentChanged;
  final ValueChanged<DateTime?> onApplicationDeadlineChanged;
  
  // Recurring fields
  final RecurrenceType recurrence;
  final TimeCommitment recurringTimeCommitment;
  final DurationType duration;
  final Map<String, List<DayTimePeriod>> specificDays;
  final ValueChanged<RecurrenceType?> onRecurrenceChanged;
  final ValueChanged<TimeCommitment?> onRecurringTimeCommitmentChanged;
  final ValueChanged<DurationType?> onDurationChanged;
  final Function(String day, DayTimePeriod period) onDayPeriodToggled;

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
              '${frequency.displayName} Event Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            if (frequency == FrequencyType.oneOff) ...[
              _buildOneOffDetails(context),
            ] else ...[
              _buildRecurringDetails(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOneOffDetails(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Event Date & Time: ${eventDateTime?.toString().split('.')[0] ?? 'Not set'}'),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectEventDateTime(context),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<TimeCommitment>(
          initialValue: oneOffTimeCommitment,
          items: TimeCommitment.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
          onChanged: onOneOffTimeCommitmentChanged,
          decoration: const InputDecoration(labelText: 'Time Commitment'),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text('Application Deadline: ${applicationDeadline?.toString().split(' ')[0] ?? 'Not set'}'),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectApplicationDeadline(context),
        ),
      ],
    );
  }

  Widget _buildRecurringDetails(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<RecurrenceType>(
          initialValue: recurrence,
          items: RecurrenceType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
          onChanged: onRecurrenceChanged,
          decoration: const InputDecoration(labelText: 'Recurrence'),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<TimeCommitment>(
          initialValue: recurringTimeCommitment,
          items: TimeCommitment.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
          onChanged: onRecurringTimeCommitmentChanged,
          decoration: const InputDecoration(labelText: 'Time Commitment per Session'),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<DurationType>(
          initialValue: duration,
          items: DurationType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
          onChanged: onDurationChanged,
          decoration: const InputDecoration(labelText: 'Duration'),
        ),
        const SizedBox(height: 16),
        const Text('Specific Days & Times:'),
        const SizedBox(height: 8),
        ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) {
          return ExpansionTile(
            title: Text(day),
            children: [
              Wrap(
                spacing: 8,
                children: DayTimePeriod.values.map((period) {
                  final isSelected = specificDays[day]?.contains(period) == true;
                  return FilterChip(
                    label: Text(period.displayName),
                    selected: isSelected,
                    onSelected: (v) => onDayPeriodToggled(day, period),
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }

  Future<void> _selectEventDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: eventDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && context.mounted) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onEventDateTimeChanged(dateTime);
      }
    }
  }

  Future<void> _selectApplicationDeadline(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: applicationDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      onApplicationDeadlineChanged(date);
    }
  }
}
