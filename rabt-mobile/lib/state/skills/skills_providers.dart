import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/skill.dart';
import 'package:rabt_mobile/state/skills/skills_repository.dart';

final allSkillsProvider = FutureProvider<List<Skill>>((ref) async {
  final repository = ref.watch(skillsRepositoryProvider);
  return repository.getSkills();
});

final skillsForSignupProvider = FutureProvider<List<Skill>>((ref) async {
  final repository = ref.watch(skillsRepositoryProvider);
  return repository.getSkillsForSignup();
});

final predefinedSkillsProvider = FutureProvider<List<Skill>>((ref) async {
  final repository = ref.watch(skillsRepositoryProvider);
  return repository.getPredefinedSkills();
});

final userSkillsProvider = FutureProvider<List<Skill>>((ref) async {
  final repository = ref.watch(skillsRepositoryProvider);
  return repository.getUserSkills();
});

