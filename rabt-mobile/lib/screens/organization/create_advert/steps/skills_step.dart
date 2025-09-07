import 'package:flutter/material.dart';
import 'package:rabt_mobile/constants/lookups.dart';

class SkillsStep extends StatelessWidget {
  const SkillsStep({
    super.key,
    required this.selectedSkills,
    required this.onSkillToggled,
  });

  final Set<String> selectedSkills;
  final ValueChanged<String> onSkillToggled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills Required',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Select the skills required for this opportunity (optional)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kSkillsCreateAdvert.map((s) {
              final selected = selectedSkills.contains(s);
              return FilterChip(
                label: Text(s),
                selected: selected,
                onSelected: (v) => onSkillToggled(s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
