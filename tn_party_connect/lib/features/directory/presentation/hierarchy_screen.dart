import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class HierarchyScreen extends StatefulWidget {
  const HierarchyScreen({super.key});

  @override
  State<HierarchyScreen> createState() => _HierarchyScreenState();
}

class _HierarchyScreenState extends State<HierarchyScreen> {
  // Collapsible state tracking map
  final Map<String, bool> _expansionStates = {};

  void _toggleExpanded(String key) {
    setState(() {
      _expansionStates[key] = !(_expansionStates[key] ?? false);
    });
  }

  bool _isExpanded(String key) {
    return _expansionStates[key] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizational Hierarchy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Party Hierarchy Tree Explorer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Expand nodes to explore administrative divisions of Tamil Nadu.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Base Root (Level 0: Tamil Nadu State Command)
            _buildNode(
              title: 'Tamil Nadu (State Command)',
              subtitle: 'State Executive Committee',
              level: 0,
              expandedKey: 'state_root',
              children: [
                // Level 1: Chennai District
                _buildNode(
                  title: 'Chennai District',
                  subtitle: 'District Secretariat',
                  level: 1,
                  expandedKey: 'dist_chennai',
                  children: [
                    // Level 2: Egmore Taluk
                    _buildNode(
                      title: 'Egmore Taluk',
                      subtitle: 'Taluk Coordinating Committee',
                      level: 2,
                      expandedKey: 'tal_egmore',
                      children: [
                        // Level 3: Ward 119
                        _buildNode(
                          title: 'Ward 119',
                          subtitle: 'Ward Unit Committee (1,240 Members)',
                          level: 3,
                          expandedKey: 'ward_119',
                        ),
                        _buildNode(
                          title: 'Ward 120',
                          subtitle: 'Ward Unit Committee (980 Members)',
                          level: 3,
                          expandedKey: 'ward_120',
                        ),
                      ],
                    ),
                    // Level 2: Mylapore Taluk
                    _buildNode(
                      title: 'Mylapore Taluk',
                      subtitle: 'Taluk Committee',
                      level: 2,
                      expandedKey: 'tal_mylapore',
                      children: [
                        _buildNode(
                          title: 'Ward 142',
                          subtitle: 'Ward Unit (750 Members)',
                          level: 3,
                          expandedKey: 'ward_142',
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Level 1: Madurai District
                _buildNode(
                  title: 'Madurai District',
                  subtitle: 'District Committee',
                  level: 1,
                  expandedKey: 'dist_madurai',
                  children: [
                    _buildNode(
                      title: 'Melur Taluk',
                      subtitle: 'Taluk Committee',
                      level: 2,
                      expandedKey: 'tal_melur',
                      children: [
                        _buildNode(
                          title: 'Ward 5',
                          subtitle: 'Ward Unit (610 Members)',
                          level: 3,
                          expandedKey: 'ward_5',
                        ),
                      ],
                    ),
                  ],
                ),

                // Level 1: Coimbatore District
                _buildNode(
                  title: 'Coimbatore District',
                  subtitle: 'District Committee',
                  level: 1,
                  expandedKey: 'dist_coimbatore',
                  children: [
                    _buildNode(
                      title: 'Pollachi Taluk',
                      subtitle: 'Taluk Committee',
                      level: 2,
                      expandedKey: 'tal_pollachi',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNode({
    required String title,
    required String subtitle,
    required int level,
    required String expandedKey,
    List<Widget>? children,
  }) {
    final hasChildren = children != null && children.isNotEmpty;
    final expanded = _isExpanded(expandedKey);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Set indentation padding based on level
    final double leftPadding = level * 16.0;

    // Node icon mapping
    IconData nodeIcon;
    Color nodeColor;
    if (level == 0) {
      nodeIcon = Icons.account_balance;
      nodeColor = AppTheme.primary;
    } else if (level == 1) {
      nodeIcon = Icons.map;
      nodeColor = Colors.blue;
    } else if (level == 2) {
      nodeIcon = Icons.location_city;
      nodeColor = Colors.orange;
    } else {
      nodeIcon = Icons.numbers;
      nodeColor = Colors.teal;
    }

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            elevation: 1,
            child: InkWell(
              onTap: hasChildren ? () => _toggleExpanded(expandedKey) : null,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: nodeColor.withOpacity(0.1),
                      child: Icon(nodeIcon, color: nodeColor, size: 18),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            subtitle,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    if (hasChildren)
                      Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (hasChildren && expanded) ...[
            const SizedBox(height: 8),
            // Indent child widgets recursively
            ...children,
          ],
        ],
      ),
    );
  }
}
