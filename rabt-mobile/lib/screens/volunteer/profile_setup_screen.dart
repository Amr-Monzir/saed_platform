import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../adverts/adverts_list_screen.dart';
import '../../constants/lookups.dart';
import '../../state/volunteer/volunteer_repository.dart';

class VolunteerProfileSetupScreen extends ConsumerStatefulWidget {
  const VolunteerProfileSetupScreen({super.key});

  static const String path = '/v/profile-setup';

  @override
  ConsumerState<VolunteerProfileSetupScreen> createState() => _VolunteerProfileSetupScreenState();
}

class _VolunteerProfileSetupScreenState extends ConsumerState<VolunteerProfileSetupScreen> {
  final Set<String> _skills = {};
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select skills'),
            Wrap(
              spacing: 8,
              children: kSkills.map((s) {
                final selected = _skills.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: selected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _skills.add(s);
                      } else {
                        _skills.remove(s);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Short bio', border: OutlineInputBorder()),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(volunteerRepositoryProvider).update(name: 'Volunteer', phoneNumber: null, city: null, country: null, skillIds: const []);
                  if (!context.mounted) return;
                  context.go(AdvertsListScreen.volunteerPath);
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}


