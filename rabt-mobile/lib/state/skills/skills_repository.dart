import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/skill.dart';
import '../../services/api_service.dart';
import '../auth/auth_providers.dart';

class SkillsRepository {
  SkillsRepository(this.ref);

  final Ref ref;

  Future<List<Skill>> getSkills() async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/skills', headers: ref.read(apiServiceProvider).authHeaders(token));
    return (resp.body as List).map((e) => Skill.fromJson(e)).toList();
  }

  Future<void> createSkill(String name, String category) async {
    final token = ref.read(authControllerProvider).value?.token;
    await ref.read(apiServiceProvider).post('/api/v1/skills', {
      'name': name,
      'category': category,
      'is_predefined': false,
    }, headers: ref.read(apiServiceProvider).authHeaders(token));
  }
}

final skillsRepositoryProvider = Provider((ref) => SkillsRepository(ref));

final skillsProvider = FutureProvider<List<Skill>>((ref) async {
  final repository = ref.watch(skillsRepositoryProvider);
  return repository.getSkills();
});
