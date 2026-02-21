import 'package:flutter/material.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/services/university_service.dart';
import 'package:animate_do/animate_do.dart';

class MarketingToolsScreen extends StatefulWidget {
  const MarketingToolsScreen({super.key});

  @override
  State<MarketingToolsScreen> createState() => _MarketingToolsScreenState();
}

class _MarketingToolsScreenState extends State<MarketingToolsScreen> {
  bool _isLoading = true;
  List<dynamic> _universities = [];
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Posters', 'Brochures', 'Templates'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final universities = await UniversityService.getUniversities();
      if (mounted) {
        setState(() {
          _universities = universities;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildHeader(),
                _buildCategoryFilter(),
                _buildMarketingGrid(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: const Text(
                'Marketing & Assets',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.charcoal,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'Download and share university brochures and posters',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedCategory = category);
                },
                selectedColor: AppTheme.primaryBlue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.charcoal,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: AppTheme.white,
                elevation: isSelected ? 4 : 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMarketingGrid() {
    if (_universities.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('No marketing assets found')),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final university = _universities[index];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            child: _buildAssetCard(university),
          );
        }, childCount: _universities.length),
      ),
    );
  }

  Widget _buildAssetCard(Map<String, dynamic> university) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Hero(
                  tag: 'uni_logo_${university['_id']}',
                  child: Icon(
                    Icons.school_rounded,
                    size: 60,
                    color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university['name'] ?? 'University',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'University Brochure',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(Icons.share_rounded, Colors.green, () {
                      _shareAsset(university);
                    }),
                    _buildIconButton(
                      Icons.download_rounded,
                      AppTheme.primaryBlue,
                      () {
                        _downloadAsset(university);
                      },
                    ),
                    _buildIconButton(
                      Icons.remove_red_eye_rounded,
                      Colors.orange,
                      () {
                        _viewAsset(university);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  void _shareAsset(Map<String, dynamic> university) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${university['name']} brochure via WhatsApp...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadAsset(Map<String, dynamic> university) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${university['name']} brochure...'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _viewAsset(Map<String, dynamic> university) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${university['name']} brochure...'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
