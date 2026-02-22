import 'package:flutter/material.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/services/university_service.dart';
import 'package:animate_do/animate_do.dart';
import 'creative_generator_screen.dart';

class MarketingToolsScreen extends StatefulWidget {
  const MarketingToolsScreen({super.key});

  @override
  State<MarketingToolsScreen> createState() => _MarketingToolsScreenState();
}

class _MarketingToolsScreenState extends State<MarketingToolsScreen> {
  bool _isLoading = true;
  List<dynamic> _universities = [];
  List<Map<String, dynamic>> _allAssets = [];
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

      // Flatten assets from universities
      List<Map<String, dynamic>> assets = [];
      for (var uni in universities) {
        final docs = List<String>.from(uni['documents'] ?? []);
        for (var doc in docs) {
          // Determine category based on filename or dummy mapping
          String category = 'Brochures'; // Default
          if (doc.toLowerCase().contains('poster')) category = 'Posters';
          if (doc.toLowerCase().contains('template')) category = 'Templates';

          assets.add({
            'universityName': uni['name'],
            'universityId': uni['_id'] ?? uni['id'],
            'url': doc,
            'fileName': doc.split('/').last,
            'category': category,
          });
        }
      }

      if (mounted) {
        setState(() {
          _universities = universities;
          _allAssets = assets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredAssets {
    if (_selectedCategory == 'All') return _allAssets;
    return _allAssets.where((a) => a['category'] == _selectedCategory).toList();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreativeGeneratorScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate Creative'),
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
          final asset = _filteredAssets[index];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * (index % 10)),
            child: _buildAssetCard(asset),
          );
        }, childCount: _filteredAssets.length),
      ),
    );
  }

  Widget _buildAssetCard(Map<String, dynamic> asset) {
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
                  tag: 'asset_${asset['url']}',
                  child: Icon(
                    asset['category'] == 'Posters'
                        ? Icons.image_rounded
                        : Icons.picture_as_pdf_rounded,
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
                  asset['universityName'] ?? 'University',
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
                  asset['fileName'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(Icons.share_rounded, Colors.green, () {
                      _shareAsset(asset);
                    }),
                    _buildIconButton(
                      Icons.download_rounded,
                      AppTheme.primaryBlue,
                      () {
                        _downloadAsset(asset);
                      },
                    ),
                    _buildIconButton(
                      Icons.remove_red_eye_rounded,
                      Colors.orange,
                      () {
                        _viewAsset(asset);
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
