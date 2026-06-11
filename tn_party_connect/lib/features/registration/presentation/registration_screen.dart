import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _villageController = TextEditingController();
  final _wardController = TextEditingController();

  DateTime? _selectedDob;
  String _selectedDistrict = '';
  String _selectedTaluk = '';
  String _selectedVillage = '';
  String _profilePhotoPath = ''; // Mock photo upload indicator

  List<dynamic> _districts = [];
  List<String> _filteredTaluks = [];
  List<String> _filteredVillages = [];
  bool _isLoadingHierarchy = true;

  @override
  void initState() {
    super.initState();
    _loadHierarchy();
  }

  Future<void> _loadHierarchy() async {
    try {
      final jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/tamilnadu_hierarchy.json');
      final data = json.decode(jsonString);
      setState(() {
        _districts = data['districts'] ?? [];
        _isLoadingHierarchy = false;
      });
    } catch (e) {
      debugPrint("Error loading geographic list: $e");
      setState(() {
        _isLoadingHierarchy = false;
      });
    }
  }

  void _onDistrictChanged(String? newDistrict) {
    if (newDistrict == null) return;
    
    // Find taluks matching the selected district
    final districtData = _districts.firstWhere(
      (d) => d['name'] == newDistrict,
      orElse: () => null,
    );

    setState(() {
      _selectedDistrict = newDistrict;
      _selectedTaluk = ''; // Reset taluk selection
      _selectedVillage = ''; // Reset village selection
      _filteredTaluks = List<String>.from(districtData?['taluks'] ?? []);
      _filteredVillages = [];
      _villageController.clear();
    });
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 15)), // Minimum 15 years old
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _altPhoneController.dispose();
    _addressController.dispose();
    _villageController.dispose();
    _wardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final uid = args['uid'] as String;
    final phoneNumber = args['phoneNumber'] as String;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    final districtTamilNames = {
      'Ariyalur': 'அரியலூர்',
      'Chengalpattu': 'செங்கல்பட்டு',
      'Chennai': 'சென்னை',
      'Coimbatore': 'கோயம்புத்தூர்',
      'Cuddalore': 'கடலூர்',
      'Dharmapuri': 'தர்மபுரி',
      'Dindigul': 'திண்டுக்கல்',
      'Erode': 'ஈரோடு',
      'Kallakurichi': 'கள்ளக்குறிச்சி',
      'Kanchipuram': 'காஞ்சிபுரம்',
      'Kanyakumari': 'கன்னியாகுமரி',
      'Karur': 'கரூர்',
      'Krishnagiri': 'கிருஷ்ணகிரி',
      'Madurai': 'மதுரை',
      'Mayiladuthurai': 'மயிலாடுதுறை',
      'Nagapattinam': 'நாகப்பட்டினம்',
      'Namakkal': 'நாமக்கல்',
      'Nilgiris': 'நீலகிரி',
      'Perambalur': 'பெரம்பலூர்',
      'Pudukkottai': 'புதுக்கோட்டை',
      'Ramanathapuram': 'இராமநாதபுரம்',
      'Ranipet': 'ராணிப்பேட்டை',
      'Salem': 'சேலம்',
      'Sivaganga': 'சிவகங்கை',
      'Tenkasi': 'தென்காசி',
      'Thanjavur': 'தஞ்சாவூர்',
      'Theni': 'தேனி',
      'Thoothukudi': 'தூத்துக்குடி',
      'Tiruchirappalli': 'திருச்சிராப்பள்ளி',
      'Tirunelveli': 'திருநெல்வேலி',
      'Tirupathur': 'திருப்பத்தூர்',
      'Tiruppur': 'திருப்பூர்',
      'Tiruvallur': 'திருவள்ளூர்',
      'Tiruvannamalai': 'திருவண்ணாமலை',
      'Tiruvarur': 'திருவாரூர்',
      'Vellore': 'வேலூர்',
      'Viluppuram': 'விழுப்புரம்',
      'Virudhunagar': 'விருதுநாயக்கர்',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('memberRegistration', ref)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(authStateProvider.notifier).reset();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
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
      body: _isLoadingHierarchy
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Photo Upload Preview
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: isDark ? AppTheme.surfaceDark : Colors.grey.shade300,
                            child: _profilePhotoPath.isEmpty
                                ? const Icon(Icons.person, size: 60, color: Colors.white)
                                : const Icon(Icons.check_circle, size: 60, color: Colors.green),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: AppTheme.primary,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                onPressed: () {
                                  // Emulated Photo selection
                                  setState(() {
                                    _profilePhotoPath = 'mock_photo_path.jpg';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(isTamil ? 'சுயவிவரப் படம் தேர்ந்தெடுக்கப்பட்டது!' : 'Profile photo selected!')),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Full Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: context.tr('fullNameAsId', ref),
                        prefixIcon: const Icon(Icons.person_outline),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? (isTamil ? 'முழு பெயரை உள்ளிடவும்' : 'Enter full name') : null,
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth Field
                    InkWell(
                      onTap: _pickDob,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.grey),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDob == null
                                  ? context.tr('selectDob', ref)
                                  : '${isTamil ? "பிறந்த தேதி" : "DOB"}: ${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mobile Field (Prefilled from OTP)
                    TextFormField(
                      initialValue: phoneNumber,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: context.tr('mobileVerified', ref),
                        prefixIcon: const Icon(Icons.phone_locked),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Alternate Mobile
                    TextFormField(
                      controller: _altPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: context.tr('alternateMobile', ref),
                        prefixIcon: const Icon(Icons.phone_android),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: context.tr('fullAddress', ref),
                        prefixIcon: const Icon(Icons.home_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? (isTamil ? 'உங்கள் முகவரியை உள்ளிடவும்' : 'Enter your address') : null,
                    ),
                    const SizedBox(height: 16),

                    // District Dropdown (Dynamic)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: context.tr('districtLabel', ref),
                        prefixIcon: const Icon(Icons.map_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      initialValue: _selectedDistrict.isEmpty ? null : _selectedDistrict,
                      items: _districts.map((district) {
                        final name = district['name'] as String;
                        final displayName = isTamil ? (districtTamilNames[name] ?? name) : name;
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(displayName),
                        );
                      }).toList(),
                      onChanged: _onDistrictChanged,
                      validator: (val) => val == null || val.isEmpty ? (isTamil ? 'மாவட்டத்தைத் தேர்ந்தெடுக்கவும்' : 'Select your district') : null,
                    ),
                    const SizedBox(height: 16),

                    // Taluk Dropdown (Dynamic based on selected district)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: context.tr('talukLabel', ref),
                        prefixIcon: const Icon(Icons.location_city_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      initialValue: _selectedTaluk.isEmpty ? null : _selectedTaluk,
                      items: _filteredTaluks.map((taluk) {
                        return DropdownMenuItem<String>(
                          value: taluk,
                          child: Text(taluk),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final districtData = _districts.firstWhere(
                          (d) => d['name'] == _selectedDistrict,
                          orElse: () => null,
                        );
                        final villagesMap = districtData?['talukVillages'] as Map<String, dynamic>?;
                        final List<String> villages = villagesMap != null && val != null
                            ? List<String>.from(villagesMap[val] ?? [])
                            : [];
                        setState(() {
                          _selectedTaluk = val ?? '';
                          _selectedVillage = ''; // Reset selected village
                          _filteredVillages = villages;
                          _villageController.clear();
                        });
                      },
                      validator: (val) => val == null || val.isEmpty ? (isTamil ? 'தாலுகாவைத் தேர்ந்தெடுக்கவும்' : 'Select your taluk') : null,
                    ),
                    const SizedBox(height: 16),

                    // Village / Area (Dropdown or text field fallback)
                    _filteredVillages.isNotEmpty
                        ? DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: context.tr('villageAreaName', ref),
                              prefixIcon: const Icon(Icons.holiday_village_outlined),
                              border: const OutlineInputBorder(),
                            ),
                            initialValue: _selectedVillage.isEmpty ? null : _selectedVillage,
                            items: _filteredVillages.map((village) {
                              return DropdownMenuItem<String>(
                                value: village,
                                child: Text(village),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedVillage = val ?? '';
                                _villageController.text = _selectedVillage;
                              });
                            },
                            validator: (val) => val == null || val.isEmpty
                                ? (isTamil ? 'கிராமத்தைத் தேர்ந்தெடுக்கவும்' : 'Select your village')
                                : null,
                          )
                        : TextFormField(
                            controller: _villageController,
                            decoration: InputDecoration(
                              labelText: context.tr('villageAreaName', ref),
                              prefixIcon: const Icon(Icons.holiday_village_outlined),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? (isTamil ? 'கிராமம் அல்லது பகுதி பெயரை உள்ளிடவும்' : 'Enter village or area name')
                                : null,
                          ),
                    const SizedBox(height: 16),

                    // Ward
                    TextFormField(
                      controller: _wardController,
                      decoration: InputDecoration(
                        labelText: context.tr('wardNumber', ref),
                        prefixIcon: const Icon(Icons.numbers),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? (isTamil ? 'வார்டு எண்ணை உள்ளிடவும்' : 'Enter ward number') : null,
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _selectedDob != null) {
                          ref.read(authStateProvider.notifier).registerMember(
                                uid: uid,
                                fullName: _nameController.text.trim(),
                                dob: _selectedDob!.toIso8601String().substring(0, 10),
                                mobileNumber: phoneNumber,
                                alternateMobileNumber: _altPhoneController.text.trim(),
                                address: _addressController.text.trim(),
                                district: _selectedDistrict,
                                taluk: _selectedTaluk,
                                village: _villageController.text.trim(),
                                area: _villageController.text.trim(), // Use same for simplification
                                ward: _wardController.text.trim(),
                                profilePhotoUrl: _profilePhotoPath.isEmpty
                                    ? 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'
                                    : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
                              );
                        } else if (_selectedDob == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isTamil ? 'தயவுசெய்து பிறந்த தேதியைத் தேர்ந்தெடுக்கவும்' : 'Please select Date of Birth')),
                          );
                        }
                      },
                      child: Text(context.tr('completeRegistration', ref)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
