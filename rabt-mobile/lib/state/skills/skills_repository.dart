import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/skill.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/util/parse_helpers.dart';

class SkillsRepository {
  SkillsRepository(this.ref);

  final Ref ref;

  Future<List<Skill>> getSkills() async {
    final resp = await ref.read(apiServiceProvider).get('/api/v1/skills', isAuthenticated: false);
    return parseList(resp, Skill.fromJson, key: 'skills');
  }

  Future<List<Skill>> getSkillsForSignup() async {
    final resp = await ref.read(apiServiceProvider).get('/api/v1/skills/signup', isAuthenticated: false);
    return parseList(resp, Skill.fromJson, key: 'skills');
  }

  Future<void> createSkill(String name, String category) async {
    await ref.read(apiServiceProvider).post('/api/v1/skills', {
      'name': name,
      'category': category,
      'is_predefined': false,
    });
  }

  Future<List<Skill>> getPredefinedSkills() async {
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/skills/predefined');
    return parseList(resp, Skill.fromJson);
  }

  Future<List<Skill>> getUserSkills() async {
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/skills/user-skills');
    return parseList(resp, Skill.fromJson);
  }
}

final skillsRepositoryProvider = Provider((ref) => SkillsRepository(ref));
