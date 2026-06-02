import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state.dart';
import '../../../core/theme.dart';

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
  String _profilePhotoPath = ''; // Mock photo upload indicator

  List<dynamic> _districts = [];
  List<String> _filteredTaluks = [];
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
      _filteredTaluks = List<String>.from(districtData?['taluks'] ?? []);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(authStateProvider.notifier).reset();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
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
                            backgroundColor: isDark ? AppTheme.primaryDark : AppTheme.accentLight,
                            child: _profilePhotoPath.isEmpty
                                ? const Icon(Icons.person, size: 60, color: Colors.white)
                                : const Icon(Icons.check_circle, size: 60, color: Colors.green),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: isDark ? AppTheme.secondaryDark : AppTheme.primaryLight,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                onPressed: () {
                                  // Emulated Photo selection
                                  setState(() {
                                    _profilePhotoPath = 'mock_photo_path.jpg';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profile photo selected!')),
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
                      decoration: const InputDecoration(
                        labelText: 'Full Name (as per ID)',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter full name' : null,
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
                                  ? 'Select Date of Birth'
                                  : 'DOB: ${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}',
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
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number (Verified)',
                        prefixIcon: Icon(Icons.phone_locked),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Alternate Mobile
                    TextFormField(
                      controller: _altPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Alternate Mobile Number',
                        prefixIcon: Icon(Icons.phone_android),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Full Address',
                        prefixIcon: Icon(Icons.home_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter your address' : null,
                    ),
                    const SizedBox(height: 16),

                    // District Dropdown (Dynamic)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'District',
                        prefixIcon: Icon(Icons.map_outlined),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedDistrict.isEmpty ? null : _selectedDistrict,
                      items: _districts.map((district) {
                        return DropdownMenuItem<String>(
                          value: district['name'] as String,
                          child: Text(district['name'] as String),
                        );
                      }).toList(),
                      onChanged: _onDistrictChanged,
                      validator: (val) => val == null || val.isEmpty ? 'Select your district' : null,
                    ),
                    const SizedBox(height: 16),

                    // Taluk Dropdown (Dynamic based on selected district)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Taluk',
                        prefixIcon: Icon(Icons.location_city_outlined),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedTaluk.isEmpty ? null : _selectedTaluk,
                      items: _filteredTaluks.map((taluk) {
                        return DropdownMenuItem<String>(
                          value: taluk,
                          child: Text(taluk),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedTaluk = val ?? '';
                        });
                      },
                      validator: (val) => val == null || val.isEmpty ? 'Select your taluk' : null,
                    ),
                    const SizedBox(height: 16),

                    // Village / Area
                    TextFormField(
                      controller: _villageController,
                      decoration: const InputDecoration(
                        labelText: 'Village / Area Name',
                        prefixIcon: Icon(Icons.holiday_village_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter village or area name' : null,
                    ),
                    const SizedBox(height: 16),

                    // Ward
                    TextFormField(
                      controller: _wardController,
                      decoration: const InputDecoration(
                        labelText: 'Ward Number',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter ward number' : null,
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
                            const SnackBar(content: Text('Please select Date of Birth')),
                          );
                        }
                      },
                      child: const Text('Complete Registration'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
