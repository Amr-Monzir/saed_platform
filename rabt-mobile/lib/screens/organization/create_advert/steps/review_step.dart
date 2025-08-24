import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';

class ReviewStep extends ConsumerWidget {
  const ReviewStep({
    super.key,
    required this.titleController,
    required this.descController,
    required this.addressController,
    required this.postcodeController,
    required this.category,
    required this.frequency,
    required this.numberOfVolunteers,
    required this.locationType,
    required this.selectedSkills,
    required this.selectedImage,
    // One-off fields
    required this.eventDateTime,
    required this.oneOffTimeCommitment,
    required this.applicationDeadline,
    // Recurring fields
    required this.recurrence,
    required this.recurringTimeCommitment,
    required this.duration,
    required this.specificDays,
  });

  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController addressController;
  final TextEditingController postcodeController;
  final String? category;
  final FrequencyType frequency;
  final int numberOfVolunteers;
  final LocationType locationType;
  final Set<String> selectedSkills;
  final File? selectedImage;
  
  // One-off fields
  final DateTime? eventDateTime;
  final TimeCommitment oneOffTimeCommitment;
  final DateTime? applicationDeadline;
  
  // Recurring fields
  final RecurrenceType recurrence;
  final TimeCommitment recurringTimeCommitment;
  final DurationType duration;
  final Map<String, List<DayTimePeriod>> specificDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createAdvertState = ref.watch(createAdvertControllerProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Your Advert',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          // Basic Info
          _buildReviewSection(context, 'Basic Information', [
            'Title: ${titleController.text}',
            'Description: ${descController.text}',
            'Category: $category',
            'Frequency: ${frequency.displayName}',
            'Volunteers needed: $numberOfVolunteers',
          ]),
          
          // Location
          _buildReviewSection(context, 'Location', [
            'Type: ${locationType.displayName}',
            if (addressController.text.isNotEmpty) 'Address: ${addressController.text}',
            if (postcodeController.text.isNotEmpty) 'Postcode: ${postcodeController.text}',
          ]),
          
          // Skills
          if (selectedSkills.isNotEmpty)
            _buildReviewSection(context, 'Skills Required', selectedSkills.toList()),
          
          // Details
          if (frequency == FrequencyType.oneOff)
            _buildReviewSection(context, 'Event Details', [
              'Date & Time: ${eventDateTime?.toString().split('.')[0] ?? 'Not set'}',
              'Time Commitment: ${oneOffTimeCommitment.displayName}',
              'Application Deadline: ${applicationDeadline?.toString().split(' ')[0] ?? 'Not set'}',
            ])
          else
            _buildReviewSection(context, 'Recurring Details', [
              'Recurrence: ${recurrence.displayName}',
              'Time per Session: ${recurringTimeCommitment.displayName}',
              'Duration: ${duration.displayName}',
              'Days: ${specificDays.keys.join(', ')}',
            ]),
          
          // Image
          if (selectedImage != null)
            _buildReviewSection(context, 'Image', [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(selectedImage!, fit: BoxFit.cover),
                ),
              ),
            ]),
          
          const SizedBox(height: 24),
          
          // Show creation status
          if (createAdvertState.hasError)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                'Error: ${createAdvertState.error}',
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          
          if (createAdvertState.value != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                'Advert created successfully!',
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(BuildContext context, String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                if (item is Widget) {
                  return item;
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(item.toString()),
                  );
                }
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
