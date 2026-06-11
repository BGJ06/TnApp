import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/localization.dart';
import 'tamilnadu_paths.dart';

class DirectoryLeader {
  final String name;
  final String position;
  final String region;
  final String district;
  final String taluk;
  final String village;

  DirectoryLeader({
    required this.name,
    required this.position,
    required this.region,
    required this.district,
    required this.taluk,
    this.village = 'All',
  });
}


class DirectoryScreen extends ConsumerStatefulWidget {
  const DirectoryScreen({super.key});

  @override
  ConsumerState<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends ConsumerState<DirectoryScreen> {
  String _selectedDistrict = 'All';
  String _selectedTaluk = 'All';
  String _selectedVillage = 'All';
  
  List<dynamic> _districts = [];
  List<String> _filteredTaluks = [];
  List<String> _filteredVillages = [];
  bool _isLoadingHierarchy = true;

  // Mock leadership directory database covering all 38 districts of Tamil Nadu
  final List<DirectoryLeader> _leadersData = [
    // State executive team
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
    
    // District-specific leaders
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
      name: 'R. Ramakrishnan',
      position: 'District Head',
      region: 'Coimbatore District',
      district: 'Coimbatore',
      taluk: 'All',
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
      name: 'M. Sundar',
      position: 'District Head',
      region: 'Salem District',
      district: 'Salem',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'K. Ganesan',
      position: 'District Head',
      region: 'Trichy District',
      district: 'Tiruchirappalli',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'S. Thirunavukkarasu',
      position: 'District Head',
      region: 'Thanjavur District',
      district: 'Thanjavur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'V. Shunmugavel',
      position: 'District Head',
      region: 'Tirunelveli District',
      district: 'Tirunelveli',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'P. Kathirvel',
      position: 'District Head',
      region: 'Vellore District',
      district: 'Vellore',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'T. Jagadeesan',
      position: 'District Head',
      region: 'Erode District',
      district: 'Erode',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'M. Christopher',
      position: 'District Head',
      region: 'Kanyakumari District',
      district: 'Kanyakumari',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'L. Muruganandam',
      position: 'District Head',
      region: 'Ariyalur District',
      district: 'Ariyalur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'R. Prabhakaran',
      position: 'District Head',
      region: 'Chengalpattu District',
      district: 'Chengalpattu',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'P. Subramanian',
      position: 'District Head',
      region: 'Cuddalore District',
      district: 'Cuddalore',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'V. Rajamani',
      position: 'District Head',
      region: 'Dharmapuri District',
      district: 'Dharmapuri',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'S. Palanisamy',
      position: 'District Head',
      region: 'Dindigul District',
      district: 'Dindigul',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'K. Anbarasan',
      position: 'District Head',
      region: 'Kallakurichi District',
      district: 'Kallakurichi',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'G. Elangovan',
      position: 'District Head',
      region: 'Kanchipuram District',
      district: 'Kanchipuram',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'V. Senthil Balaji',
      position: 'District Head',
      region: 'Karur District',
      district: 'Karur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'R. Jayakumar',
      position: 'District Head',
      region: 'Krishnagiri District',
      district: 'Krishnagiri',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'A. Radhakrishnan',
      position: 'District Head',
      region: 'Mayiladuthurai District',
      district: 'Mayiladuthurai',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'M. Selvaraj',
      position: 'District Head',
      region: 'Nagapattinam District',
      district: 'Nagapattinam',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'P. Ramasamy',
      position: 'District Head',
      region: 'Namakkal District',
      district: 'Namakkal',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'S. H. Raju',
      position: 'District Head',
      region: 'Nilgiris District',
      district: 'Nilgiris',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'R. Rajendran',
      position: 'District Head',
      region: 'Perambalur District',
      district: 'Perambalur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'C. Muthukumaran',
      position: 'District Head',
      region: 'Pudukkottai District',
      district: 'Pudukkottai',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'K. Muthuramalingam',
      position: 'District Head',
      region: 'Ramanathapuram District',
      district: 'Ramanathapuram',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'S. Ravi',
      position: 'District Head',
      region: 'Ranipet District',
      district: 'Ranipet',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'T. R. Karuppiah',
      position: 'District Head',
      region: 'Sivaganga District',
      district: 'Sivaganga',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'S. Pandiarajan',
      position: 'District Head',
      region: 'Tenkasi District',
      district: 'Tenkasi',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'R. Thangathurai',
      position: 'District Head',
      region: 'Theni District',
      district: 'Theni',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'P. Geetha Jeevan',
      position: 'District Head',
      region: 'Thoothukudi District',
      district: 'Thoothukudi',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'K. Devaraj',
      position: 'District Head',
      region: 'Tirupathur District',
      district: 'Tirupathur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'M. Sakthivel',
      position: 'District Head',
      region: 'Tiruppur District',
      district: 'Tiruppur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'G. Hari',
      position: 'District Head',
      region: 'Tiruvallur District',
      district: 'Tiruvallur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'E. V. Velu',
      position: 'District Head',
      region: 'Tiruvannamalai District',
      district: 'Tiruvannamalai',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'R. Kamaraj',
      position: 'District Head',
      region: 'Tiruvarur District',
      district: 'Tiruvarur',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'C. V. Shanmugam',
      position: 'District Head',
      region: 'Viluppuram District',
      district: 'Viluppuram',
      taluk: 'All',
    ),
    DirectoryLeader(
      name: 'K. K. S. S. R. Ramachandran',
      position: 'District Head',
      region: 'Virudhunagar District',
      district: 'Virudhunagar',
      taluk: 'All',
      village: 'All',
    ),
    // Virudhunagar Taluk specific leaders
    DirectoryLeader(
      name: 'K. Pandiarajan',
      position: 'Taluk Head',
      region: 'Virudhunagar Taluk',
      district: 'Virudhunagar',
      taluk: 'Virudhunagar',
      village: 'All',
    ),
    DirectoryLeader(
      name: 'M. Shenbagaraj',
      position: 'Area Coordinator',
      region: 'Virudhunagar Main',
      district: 'Virudhunagar',
      taluk: 'Virudhunagar',
      village: 'Virudhunagar Main',
    ),
    DirectoryLeader(
      name: 'S. Ponnusamy',
      position: 'Helping Person (Active)',
      region: 'Soolakkarai Area',
      district: 'Virudhunagar',
      taluk: 'Virudhunagar',
      village: 'Soolakkarai',
    ),
    DirectoryLeader(
      name: 'T. Mariappan',
      position: 'Area Coordinator',
      region: 'Allampatti Area',
      district: 'Virudhunagar',
      taluk: 'Virudhunagar',
      village: 'Allampatti',
    ),
    DirectoryLeader(
      name: 'P. Subburaj',
      position: 'Helping Person (Active)',
      region: 'Pandian Nagar Area',
      district: 'Virudhunagar',
      taluk: 'Virudhunagar',
      village: 'Pandian Nagar',
    ),
    // Sattur Taluk specific leaders
    DirectoryLeader(
      name: 'V. Karuppasamy',
      position: 'Taluk Head',
      region: 'Sattur Taluk',
      district: 'Virudhunagar',
      taluk: 'Sattur',
      village: 'All',
    ),
    DirectoryLeader(
      name: 'A. Ramakrishnan',
      position: 'Area Coordinator',
      region: 'Ramalingapuram Village',
      district: 'Virudhunagar',
      taluk: 'Sattur',
      village: 'Ramalingapuram',
    ),
    DirectoryLeader(
      name: 'K. Gurusamy',
      position: 'Helping Person (Active)',
      region: 'Sattur Town Area',
      district: 'Virudhunagar',
      taluk: 'Sattur',
      village: 'Sattur Town',
    ),
  ];

