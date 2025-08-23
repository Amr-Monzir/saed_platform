import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/organizer.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/services/image_upload_service.dart';
import 'dart:io';
import 'dart:convert';

import 'package:rabt_mobile/state/auth/auth_providers.dart';

class OrganizerRepository {
  OrganizerRepository(this.ref);

  final Ref ref;

  Future<OrganizerProfile> fetchOrganizerProfile() async {
    final token = ref.read(authControllerProvider).session?.token;
    final resp = await ref.read(apiServiceProvider).get('/api/v1/organizers/profile', headers: ref.read(apiServiceProvider).authHeaders(token));
    return OrganizerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  /// Register a new organizer
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? website,
    String? description,
    String? logoUrl,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };

    if (website != null && website.isNotEmpty) {
      data['website'] = website;
    }
    if (description != null && description.isNotEmpty) {
      data['description'] = description;
    }
    if (logoUrl != null) {
      data['logo_url'] = logoUrl;
    }

    await ref.read(apiServiceProvider).post('/api/v1/organizers/register', data);
  }

  /// Upload organizer logo using the generic image upload endpoint
  Future<String?> uploadLogo(File logoFile) async {
    final token = ref.read(authControllerProvider).session?.token;
    return await ref.read(imageUploadServiceProvider).uploadImageWithCategory(
      logoFile,
      category: 'logos',
      token: token,
    );
  }
}

final organizerRepositoryProvider = Provider((ref) => OrganizerRepository(ref));
