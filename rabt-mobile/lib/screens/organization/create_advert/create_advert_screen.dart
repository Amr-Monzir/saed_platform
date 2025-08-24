import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:rabt_mobile/constants/lookups.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/models/organizer.dart';
import 'package:rabt_mobile/models/skill.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_text_field.dart';
import '../../../services/image_upload_service.dart';

class CreateAdvertScreen extends ConsumerStatefulWidget {
  const CreateAdvertScreen({super.key});

  static const String path = '/o/create-advert';

  @override
  ConsumerState<CreateAdvertScreen> createState() => _CreateAdvertScreenState();
}

class _CreateAdvertScreenState extends ConsumerState<CreateAdvertScreen> {
  final _formKey = GlobalKey<FormState>();
  FrequencyType _frequency = FrequencyType.oneOff;
  String? _category;
  final Set<String> _skills = {};
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _addressController = TextEditingController();
  final _postcodeController = TextEditingController();
  File? _selectedImage;
  
  // Required fields
  int _numberOfVolunteers = 1;
  LocationType _locationType = LocationType.onSite;
  
  // One-off specific fields
  DateTime? _eventDateTime;
  TimeCommitment _oneOffTimeCommitment = TimeCommitment.oneToTwo;
  DateTime? _applicationDeadline;
  
