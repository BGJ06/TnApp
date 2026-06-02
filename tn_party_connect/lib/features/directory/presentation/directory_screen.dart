import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class DirectoryLeader {
  final String name;
  final String position;
  final String region;
  final String district;
  final String taluk;

  DirectoryLeader({
    required this.name,
    required this.position,
    required this.region,
    required this.district,
    required this.taluk,
  });
}

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _selectedDistrict = 'All';
  String _selectedTaluk = 'All';
  
  List<dynamic> _districts = [];
  List<String> _filteredTaluks = [];
  bool _isLoadingHierarchy = true;

  // Mock leadership directory data (PII Sanitized - only Name, Position, Region visible)
  final List<DirectoryLeader> _leadersData = [
    DirectoryLeader(
      name: 'Dr. Thanga Pandian',
      position: 'State President',
      region: 'Tamil Nadu (Statewide)',
      district: 'All',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'A. Durai Murugan',
      position: 'State General Secretary',
      region: 'Tamil Nadu (Statewide)',
      district: 'All',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'Kavin Kumar',
      position: 'State IT Wing Head',
      region: 'Tamil Nadu (Statewide)',
      district: 'All',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'Selvam Muthu',
      position: 'District Head',
      region: 'Chennai District',
      district: 'Chennai',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'Ramanathan',
      position: 'Taluk Head',
      region: 'Egmore Taluk',
      district: 'Chennai',
      taluk: 'Egmore',
    ),
    DirectoryLeader(
      name: 'Velu',
      position: 'Ward Head',
      region: 'Ward 119 (Egmore)',
      district: 'Chennai',
      taluk: 'Egmore',
    ),
    DirectoryLeader(
      name: 'P. R. Pandian',
      position: 'District Head',
      region: 'Madurai District',
      district: 'Madurai',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'Alagiri',
      position: 'Taluk Head',
      region: 'Melur Taluk',
      district: 'Madurai',
      taluk: 'Melur',
    ),
    DirectoryLeader(
      name: 'Muthuvel',
      position: 'Ward Head',
      region: 'Ward 5 (Melur)',
      district: 'Madurai',
      taluk: 'Melur',
    ),
  ];

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
      debugPrint("Error loading hierarchy JSON: $e");
      setState(() {
        _isLoadingHierarchy = false;
      });
    }
  }

  void _onDistrictChanged(String? newDistrict) {
    if (newDistrict == null) return;
    
    if (newDistrict == 'All') {
      setState(() {
        _selectedDistrict = 'All';
        _selectedTaluk = 'All';
        _filteredTaluks = [];
      });
      return;
    }

    final districtData = _districts.firstWhere(
      (d) => d['name'] == newDistrict,
      orElse: () => null,
    );

    setState(() {
      _selectedDistrict = newDistrict;
      _selectedTaluk = 'All';
      _filteredTaluks = List<String>.from(districtData?['taluks'] ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter leadership records based on dropdown variables
    final filteredLeaders = _leadersData.where((leader) {
      final matchDistrict = _selectedDistrict == 'All' || leader.district == 'All' || leader.district == _selectedDistrict;
      final matchTaluk = _selectedTaluk == 'All' || leader.taluk == 'All' || leader.taluk == _selectedTaluk;
      return matchDistrict && matchTaluk;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leadership Directory'),
      ),
      body: Column(
        children: [
          // Filter Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: _isLoadingHierarchy
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      // District Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'District',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedDistrict,
                          items: [
                            const DropdownMenuItem(value: 'All', child: Text('All Districts')),
                            ..._districts.map((d) => DropdownMenuItem(
                                  value: d['name'] as String,
                                  child: Text(d['name'] as String),
                                )),
                          ],
                          onChanged: _onDistrictChanged,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Taluk Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Taluk',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedTaluk,
                          items: [
                            const DropdownMenuItem(value: 'All', child: Text('All Taluks')),
                            ..._filteredTaluks.map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t),
                                )),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedTaluk = val ?? 'All';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          
          // Leadership List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredLeaders.length,
              itemBuilder: (context, index) {
                final leader = filteredLeaders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      child: Text(
                        leader.name[0],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      leader.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            leader.position,
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              leader.region,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