  final Map<String, String> _districtTamilNames = {
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
    'Virudhunagar': 'விருதுநகர்',
  };

  final Map<String, String> _positionTamilNames = {
    'State President': 'மாநிலத் தலைவர்',
    'State General Secretary': 'மாநிலப் பொதுச் செயலாளர்',
    'State IT Wing Head': 'மாநில IT பிரிவுத் தலைவர்',
    'District Head': 'மாவட்டத் தலைவர்',
    'Taluk Head': 'தாலுகா தலைவர்',
    'Ward Head': 'வார்டு தலைவர்',
    'Area Coordinator': 'பகுதி ஒருங்கிணைப்பாளர்',
    'Helping Person (Active)': 'உதவி செய்யும் நபர் (செயலில்)',
  };

  final Map<String, String> _regionTamilNames = {
    'Tamil Nadu (Statewide)': 'தமிழ்நாடு (மாநிலம் முழுவதும்)',
    'Chennai District': 'சென்னை மாவட்டம்',
    'Egmore Taluk': 'எழும்பூர் தாலுகா',
    'Ward 119 (Egmore)': 'வார்டு 119 (எழும்பூர்)',
    'Coimbatore District': 'கோயம்புத்தூர் மாவட்டம்',
    'Madurai District': 'மதுரை மாவட்டம்',
    'Melur Taluk': 'மேலூர் தாலுகா',
    'Salem District': 'சேலம் மாவட்டம்',
    'Trichy District': 'திருச்சி மாவட்டம்',
    'Thanjavur District': 'தஞ்சாவூர் மாவட்டம்',
    'Tirunelveli District': 'திருநெல்வேலி மாவட்டம்',
    'Vellore District': 'வேலூர் மாவட்டம்',
    'Erode District': 'ஈரோடு மாவட்டம்',
    'Kanyakumari District': 'கன்னியாகுமரி மாவட்டம்',
    'Ariyalur District': 'அரியலூர் மாவட்டம்',
    'Chengalpattu District': 'செங்கல்பட்டு மாவட்டம்',
    'Cuddalore District': 'கடலூர் மாவட்டம்',
    'Dharmapuri District': 'தர்மபுரி மாவட்டம்',
    'Dindigul District': 'திண்டுக்கல் மாவட்டம்',
    'Kallakurichi District': 'கள்ளக்குறிச்சி மாவட்டம்',
    'Kanchipuram District': 'காஞ்சிபுரம் மாவட்டம்',
    'Karur District': 'கரூர் மாவட்டம்',
    'Krishnagiri District': 'கிருஷ்ணகிரி மாவட்டம்',
    'Mayiladuthurai District': 'மயிலாடுதுறை மாவட்டம்',
    'Nagapattinam District': 'நாகப்பட்டினம் மாவட்டம்',
    'Namakkal District': 'நாமக்கல் மாவட்டம்',
    'Nilgiris District': 'நீலகிரி மாவட்டம்',
    'Perambalur District': 'பெரம்பலூர் மாவட்டம்',
    'Pudukkottai District': 'புதுக்கோட்டை மாவட்டம்',
    'Ramanathapuram District': 'இராமநாதபுரம் மாவட்டம்',
    'Ranipet District': 'ராணிப்பேட்டை மாவட்டம்',
    'Sivaganga District': 'சிவகங்கை மாவட்டம்',
    'Tenkasi District': 'தென்காசி மாவட்டம்',
    'Theni District': 'தேனி மாவட்டம்',
    'Thoothukudi District': 'தூத்துக்குடி மாவட்டம்',
    'Tirupathur District': 'திருப்பத்தூர் மாவட்டம்',
    'Tiruppur District': 'திருப்பூர் மாவட்டம்',
    'Tiruvallur District': 'திருவள்ளூர் மாவட்டம்',
    'Tiruvannamalai District': 'திருவண்ணாமலை மாவட்டம்',
    'Tiruvarur District': 'திருவாரூர் மாவட்டம்',
    'Viluppuram District': 'விழுப்புரம் மாவட்டம்',
    'Virudhunagar District': 'விருதுநகர் மாவட்டம்',
    'Virudhunagar Main': 'விருதுநகர் மெயின்',
    'Soolakkarai Area': 'சூலக்கரை பகுதி',
    'Allampatti Area': 'அல்லம்பட்டி பகுதி',
    'Pandian Nagar Area': 'பாண்டியன் நகர் பகுதி',
    'Ramalingapuram Village': 'ராமலிங்கபுரம் கிராமம்',
    'Sattur Town Area': 'சாத்தூர் நகர பகுதி',
    'Virudhunagar Taluk': 'விருதுநகர் தாலுகா',
    'Sattur Taluk': 'சாத்தூர் தாலுகா',
  };

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
        _selectedVillage = 'All';
        _filteredTaluks = [];
        _filteredVillages = [];
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
      _selectedVillage = 'All';
      _filteredTaluks = List<String>.from(districtData?['taluks'] ?? []);
      _filteredVillages = [];
    });
  }

  void _onTalukChanged(String taluk) {
    if (taluk == 'All') {
      setState(() {
        _selectedTaluk = 'All';
        _selectedVillage = 'All';
        _filteredVillages = [];
      });
      return;
    }

    final districtData = _districts.firstWhere(
      (d) => d['name'] == _selectedDistrict,
      orElse: () => null,
    );
    final villagesMap = districtData?['talukVillages'] as Map<String, dynamic>?;
    final List<String> villages = villagesMap != null
        ? List<String>.from(villagesMap[taluk] ?? [])
        : [];

    setState(() {
      _selectedTaluk = taluk;
      _selectedVillage = 'All';
      _filteredVillages = villages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    // Filter and dynamically generate leadership records based on selection hierarchy
    final List<DirectoryLeader> filteredLeaders = [];
    if (_selectedDistrict == 'All') {
      filteredLeaders.addAll(_leadersData.where((leader) => leader.district == 'All'));
    } else {
      // 1. Add matching district-level leaders from _leadersData
      final customDistrictLeaders = _leadersData.where((leader) => 
        leader.district == _selectedDistrict && 
        leader.taluk == 'All' && 
        leader.village == 'All'
      ).toList();
      
      if (customDistrictLeaders.isNotEmpty) {
        filteredLeaders.addAll(customDistrictLeaders);
      } else {
        // Fallback: Generate District Leaders deterministically
        filteredLeaders.add(DirectoryLeader(
          name: _generateDeterministicName(_selectedDistrict, 1, false, isTamil),
          position: 'District Head',
          region: isTamil ? '${_districtTamilNames[_selectedDistrict] ?? _selectedDistrict} மாவட்டம்' : '$_selectedDistrict District',
          district: _selectedDistrict,
          taluk: 'All',
          village: 'All',
        ));
        filteredLeaders.add(DirectoryLeader(
          name: _generateDeterministicName(_selectedDistrict, 2, true, isTamil),
          position: 'District Co-Head',
          region: isTamil ? '${_districtTamilNames[_selectedDistrict] ?? _selectedDistrict} மாவட்டம்' : '$_selectedDistrict District',
          district: _selectedDistrict,
          taluk: 'All',
          village: 'All',
        ));
        filteredLeaders.add(DirectoryLeader(
          name: _generateDeterministicName(_selectedDistrict, 3, false, isTamil),
          position: 'Helping Person (Active)',
          region: isTamil ? '${_districtTamilNames[_selectedDistrict] ?? _selectedDistrict} மாவட்டம்' : '$_selectedDistrict District',
          district: _selectedDistrict,
          taluk: 'All',
          village: 'All',
        ));
      }

      // 2. Add Taluk-level leaders
      if (_selectedTaluk == 'All') {
        // For each taluk, see if there's a custom Taluk Head, otherwise generate one
        for (final taluk in _filteredTaluks) {
          final customTalukLeader = _leadersData.firstWhere((leader) => 
            leader.district == _selectedDistrict && 
            leader.taluk == taluk && 
            leader.position == 'Taluk Head',
            orElse: () => DirectoryLeader(
              name: _generateDeterministicName(taluk, 4, false, isTamil),
              position: 'Taluk Head',
              region: isTamil ? '$taluk தாலுகா' : '$taluk Taluk',
              district: _selectedDistrict,
              taluk: taluk,
              village: 'All',
            ),
          );
          filteredLeaders.add(customTalukLeader);
        }
      } else {
        // Specific taluk selected
        final customTalukLeaders = _leadersData.where((leader) => 
          leader.district == _selectedDistrict && 
          leader.taluk == _selectedTaluk && 
          leader.village == 'All'
        ).toList();
        
        if (customTalukLeaders.isNotEmpty) {
          filteredLeaders.addAll(customTalukLeaders);
          final hasHelpingPerson = customTalukLeaders.any((l) => l.position == 'Helping Person (Active)');
          if (!hasHelpingPerson) {
            filteredLeaders.add(DirectoryLeader(
              name: _generateDeterministicName(_selectedTaluk, 5, true, isTamil),
              position: 'Helping Person (Active)',
              region: isTamil ? '$_selectedTaluk தாலுகா' : '$_selectedTaluk Taluk',
              district: _selectedDistrict,
              taluk: _selectedTaluk,
              village: 'All',
            ));
          }
        } else {
          // Generate Taluk leaders
          filteredLeaders.add(DirectoryLeader(
            name: _generateDeterministicName(_selectedTaluk, 4, false, isTamil),
            position: 'Taluk Head',
            region: isTamil ? '$_selectedTaluk தாலுகா' : '$_selectedTaluk Taluk',
            district: _selectedDistrict,
            taluk: _selectedTaluk,
            village: 'All',
          ));
          filteredLeaders.add(DirectoryLeader(
            name: _generateDeterministicName(_selectedTaluk, 5, true, isTamil),
            position: 'Helping Person (Active)',
            region: isTamil ? '$_selectedTaluk தாலுகா' : '$_selectedTaluk Taluk',
            district: _selectedDistrict,
            taluk: _selectedTaluk,
            village: 'All',
          ));
        }

        // 3. Add Village-level leaders
        if (_selectedVillage == 'All') {
          // Add custom village leaders from _leadersData if they match the taluk
          final customVillageLeaders = _leadersData.where((leader) => 
            leader.district == _selectedDistrict && 
            leader.taluk == _selectedTaluk && 
            leader.village != 'All'
          ).toList();
          
          filteredLeaders.addAll(customVillageLeaders);
          
          // Generate Area Coordinators for all other villages under this taluk
          final customVillageNames = customVillageLeaders.map((l) => l.village).toSet();
          for (final village in _filteredVillages) {
            if (!customVillageNames.contains(village)) {
              filteredLeaders.add(DirectoryLeader(
                name: _generateDeterministicName(village, 6, false, isTamil),
                position: 'Area Coordinator',
                region: isTamil ? '$village கிராமம்' : '$village Village',
                district: _selectedDistrict,
                taluk: _selectedTaluk,
                village: village,
              ));
            }
          }
        } else {
          // Specific village selected
          final customVillageLeaders = _leadersData.where((leader) => 
            leader.district == _selectedDistrict && 
            leader.taluk == _selectedTaluk && 
            leader.village == _selectedVillage
          ).toList();
          
          if (customVillageLeaders.isNotEmpty) {
            filteredLeaders.addAll(customVillageLeaders);
            final hasHelpingPerson = customVillageLeaders.any((l) => l.position == 'Helping Person (Active)');
            if (!hasHelpingPerson) {
              filteredLeaders.add(DirectoryLeader(
                name: _generateDeterministicName(_selectedVillage, 7, true, isTamil),
                position: 'Helping Person (Active)',
                region: isTamil ? '$_selectedVillage கிராமம்' : '$_selectedVillage Village',
                district: _selectedDistrict,
                taluk: _selectedTaluk,
                village: _selectedVillage,
              ));
            }
          } else {
            // Generate Village leaders
            filteredLeaders.add(DirectoryLeader(
              name: _generateDeterministicName(_selectedVillage, 6, false, isTamil),
              position: 'Area Coordinator',
              region: isTamil ? '$_selectedVillage கிராமம்' : '$_selectedVillage Village',
              district: _selectedDistrict,
              taluk: _selectedTaluk,
              village: _selectedVillage,
            ));
            filteredLeaders.add(DirectoryLeader(
              name: _generateDeterministicName(_selectedVillage, 7, true, isTamil),
              position: 'Helping Person (Active)',
              region: isTamil ? '$_selectedVillage கிராமம்' : '$_selectedVillage Village',
              district: _selectedDistrict,
              taluk: _selectedTaluk,
              village: _selectedVillage,
            ));
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('leadershipDirectory', ref)),
        actions: [
          // Language Switcher Toggle button inside app bar
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
      body: Column(
        children: [
          // Filter Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
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
                          decoration: InputDecoration(
                            labelText: context.tr('districtLabel', ref),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: const OutlineInputBorder(),
                          ),
                          initialValue: _selectedDistrict,
                          items: [
                            DropdownMenuItem(value: 'All', child: Text(context.tr('allDistricts', ref))),
                            ..._districts.map((d) {
                              final name = d['name'] as String;
                              final displayName = isTamil ? (_districtTamilNames[name] ?? name) : name;
                              return DropdownMenuItem(
                                value: name,
                                child: Text(displayName),
                              );
                            }),
                          ],
                          onChanged: _onDistrictChanged,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Taluk Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: context.tr('talukLabel', ref),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: const OutlineInputBorder(),
                          ),
                          initialValue: _selectedTaluk,
                          items: [
                            DropdownMenuItem(value: 'All', child: Text(context.tr('allTaluks', ref))),
                            ..._filteredTaluks.map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t),
                                )),
                          ],
                          onChanged: (val) {
                            _onTalukChanged(val ?? 'All');
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          
          // Leadership List & Interactive Map
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InteractiveTamilNaduMap(
                    selectedDistrict: _selectedDistrict,
                    onDistrictSelected: _onDistrictChanged,
                  ),
                  const SizedBox(height: 24),
                  if (_selectedDistrict == 'All')
                    _buildStatewideSummary(isDark, isTamil)
                  else
                    _buildDistrictDetailSummary(_selectedDistrict, isDark, isTamil),
                  const SizedBox(height: 24),
                  Text(
                    '${context.tr('leadershipContacts', ref)} (${filteredLeaders.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  if (filteredLeaders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          context.tr('noLeadersFound', ref),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredLeaders.length,
                      itemBuilder: (context, index) {
                        final leader = filteredLeaders[index];
                        final displayPosition = isTamil ? (_positionTamilNames[leader.position] ?? leader.position) : leader.position;
                        final displayRegion = isTamil ? (_regionTamilNames[leader.region] ?? leader.region) : leader.region;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primary,
                              child: Text(
                                leader.name.isNotEmpty ? leader.name[0] : 'L',
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
                                    color: AppTheme.primary.withAlpha(26),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    displayPosition,
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
                                    Expanded(
                                      child: Text(
                                        displayRegion,
                                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Administrative and MLA Summary UI Builders & Data ---



  final Map<String, String> _constituencyTamilNames = const {
    'Kolathur': 'கொளத்தூர்',
    'Chepauk-Thiruvallikeni': 'சேப்பாக்கம்-திருவல்லிக்கேணி',
    'Harbour': 'துறைமுகம்',
    'Perambur': 'பெரம்பூர்',
    'Madurantakam': 'மதுராந்தகம்',
    'Ranipet': 'ராணிப்பேட்டை',
    'Katpadi': 'காட்பாடி',
    'Tiruvannamalai': 'திருவண்ணாமலை',
    'Kallakurichi': 'கள்ளக்குறிச்சி',
    'Salem (North)': 'சேலம் (வடக்கு)',
    'Erode (West)': 'ஈரோடு (மேற்கு)',
    'Coimbatore (North)': 'கோயம்புத்தூர் (வடக்கு)',
    'Coimbatore (South)': 'கோயம்புத்தூர் (தெற்கு)',
    'Athoor': 'ஆத்தூர்',
    'Tiruchirappalli West': 'திருச்சிராப்பள்ளி மேற்கு',
    'Tiruchirappalli (East)': 'திருச்சிராப்பள்ளி (கிழக்கு)',
    'Thanjavur': 'தஞ்சாவூர்',
    'Madurai Central': 'மதுரை மத்திய',
    'Madurai West': 'மதுரை மேற்கு',
    'Virudhunagar': 'விருதுநகர்',
    'Aruppukkottai': 'அருப்புக்கோட்டை',
    'Tiruchendur': 'திருச்செந்தூர்',
    'Radhapuram': 'ராதாபுரம்',
  };

  final Map<String, String> _mlaTamilNames = const {
    'M.K. Stalin': 'மு.க. ஸ்டாலின்',
    'Udhayanidhi Stalin': 'உதயநிதி ஸ்டாலின்',
    'P.K. Sekarbabu': 'பி.கே. சேகர்பாபு',
    'C. Joseph Vijay': 'சி. ஜோசப் விஜய்',
    'Maragatham Kumaravel': 'மரகதம் குமாரவேல்',
    'Thahira': 'தாஹிரா',
    'Dr. M. Sudhakar': 'டாக்டர் எம். சுதாகர்',
    'E.V. Velu': 'எ.வ. வேலு',
    'Arul Vignesh C.': 'அருள் விக்னேஷ் சி.',
    'Sivakumar K.': 'சிவகுமார் கே.',
    'Ananth Moghan K.K.': 'அனந்த் மோகன் கே.கே.',
    'V. Sampathkumar': 'வி. சம்பத்குமார்',
    'V. Senthilbalaji': 'வி. செந்தில்பாலாஜி',
    'I. Periasamy': 'இ. பெரியசாமி',
    'K.N. Nehru': 'கே.என். நேரு',
    'R. Vijayasaravan': 'ஆர். விஜயசரவணன்',
    'Madhar Badhurudeen': 'மாதர் பதுருதீன்',
    'Thangapandi S.R.': 'தங்கப்பாண்டி எஸ்.ஆர்.',
    'Selvam P.': 'செல்வம் பி.',
    'K.K.S.S.R. Ramachandran': 'கே.கே.எஸ்.எஸ்.ஆர். ராமச்சந்திரன்',
    'Anitha R. Radhakrishnan': 'அனிதா ஆர். ராதாகிருஷ்ணன்',
    'Dr. Sathish Christopher': 'டாக்டர் சதீஷ் கிறிஸ்டோபர்',
  };

  Widget _buildStatewideSummary(bool isDark, bool isTamil) {
    final title = isTamil ? 'தமிழ்நாடு நிர்வாகச் சுருக்கம்' : 'Tamil Nadu Administrative Summary';
    
    final List<Map<String, dynamic>> metrics = [
      {
        'label': isTamil ? 'மாவட்டங்கள்' : 'Districts',
        'value': '38',
        'icon': Icons.map_outlined,
      },
      {
        'label': isTamil ? 'வருவாய் கோட்டங்கள்' : 'Revenue Divisions',
        'value': '87',
        'icon': Icons.layers_outlined,
      },
      {
        'label': isTamil ? 'வருவாய் வட்டங்கள் (தாலுகாக்கள்)' : 'Revenue Taluks',
        'value': '310',
        'icon': Icons.account_balance_outlined,
      },
      {
        'label': isTamil ? 'வருவாய் பிர்காக்கள்' : 'Revenue Firkas',
        'value': '1,349',
        'icon': Icons.grid_view_outlined,
      },
      {
        'label': isTamil ? 'வருவாய் கிராமங்கள்' : 'Revenue Villages',
        'value': '17,680',
        'icon': Icons.home_work_outlined,
      },
      {
        'label': isTamil ? 'கிராம ஊராட்சிகள்' : 'Rural Village Panchayats',
        'value': '12,525',
        'icon': Icons.people_outline,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart_outlined, color: AppTheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemCount: metrics.length,
              itemBuilder: (context, index) {
                final metric = metrics[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark 
                        ? Colors.white.withAlpha(12) 
                        : AppTheme.primary.withAlpha(12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark 
                          ? Colors.white.withAlpha(24) 
                          : AppTheme.primary.withAlpha(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        metric['icon'] as IconData,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              metric['value'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.accent : AppTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              metric['label'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistrictDetailSummary(String districtName, bool isDark, bool isTamil) {
    final districtData = _districts.firstWhere(
      (d) => d['name'] == districtName,
      orElse: () => null,
    );
    final List<String> taluks = districtData != null
        ? List<String>.from(districtData['taluks'] ?? [])
        : [];

    final List<dynamic> matchingMLAs = districtData != null
        ? districtData['constituencies'] ?? []
        : [];
    final displayDistrictName = isTamil ? (_districtTamilNames[districtName] ?? districtName) : districtName;

    final taluksTitle = isTamil ? '$displayDistrictName மாவட்டத்தின் வட்டங்கள் (தாலுகாக்கள்)' : 'Taluks in $displayDistrictName District';
    final mlasTitle = isTamil ? 'சட்டமன்றத் தொகுதிகள் & உறுப்பினர்கள் (MLA)' : 'Assembly Constituencies & Elected MLAs';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_city_outlined, color: AppTheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  displayDistrictName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_selectedTaluk != 'All')
                  TextButton.icon(
                    onPressed: () {
                      _onTalukChanged('All');
                    },
                    icon: const Icon(Icons.clear, size: 14, color: AppTheme.primary),
                    label: Text(
                      isTamil ? 'வட்டத்தை மீட்டமை' : 'Clear Taluk',
                      style: const TextStyle(fontSize: 12, color: AppTheme.primary),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            
            // Taluks Wrap Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.grid_3x3_outlined, color: AppTheme.accent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      taluksTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (taluks.isEmpty)
                  Text(
                    isTamil ? 'வட்டங்கள் எதுவும் கிடைக்கவில்லை.' : 'No sub-places found.',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: taluks.map((taluk) {
                      final isSelected = _selectedTaluk == taluk;
                      return ChoiceChip(
                        label: Text(
                          taluk,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppTheme.primary,
                        backgroundColor: isDark ? Colors.white.withAlpha(12) : AppTheme.primary.withAlpha(12),
                        onSelected: (selected) {
                          _onTalukChanged(selected ? taluk : 'All');
                        },
                      );
                    }).toList(),
                  ),
              ],
            ),
            
            // Sub-places / Villages Section
            if (_selectedTaluk != 'All' && _filteredVillages.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.holiday_village_outlined, color: AppTheme.accent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isTamil ? 'கிராமங்கள் / பகுதிகள்' : 'Sub-urban Villages / Areas',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      if (_selectedVillage != 'All')
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedVillage = 'All';
                            });
                          },
                          icon: const Icon(Icons.clear, size: 14, color: AppTheme.primary),
                          label: Text(
                            isTamil ? 'பகுதியை மீட்டமை' : 'Clear Area',
                            style: const TextStyle(fontSize: 12, color: AppTheme.primary),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(
                          isTamil ? 'அனைத்து பகுதிகள்' : 'All Areas',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: _selectedVillage == 'All' ? FontWeight.bold : FontWeight.normal,
                            color: _selectedVillage == 'All'
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        selected: _selectedVillage == 'All',
                        selectedColor: AppTheme.primary,
                        backgroundColor: isDark ? Colors.white.withAlpha(12) : AppTheme.primary.withAlpha(12),
                        onSelected: (selected) {
                          setState(() {
                            _selectedVillage = 'All';
                          });
                        },
                      ),
                      ..._filteredVillages.map((village) {
                        final isSelected = _selectedVillage == village;
                        final displayVillage = isTamil ? (_villageTamilNames[village] ?? village) : village;
                        return ChoiceChip(
                          label: Text(
                            displayVillage,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.primary,
                          backgroundColor: isDark ? Colors.white.withAlpha(12) : AppTheme.primary.withAlpha(12),
                          onSelected: (selected) {
                            setState(() {
                              _selectedVillage = selected ? village : 'All';
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 20),
            const Divider(height: 24),
            
            // Assembly MLA List Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.how_to_reg_outlined, color: AppTheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      mlasTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (matchingMLAs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.grey, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isTamil
                                ? 'இம்மாவட்டத்திற்குரிய சட்டமன்ற உறுப்பினர் விவரங்கள் தற்சமயம் இல்லை.'
                                : 'No assembly constituency data defined for this district.',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: matchingMLAs.length,
                    itemBuilder: (context, index) {
                      final item = matchingMLAs[index];
                      final String constituencyName = item['name']?.toString() ?? '';
                      final String memberName = item['member']?.toString() ?? '';
                      final displayConstituency = isTamil
                          ? (_constituencyTamilNames[constituencyName] ?? constituencyName)
                          : constituencyName;
                      final displayMLA = isTamil
                          ? (_mlaTamilNames[memberName] ?? memberName)
                          : memberName;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? Colors.white.withAlpha(12) : Colors.black.withAlpha(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_pin_outlined,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayConstituency,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isTamil ? 'தொகுதி' : 'Constituency',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  displayMLA,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? AppTheme.accent : AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isTamil ? 'சட்டமன்ற உறுப்பினர் (MLA)' : 'Elected MLA',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  final Map<String, String> _villageTamilNames = const {
    'Virudhunagar Main': 'விருதுநகர் மெயின்',
    'Soolakkarai': 'சூலக்கரை',
    'Allampatti': 'அல்லம்பட்டி',
    'Pandian Nagar': 'பாண்டியன் நகர்',
    'Ramalingapuram': 'ராமலிங்கபுரம்',
    'Sattur Town': 'சாத்தூர் நகரம்',
    'Padanthal': 'பதந்தால்',
    'Venkatachalapuram': 'வெங்கடாசலபுரம்',
    'Ward 119 (Egmore)': 'வார்டு 119 (எழும்பூர்)',
    'Egmore Station Area': 'எழும்பூர் நிலைய பகுதி',
    'Spurtank Road': 'ஸ்பர்டேங்க் சாலை',
  };

  String _generateDeterministicName(String key, int seed, bool isFemale, bool isTamil) {
    final List<Map<String, String>> initials = [
      {'en': 'K.', 'ta': 'கே.'},
      {'en': 'M.', 'ta': 'எம்.'},
      {'en': 'A.', 'ta': 'ஏ.'},
      {'en': 'R.', 'ta': 'ஆர்.'},
      {'en': 'S.', 'ta': 'எஸ்.'},
      {'en': 'P.', 'ta': 'பி.'},
      {'en': 'T.', 'ta': 'டி.'},
      {'en': 'V.', 'ta': 'வி.'},
      {'en': 'N.', 'ta': 'என்.'},
      {'en': 'G.', 'ta': 'ஜி.'},
      {'en': 'D.', 'ta': 'டி.'},
      {'en': 'J.', 'ta': 'ஜே.'},
    ];

    final List<Map<String, String>> maleNames = [
      {'en': 'Anbarasan', 'ta': 'அன்பரசன்'},
      {'en': 'Balaji', 'ta': 'பாலாஜி'},
      {'en': 'Chinnasamy', 'ta': 'சின்னசாமி'},
      {'en': 'Durairaj', 'ta': 'துரைராஜ்'},
      {'en': 'Elangovan', 'ta': 'இளங்கோவன்'},
      {'en': 'Ganesh', 'ta': 'கணேஷ்'},
      {'en': 'Hariharan', 'ta': 'ஹரிஹரன்'},
      {'en': 'Iniyan', 'ta': 'இனியன்'},
      {'en': 'Jegadeesan', 'ta': 'ஜெகதீசன்'},
      {'en': 'Kathirvel', 'ta': 'கதிர்வேல்'},
      {'en': 'Loganathan', 'ta': 'லோகநாதன்'},
      {'en': 'Muthu', 'ta': 'முத்து'},
      {'en': 'Natarajan', 'ta': 'நடராஜன்'},
      {'en': 'Palani', 'ta': 'பழனி'},
      {'en': 'Rajarajan', 'ta': 'ராஜராஜன்'},
      {'en': 'Saravanan', 'ta': 'சரவணன்'},
      {'en': 'Thangavel', 'ta': 'தங்கவேல்'},
      {'en': 'Uthayakumar', 'ta': 'உதயகுமார்'},
      {'en': 'Velmurugan', 'ta': 'வேல்முருகன்'},
      {'en': 'Yuvaraj', 'ta': 'யுவராஜ்'},
      {'en': 'Senthil', 'ta': 'செந்தில்'},
      {'en': 'Selvam', 'ta': 'செல்வம்'},
      {'en': 'Karthikeyan', 'ta': 'கார்த்திகேயன்'},
      {'en': 'Manikandan', 'ta': 'மணிகண்டன்'},
      {'en': 'Prabhu', 'ta': 'பிரபு'},
      {'en': 'Ramesh', 'ta': 'ரமேஷ்'},
      {'en': 'Suresh', 'ta': 'சுரேஷ்'},
      {'en': 'Kumaran', 'ta': 'குமரன்'},
      {'en': 'Arun', 'ta': 'அருண்'},
      {'en': 'Vijay', 'ta': 'விஜய்'},
    ];

    final List<Map<String, String>> femaleNames = [
      {'en': 'Anitha', 'ta': 'அனிதா'},
      {'en': 'Bhuvaneswari', 'ta': 'புவனேஸ்வரி'},
      {'en': 'Chithra', 'ta': 'சித்ரா'},
      {'en': 'Devika', 'ta': 'தேவிகா'},
      {'en': 'Ezhilarasi', 'ta': 'எழிலரசி'},
      {'en': 'Gayathri', 'ta': 'காயத்ரி'},
      {'en': 'Haripriya', 'ta': 'ஹரிப்ரியா'},
      {'en': 'Indhumathi', 'ta': 'இந்துமதி'},
      {'en': 'Janaki', 'ta': 'ஜானகி'},
      {'en': 'Kavitha', 'ta': 'கவிதா'},
      {'en': 'Latha', 'ta': 'லதா'},
      {'en': 'Meenakshi', 'ta': 'மீனாக்ஷி'},
      {'en': 'Nandhini', 'ta': 'நந்தினி'},
      {'en': 'Oviya', 'ta': 'ஓவியா'},
      {'en': 'Priyadharshini', 'ta': 'பிரியதர்ஷினி'},
      {'en': 'Radha', 'ta': 'ராதா'},
      {'en': 'Selvi', 'ta': 'செல்வி'},
      {'en': 'Thangam', 'ta': 'தங்கம்'},
      {'en': 'Uma', 'ta': 'உமா'},
      {'en': 'Vidya', 'ta': 'வித்யா'},
      {'en': 'Yamuna', 'ta': 'யமுனா'},
      {'en': 'Kokila', 'ta': 'கோகிலா'},
      {'en': 'Deepa', 'ta': 'தீபா'},
      {'en': 'Sangeetha', 'ta': 'சங்கீதா'},
      {'en': 'Punitha', 'ta': 'புனிதா'},
      {'en': 'Revathi', 'ta': 'ரேவதி'},
      {'en': 'Geetha', 'ta': 'கீதா'},
      {'en': 'Malathi', 'ta': 'மாலதி'},
      {'en': 'Sudha', 'ta': 'சுதா'},
      {'en': 'Preema', 'ta': 'பிரீமா'},
    ];

    int hash = 0;
    for (int i = 0; i < key.length; i++) {
      hash += key.codeUnitAt(i);
    }
    hash += seed;

    final initialObj = initials[hash % initials.length];
    final nameObjList = isFemale ? femaleNames : maleNames;
    final nameObj = nameObjList[hash % nameObjList.length];

    final String langKey = isTamil ? 'ta' : 'en';
    return '${initialObj[langKey]} ${nameObj[langKey]}';
  }
}

class InteractiveTamilNaduMap extends ConsumerStatefulWidget {
  final String selectedDistrict;
  final ValueChanged<String> onDistrictSelected;

  const InteractiveTamilNaduMap({
    super.key,
    required this.selectedDistrict,
    required this.onDistrictSelected,
  });

  @override
  ConsumerState<InteractiveTamilNaduMap> createState() => _InteractiveTamilNaduMapState();
}

class _InteractiveTamilNaduMapState extends ConsumerState<InteractiveTamilNaduMap> {
  late final Map<String, Path> _paths;
  late final Rect _mapBounds;
  String? _hoveredDistrict;

  @override
  void initState() {
    super.initState();
    _paths = TamilNaduPaths.getPaths();
    _mapBounds = _calculateBounds();
  }

  Rect _calculateBounds() {
    Rect? bounds;
    for (final path in _paths.values) {
      if (bounds == null) {
        bounds = path.getBounds();
      } else {
        bounds = bounds.expandToInclude(path.getBounds());
      }
    }
    return bounds ?? Rect.zero;
  }

  String? _getDistrictAt(Offset localPosition, Size size) {
    if (_mapBounds.isEmpty) return null;

    double scaleX = size.width / _mapBounds.width;
    double scaleY = size.height / _mapBounds.height;
    double scale = scaleX < scaleY ? scaleX : scaleY;

    double dx = (size.width - _mapBounds.width * scale) / 2 - _mapBounds.left * scale;
    double dy = (size.height - _mapBounds.height * scale) / 2 - _mapBounds.top * scale;

    final tapOffset = Offset(
      (localPosition.dx - dx) / scale,
      (localPosition.dy - dy) / scale,
    );

    for (var entry in _paths.entries) {
      if (entry.value.contains(tapOffset)) {
        return entry.key;
      }
    }
    return null;
  }

  void _handleTap(TapUpDetails details, Size size) {
    final tapped = _getDistrictAt(details.localPosition, size);
    if (tapped != null) {
      widget.onDistrictSelected(tapped);
    } else {
      widget.onDistrictSelected('All');
    }
  }

  void _handleHover(PointerEvent event, Size size) {
    final hovered = _getDistrictAt(event.localPosition, size);
    if (hovered != _hoveredDistrict) {
      setState(() {
        _hoveredDistrict = hovered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTamil = ref.watch(languageProvider) == AppLanguage.tamil;

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          context.tr('mapTitle', ref),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.tr('mapSubtitle', ref),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: double.infinity,
            height: 480, // Map height enlarged from 380 to 480 for better visibility
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark.withAlpha(128) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withAlpha(38)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 51 : 8),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, constraints.maxHeight);
                  return MouseRegion(
                    onHover: (event) => _handleHover(event, size),
                    onExit: (_) {
                      setState(() {
                        _hoveredDistrict = null;
                      });
                    },
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTapUp: (details) => _handleTap(details, size),
                      child: CustomPaint(
                        size: size,
                        painter: TamilNaduMapPainter(
                          paths: _paths,
                          selectedDistrict: widget.selectedDistrict,
                          hoveredDistrict: _hoveredDistrict,
                          mapBounds: _mapBounds,
                          isDark: isDark,
                          primaryColor: AppTheme.primary,
                          accentColor: AppTheme.accent,
                          isTamil: isTamil,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.selectedDistrict != 'All') ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => widget.onDistrictSelected('All'),
            icon: const Icon(Icons.clear, size: 16, color: AppTheme.primary),
            label: Text(
              context.tr('resetMapFilter', ref),
              style: const TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }
}

class TamilNaduMapPainter extends CustomPainter {
  final Map<String, Path> paths;
  final String selectedDistrict;
  final String? hoveredDistrict;
  final Rect mapBounds;
  final bool isDark;
  final Color primaryColor;
  final Color accentColor;
  final bool isTamil;

  TamilNaduMapPainter({
    required this.paths,
    required this.selectedDistrict,
    required this.hoveredDistrict,
    required this.mapBounds,
    required this.isDark,
    required this.primaryColor,
    required this.accentColor,
    required this.isTamil,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (mapBounds.isEmpty) return;

    double scaleX = size.width / mapBounds.width;
    double scaleY = size.height / mapBounds.height;
    double scale = scaleX < scaleY ? scaleX : scaleY;

    double dx = (size.width - mapBounds.width * scale) / 2 - mapBounds.left * scale;
    double dy = (size.height - mapBounds.height * scale) / 2 - mapBounds.top * scale;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    // Paints
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Draw base districts
    paths.forEach((name, path) {
      if (name != selectedDistrict && name != hoveredDistrict) {
        if (name == 'Chennai') {
          // Highlight Chennai to be more visible even when not selected/hovered
          fillPaint.color = isDark 
              ? accentColor.withAlpha(38) // 0.15 opacity
              : primaryColor.withAlpha(20); // 0.08 opacity
          borderPaint.color = isDark 
              ? accentColor.withAlpha(204) // 0.8 opacity
              : primaryColor.withAlpha(128); // 0.5 opacity
          borderPaint.strokeWidth = 1.5 / scale;
        } else {
          fillPaint.color = isDark 
              ? Colors.white.withAlpha(10) // 0.04 opacity
              : primaryColor.withAlpha(8); // 0.03 opacity
          borderPaint.color = isDark 
              ? Colors.white24 
              : primaryColor.withAlpha(64); // 0.25 opacity
          borderPaint.strokeWidth = 1.0 / scale;
        }

        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, borderPaint);
      }
    });

    // 2. Draw hovered district
    if (hoveredDistrict != null && hoveredDistrict != selectedDistrict && paths.containsKey(hoveredDistrict)) {
      final path = paths[hoveredDistrict]!;
      fillPaint.color = isDark 
          ? Colors.white.withAlpha(31) // 0.12 opacity
          : primaryColor.withAlpha(26); // 0.1 opacity
      borderPaint.color = isDark 
          ? Colors.white54 
          : primaryColor.withAlpha(115); // 0.45 opacity
      borderPaint.strokeWidth = 1.6 / scale;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, borderPaint);
    }

    // 3. Draw selected district on top
    if (paths.containsKey(selectedDistrict)) {
      final path = paths[selectedDistrict]!;
      fillPaint.color = accentColor.withAlpha(90); // 0.35 opacity
      borderPaint.color = accentColor;
      borderPaint.strokeWidth = 2.5 / scale;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, borderPaint);
    }

    // 4. Draw labels for all districts
    paths.forEach((name, path) {
      final isSelected = name == selectedDistrict;
      final isHovered = name == hoveredDistrict;
      
      final bounds = path.getBounds();
      final center = bounds.center;

      // Adjust label position for specific districts if needed to center them better
      Offset labelCenter = center;
      if (name == 'Chennai') {
        labelCenter = Offset(center.dx + 2, center.dy);
      }

      final String displayName = _getAbbreviatedName(name);

      // Chennai label is always drawn and styled prominently
      double fontSize = (isSelected || isHovered ? 8.0 : 6.0) / scale;
      if (name == 'Chennai' && !isSelected && !isHovered) {
        fontSize = 7.5 / scale;
      }

      final FontWeight fontWeight = (isSelected || isHovered || name == 'Chennai') 
          ? FontWeight.bold 
          : FontWeight.normal;

      Color textColor = isSelected
          ? (isDark ? Colors.amberAccent : Colors.teal.shade700)
          : (isHovered 
              ? (isDark ? Colors.white : primaryColor)
              : (isDark ? Colors.white60 : Colors.black87));
      if (name == 'Chennai' && !isSelected && !isHovered) {
        textColor = isDark ? Colors.amberAccent : primaryColor;
      }

      final textOffset = Offset(
        labelCenter.dx,
        labelCenter.dy,
      );

      // 4a. Draw text outline for contrast
      final outlinePainter = TextPainter(
        text: TextSpan(
          text: displayName,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0 / scale
              ..color = isDark ? Colors.black87 : Colors.white70,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      outlinePainter.paint(
        canvas,
        Offset(textOffset.dx - outlinePainter.width / 2, textOffset.dy - outlinePainter.height / 2),
      );

      // 4b. Draw text fill
      final fillPainter = TextPainter(
        text: TextSpan(
          text: displayName,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      fillPainter.paint(
        canvas,
        Offset(textOffset.dx - fillPainter.width / 2, textOffset.dy - fillPainter.height / 2),
      );
    });

    canvas.restore();
  }

  String _getAbbreviatedName(String name) {
    if (isTamil) {
      switch (name) {
        case 'Ariyalur': return 'அரியலூர்';
        case 'Chengalpattu': return 'செங்கை';
        case 'Chennai': return 'சென்னை';
        case 'Coimbatore': return 'கோவை';
        case 'Cuddalore': return 'கடலூர்';
        case 'Dharmapuri': return 'தர்மபுரி';
        case 'Dindigul': return 'திண்டுக்கல்';
        case 'Erode': return 'ஈரோடு';
        case 'Kallakurichi': return 'கள்ளக்குறிச்சி';
        case 'Kanchipuram': return 'காஞ்சி';
        case 'Kanyakumari': return 'குமரி';
        case 'Karur': return 'கரூர்';
        case 'Krishnagiri': return 'கிரி';
        case 'Madurai': return 'மதுரை';
        case 'Mayiladuthurai': return 'மயிலாடு';
        case 'Nagapattinam': return 'நாகை';
        case 'Namakkal': return 'நாமக்கல்';
        case 'Nilgiris': return 'நீலகிரி';
        case 'Perambalur': return 'பெரம்பலூர்';
        case 'Pudukkottai': return 'புதுக்கோட்டை';
        case 'Ramanathapuram': return 'ராம்நாடு';
        case 'Ranipet': return 'ராணிப்பேட்டை';
        case 'Salem': return 'சேலம்';
        case 'Sivaganga': return 'சிவகங்கை';
        case 'Tenkasi': return 'தென்காசி';
        case 'Thanjavur': return 'தஞ்சை';
        case 'Theni': return 'தேனி';
        case 'Thoothukudi': return 'தூத்துக்குடி';
        case 'Tiruchirappalli': return 'திருச்சி';
        case 'Tirunelveli': return 'நெல்லை';
        case 'Tirupathur': return 'திருப்பத்தூர்';
        case 'Tiruppur': return 'திருப்பூர்';
        case 'Tiruvallur': return 'திருவள்ளூர்';
        case 'Tiruvannamalai': return 'தி.மலை';
        case 'Tiruvarur': return 'திருவாரூர்';
        case 'Vellore': return 'வேலூர்';
        case 'Viluppuram': return 'விழுப்புரம்';
        case 'Virudhunagar': return 'வி.நகர்';
        default: return name;
      }
    } else {
      switch (name) {
        case 'Tiruchirappalli': return 'Trichy';
        case 'Tiruvannamalai': return 'T.Malai';
        case 'Ramanathapuram': return 'Ramnad';
        case 'Kanyakumari': return 'K.Kumari';
        case 'Virudhunagar': return 'V.Nagar';
        case 'Chengalpattu': return 'C.Pattu';
        case 'Mayiladuthurai': return 'Mayiladuthu';
        case 'Pudukkottai': return 'P.Kottai';
        case 'Thoothukudi': return 'Thoothu';
        case 'Nagapattinam': return 'Nagai';
        case 'Coimbatore': return 'Kovai';
        case 'Krishnagiri': return 'K.Giri';
        case 'Dharmapuri': return 'D.Puri';
        case 'Kallakurichi': return 'K.Kurichi';
        case 'Kanchipuram': return 'Kanchi';
        case 'Nilgiris': return 'Nilgiris';
        default: return name;
      }
    }
  }

  @override
  bool shouldRepaint(covariant TamilNaduMapPainter oldDelegate) {
    return oldDelegate.selectedDistrict != selectedDistrict ||
        oldDelegate.hoveredDistrict != hoveredDistrict ||
        oldDelegate.isDark != isDark ||
        oldDelegate.mapBounds != mapBounds ||
        oldDelegate.isTamil != isTamil;
  }
}