  // Recurring specific fields
  RecurrenceType _recurrence = RecurrenceType.weekly;
  TimeCommitment _recurringTimeCommitment = TimeCommitment.oneToTwo;
  DurationType _duration = DurationType.oneMonth;
  final Map<String, List<DayTimePeriod>> _specificDays = {};

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({bool fromCamera = false}) async {
    final image = await ref.read(imageUploadServiceProvider).pickImage(fromCamera: fromCamera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _toggleDayPeriod(String day, DayTimePeriod period) {
    setState(() {
      if (_specificDays[day]?.contains(period) == true) {
        _specificDays[day]!.remove(period);
        if (_specificDays[day]!.isEmpty) {
          _specificDays.remove(day);
        }
      } else {
        _specificDays.putIfAbsent(day, () => []).add(period);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final createAdvertState = ref.watch(createAdvertControllerProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Create Advert')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image selection section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advert Image (Optional)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImage != null)
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(fromCamera: false),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(fromCamera: true),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Basic Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _titleController,
                      label: 'Title *',
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _descController,
                      label: 'Description *',
                      maxLines: 4,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _category,
                      items: kCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _category = v),
                      decoration: const InputDecoration(labelText: 'Category *'),
                      validator: (v) => v == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<FrequencyType>(
                      value: _frequency,
                      items: FrequencyType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
                      onChanged: (v) => setState(() => _frequency = v ?? FrequencyType.oneOff),
                      decoration: const InputDecoration(labelText: 'Frequency *'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _numberOfVolunteers,
                      items: List.generate(10, (i) => i + 1).map((e) => DropdownMenuItem(value: e, child: Text('$e volunteer${e > 1 ? 's' : ''}'))).toList(),
                      onChanged: (v) => setState(() => _numberOfVolunteers = v ?? 1),
                      decoration: const InputDecoration(labelText: 'Number of Volunteers *'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Location Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<LocationType>(
                      value: _locationType,
                      items: LocationType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
                      onChanged: (v) => setState(() => _locationType = v ?? LocationType.onSite),
                      decoration: const InputDecoration(labelText: 'Location Type *'),
                    ),
                    if (_locationType != LocationType.remote) ...[
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _addressController,
                        label: 'Address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _postcodeController,
                        label: 'Postcode',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Skills Required
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skills Required',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: kSkills.map((s) {
                        final selected = _skills.contains(s);
                        return FilterChip(
                          label: Text(s),
                          selected: selected,
                          onSelected: (v) => setState(() {
                            if (v) {
                              _skills.add(s);
                            } else {
                              _skills.remove(s);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Frequency-specific details
            if (_frequency == FrequencyType.oneOff) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'One-off Event Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text('Event Date & Time: ${_eventDateTime?.toString().split('.')[0] ?? 'Not set'}'),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _eventDateTime ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null && context.mounted) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null && context.mounted) {
                              setState(() {
                                _eventDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<TimeCommitment>(
                        value: _oneOffTimeCommitment,
                        items: TimeCommitment.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
                        onChanged: (v) => setState(() => _oneOffTimeCommitment = v ?? TimeCommitment.oneToTwo),
                        decoration: const InputDecoration(labelText: 'Time Commitment'),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text('Application Deadline: ${_applicationDeadline?.toString().split(' ')[0] ?? 'Not set'}'),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _applicationDeadline ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _applicationDeadline = date;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recurring Event Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<RecurrenceType>(
                        value: _recurrence,
                        items: RecurrenceType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
                        onChanged: (v) => setState(() => _recurrence = v ?? RecurrenceType.weekly),
                        decoration: const InputDecoration(labelText: 'Recurrence'),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<TimeCommitment>(
                        value: _recurringTimeCommitment,
                        items: TimeCommitment.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
                        onChanged: (v) => setState(() => _recurringTimeCommitment = v ?? TimeCommitment.oneToTwo),
                        decoration: const InputDecoration(labelText: 'Time Commitment per Session'),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<DurationType>(
                        value: _duration,
                        items: DurationType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
                        onChanged: (v) => setState(() => _duration = v ?? DurationType.oneMonth),
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
                                final isSelected = _specificDays[day]?.contains(period) == true;
                                return FilterChip(
                                  label: Text(period.displayName),
                                  selected: isSelected,
                                  onSelected: (v) => _toggleDayPeriod(day, period),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            
            AppButton(
              onPressed: createAdvertState.isLoading ? null : () {
                if (!_formKey.currentState!.validate()) return;
                
                // Validate required fields
                if (_category == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a category')),
                  );
                  return;
                }
                
                if (_frequency == FrequencyType.oneOff) {
                  if (_eventDateTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please set event date and time')),
                    );
                    return;
                  }
                  if (_applicationDeadline == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please set application deadline')),
                    );
                    return;
                  }
                }
                
                // Create advert object
                final advert = Advert(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  category: _category!,
                  frequency: _frequency,
                  numberOfVolunteers: _numberOfVolunteers,
                  locationType: _locationType,
                  addressText: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
                  postcode: _postcodeController.text.trim().isNotEmpty ? _postcodeController.text.trim() : null,
                  isActive: true,
                  organizer: OrganizerProfile(id: 1, name: 'Me'), // This should come from auth
                  requiredSkills: _skills.map((s) => SkillResponse(id: 1, name: s, isPredefined: true)).toList(),
                  oneoffDetails: _frequency == FrequencyType.oneOff
                      ? OneOffAdvertDetails(
                          eventDatetime: _eventDateTime!,
                          timeCommitment: _oneOffTimeCommitment,
                          applicationDeadline: _applicationDeadline!,
                        )
                      : null,
                  recurringDetails: _frequency == FrequencyType.recurring
                      ? RecurringAdvertDetails(
                          recurrence: _recurrence,
                          timeCommitmentPerSession: _recurringTimeCommitment,
                          duration: _duration,
                          specificDays: _specificDays.entries.map((entry) => 
                            RecurringDays(day: entry.key, periods: entry.value)
                          ).toList(),
                        )
                      : null,
                  createdAt: DateTime.now(),
                );
                
                // Create advert using state notifier
                ref.read(createAdvertControllerProvider.notifier).createAdvert(
                  advert,
                  imageFile: _selectedImage,
                );
              },
              label: createAdvertState.isLoading ? 'Creating...' : 'Create Advert',
            ),
            // Show error if creation failed
            if (createAdvertState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Error: ${createAdvertState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            // Show success message
            if (createAdvertState.value != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Advert created successfully!',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
