import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';
import '../../services/image_upload_service.dart';
import '../../state/organizer/organizer_repository.dart';
import 'login_organizer_screen.dart';

class OrganizerSignupScreen extends ConsumerStatefulWidget {
  const OrganizerSignupScreen({super.key});

  static const String path = '/signup/organization';

  @override
  ConsumerState<OrganizerSignupScreen> createState() => _OrganizerSignupScreenState();
}

class _OrganizerSignupScreenState extends ConsumerState<OrganizerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _loading = false;
  File? _selectedImage;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _websiteCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage({bool fromCamera = false}) async {
    final image = await ref.read(imageUploadServiceProvider).pickImage(fromCamera: fromCamera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _uploadedImageUrl = null; // Reset uploaded URL when new image is selected
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _loading = true);
    try {
      final imageUrl = await ref.read(organizerRepositoryProvider).uploadLogo(_selectedImage!);
      if (!mounted) return;
      
      if (imageUrl != null) {
        setState(() {
          _uploadedImageUrl = imageUrl;
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logo uploaded successfully!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload logo. Please try again.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create organisation account')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Logo upload section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Organization Logo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      if (_selectedImage != null || _uploadedImageUrl != null)
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _uploadedImageUrl != null
                                ? Image.network(
                                    _uploadedImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _selectedImage != null
                                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                          : const Icon(Icons.error);
                                    },
                                  )
                                : Image.file(_selectedImage!, fit: BoxFit.cover),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _loading ? null : () => _pickImage(),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _loading ? null : () => _pickImage(fromCamera: true),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedImage != null && _uploadedImageUrl == null) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _loading ? null : _uploadImage,
                            icon: _loading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.upload),
                            label: Text(_loading ? 'Uploading...' : 'Upload Logo'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _nameCtrl,
                label: 'Organisation name',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passCtrl,
                label: 'Password',
                obscureText: true,
                validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
              ),
              const SizedBox(height: 16),
              AppTextField(controller: _websiteCtrl, label: 'Website (optional)'),
              const SizedBox(height: 16),
              AppTextField(controller: _descCtrl, label: 'Description (optional)', maxLines: 3),
              const SizedBox(height: 16),
              AppButton(
                label: _loading ? 'Please wait…' : 'Create account',
                onPressed:
                    _loading
                        ? null
                        : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _loading = true);
                          try {
                            await ref.read(organizerRepositoryProvider).register(
                              name: _nameCtrl.text.trim(),
                              email: _emailCtrl.text.trim(),
                              password: _passCtrl.text,
                              website: _websiteCtrl.text.trim().isNotEmpty ? _websiteCtrl.text.trim() : null,
                              description: _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
                              logoUrl: _uploadedImageUrl,
                            );
                            if (!mounted) return;
                            if (context.mounted) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Account created. Please log in.')));
                              context.go(OrganizerLoginScreen.path);
                            }
                          } catch (e) {
                            if (!mounted) return;
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
                            }
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.go(OrganizerLoginScreen.path),
                  child: const Text('Already have an account? Log in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
