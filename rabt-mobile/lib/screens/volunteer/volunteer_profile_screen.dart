import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/volunteer.dart';
import 'package:rabt_mobile/state/skills/skills_providers.dart';
import 'package:rabt_mobile/state/volunteer/volunteer_repository.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/app_text_field.dart';
import 'package:rabt_mobile/widgets/badge_chip.dart';

class VolunteerProfileScreen extends ConsumerStatefulWidget {
  const VolunteerProfileScreen({super.key});

  static const String path = '/v/profile';

  @override
  ConsumerState<VolunteerProfileScreen> createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends ConsumerState<VolunteerProfileScreen> {
  bool _isEditing = false;
  bool _isUpdating = false;

  // Controllers for edit mode
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _emailController;
  // Selected skills for edit mode
  Set<int> _selectedSkillIds = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _startEditing(VolunteerProfile profile) {
    setState(() {
      _isEditing = true;
      _nameController.text = profile.name;
      _phoneController.text = profile.phoneNumber ?? '';
      _cityController.text = profile.city ?? '';
      _countryController.text = profile.country ?? '';
      _selectedSkillIds = profile.skills.map((skill) => skill.id).toSet();
      _emailController.text = profile.email ?? '';
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await ref
          .read(volunteerRepositoryProvider)
          .update(
            name: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            skillIds: _selectedSkillIds.toList(),
          );

      // Refresh the profile data
      ref.invalidate(volunteerProfileProvider);

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(volunteerProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Profile'),
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                profileAsync.whenData((profile) {
                  if (profile != null) {
                    _startEditing(profile);
                  }
                });
              },
            ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Profile not found', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.error)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                AppCard(
                  child: Column(
                    children: [
                      // Profile Avatar
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3), width: 2),
                        ),
                        child: Icon(Icons.person, size: 50, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 16),

                      // Volunteer Name
                      if (_isEditing) ...[
                        AppTextField(controller: _nameController, label: 'Name'),
                      ] else ...[
                        Text(
                          profile.name,
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],

                      // Onboarding Status
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              profile.onboardingCompleted
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                profile.onboardingCompleted
                                    ? Colors.green.withValues(alpha: 0.3)
                                    : Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              profile.onboardingCompleted ? Icons.check_circle : Icons.pending,
                              size: 16,
                              color: profile.onboardingCompleted ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              profile.onboardingCompleted ? 'Profile Complete' : 'Profile Incomplete',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: profile.onboardingCompleted ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Contact Information
                Text('Contact Information', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    children: [
                      if (_isEditing) ...[
                        AppTextField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        AppTextField(controller: _cityController, label: 'City'),
                        const SizedBox(height: 16),
                        AppTextField(controller: _countryController, label: 'Country'),
                        const SizedBox(height: 16),
                        AppTextField(label: 'Email', controller: _emailController, enabled: false),
                      ] else ...[
                        _buildDetailRow(context, 'Phone', profile.phoneNumber ?? 'Not provided', Icons.phone),
                        if (profile.city != null) ...[
                          const Divider(),
                          _buildDetailRow(context, 'City', profile.city!, Icons.location_city),
                        ],
                        if (profile.country != null) ...[
                          const Divider(),
                          _buildDetailRow(context, 'Country', profile.country!, Icons.public),
                        ],
                        if (profile.email != null) ...[
                          const Divider(),
                          _buildDetailRow(context, 'Email', profile.email!, Icons.email),
                        ],
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Skills Section
                Text('Skills', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isEditing) ...[
                        Text('Select your skills:', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        _buildSkillsSelector(),
                      ] else ...[
                        if (profile.skills.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: profile.skills.map((skill) => BadgeChip(label: skill.name)).toList(),
                          ),
                        ] else ...[
                          Text(
                            'No skills added yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Edit Actions
                if (_isEditing) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Cancel',
                          variant: AppButtonVariant.outline,
                          onPressed: _isUpdating ? null : _cancelEditing,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: _isUpdating ? 'Saving...' : 'Save Changes',
                          onPressed: _isUpdating ? null : _saveChanges,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Error loading profile', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.error)),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSelector() {
    final allSkillsAsync = ref.watch(allSkillsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: allSkillsAsync.when(
        data: (skills) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                skills
                    .map(
                      (skill) => BadgeChip(
                        label: skill.name,
                        isSelected: _selectedSkillIds.contains(skill.id),
                        onTap: () {
                          setState(() {
                            if (_selectedSkillIds.contains(skill.id)) {
                              _selectedSkillIds.remove(skill.id);
                            } else {
                              _selectedSkillIds.add(skill.id);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Text('Error loading skills: $error'),
      ),
    );
  }
}
