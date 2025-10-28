import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/widgets/app_text_field.dart';

class LocationStep extends StatelessWidget {
  const LocationStep({
    super.key,
    required this.formKey,
    required this.addressController,
    required this.postcodeController,
    required this.cityController,
    required this.locationType,
    required this.selectedImage,
    required this.onLocationTypeChanged,
    required this.onPickImage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController addressController;
  final TextEditingController postcodeController;
  final TextEditingController cityController;
  final LocationType locationType;
  final File? selectedImage;
  final ValueChanged<LocationType?> onLocationTypeChanged;
  final Function({required bool fromCamera}) onPickImage;

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
              'Location Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<LocationType>(
              value: locationType,
              items: LocationType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.displayName))).toList(),
              onChanged: onLocationTypeChanged,
              decoration: const InputDecoration(labelText: 'Location Type *'),
            ),
            if (locationType != LocationType.remote) ...[
              const SizedBox(height: 16),
              AppTextField(
                controller: addressController,
                label: 'Address',
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: postcodeController,
                label: 'Postcode',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: cityController,
                label: 'City',
              ),
            ],
            const SizedBox(height: 24),
            // Image upload section
            Text(
              'Advert Image (Optional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (selectedImage != null)
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(selectedImage!, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onPickImage(fromCamera: false),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onPickImage(fromCamera: true),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
