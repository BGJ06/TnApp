import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class InfluencerForm extends ConsumerStatefulWidget {
  const InfluencerForm({super.key});

  @override
  ConsumerState<InfluencerForm> createState() => _InfluencerFormState();
}

class _InfluencerFormState extends ConsumerState<InfluencerForm> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _districtController = TextEditingController();
  final _talukController = TextEditingController();
  
  // Social Media Handles
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _xController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _telegramController = TextEditingController();

  // Metrics
  final _followersController = TextEditingController();
  final _reachController = TextEditingController();

  // Skills capability mapping
  final List<String> _selectedSkills = [];

  final Map<String, String> _skillTamilNames = {
    'Graphic Design': 'கிராஃபிக் வடிவமைப்பு',
    'Video Editing': 'வீடியோ எடிட்டிங்',
    'Photography': 'புகைப்படம் எடுத்தல்',
    'Videography': 'வீடியோகிராபி',
    'Public Speaking': 'பேச்சாற்றல்',
    'Content Writing': 'எழுத்தாற்றல்',
    'Social Media Management': 'சமூக ஊடக மேலாண்மை',
    'Web Development': 'இணையதள மேம்பாடு',
    'App Development': 'செயலி மேம்பாடு',
    'Campaign Management': 'பிரச்சார மேலாண்மை',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _districtController.dispose();
    _talukController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _xController.dispose();
    _youtubeController.dispose();
    _telegramController.dispose();
    _followersController.dispose();
    _reachController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('itWingFormTitle', ref)),
        actions: [
          // Language Switcher Toggle button
          TextButton.icon(
            onPressed: () {
              ref.read(languageProvider.notifier).toggleLanguage();
            },
            icon: const Icon(Icons.language, color: Colors.white, size: 18),
            label: Text(
              isTamil ? 'English' : 'தமிழ்',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('personalContactInfo', ref),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.tr('fullName', ref),
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: context.tr('mobileNumber', ref),
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: context.tr('emailAddress', ref),
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                context.tr('operatingRegion', ref),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: context.tr('districtLabel', ref),
                  prefixIcon: const Icon(Icons.map),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _talukController,
                decoration: InputDecoration(
                  labelText: context.tr('talukLabel', ref),
                  prefixIcon: const Icon(Icons.location_city),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
              ),
              const SizedBox(height: 24),

              Text(
                context.tr('socialMediaAnalytics', ref),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _instagramController,
                decoration: const InputDecoration(
                  labelText: 'Instagram Username (e.g. @username)',
                  prefixIcon: Icon(Icons.camera_alt),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _facebookController,
                decoration: const InputDecoration(
                  labelText: 'Facebook Page URL',
                  prefixIcon: Icon(Icons.facebook),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _xController,
                decoration: const InputDecoration(
                  labelText: 'X (Twitter) Username',
                  prefixIcon: Icon(Icons.alternate_email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _youtubeController,
                decoration: const InputDecoration(
                  labelText: 'YouTube Channel Name',
                  prefixIcon: Icon(Icons.video_library),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telegramController,
                decoration: const InputDecoration(
                  labelText: 'Telegram Channel Username',
                  prefixIcon: Icon(Icons.send),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _followersController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: context.tr('followersCount', ref),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _reachController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: context.tr('reachLabel', ref),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? context.tr('required', ref) : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                context.tr('digitalSkills', ref),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.influencerSkills.map((skill) {
                  final isSelected = _selectedSkills.contains(skill);
                  final displaySkill = isTamil ? (_skillTamilNames[skill] ?? skill) : skill;
                  return FilterChip(
                    label: Text(displaySkill),
                    selected: isSelected,
                    selectedColor: AppTheme.primary.withOpacity(0.2),
                    checkmarkColor: AppTheme.primary,
                    onSelected: (val) => _toggleSkill(skill),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.tr('itWingSuccess', ref))),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(context.tr('submitApplication', ref)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
