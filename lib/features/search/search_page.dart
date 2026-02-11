import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quang_ninh_travel/app/themes/app_colors.dart';
import 'package:quang_ninh_travel/app/themes/app_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'all';
  bool _hasSearched = false;

  final categories = [
    {'key': 'all', 'icon': Icons.apps, 'label': 'All'},
    {'key': 'hotels', 'icon': Icons.hotel, 'label': 'Hotels'},
    {'key': 'cruises', 'icon': Icons.directions_boat, 'label': 'Cruises'},
    {'key': 'tours', 'icon': Icons.tour, 'label': 'Tours'},
    {'key': 'restaurants', 'icon': Icons.restaurant, 'label': 'Restaurants'},
    {'key': 'transport', 'icon': Icons.directions_car, 'label': 'Transport'},
  ];

  // Mock search results
  final _results = [
    {'type': 'hotel', 'name': 'Hotel Paradise Premium', 'subtitle': 'hotel_location', 'price': '\$120/night', 'rating': '4.8', 'icon': Icons.hotel},
    {'type': 'cruise', 'name': 'Quang Ninh Luxury Cruise', 'subtitle': 'cruise_2d1n', 'price': '\$250/person', 'rating': '4.9', 'icon': Icons.directions_boat},
    {'type': 'tour', 'name': 'Quang Ninh Adventure Explorer', 'subtitle': '3 Days', 'price': '\$200/person', 'rating': '4.8', 'icon': Icons.tour},
    {'type': 'restaurant', 'name': 'Nhà hàng Phố Biển', 'subtitle': 'Seafood', 'price': '\$\$', 'rating': '4.7', 'icon': Icons.restaurant},
    {'type': 'hotel', 'name': 'Quang Ninh Bay Resort', 'subtitle': 'hotel_location', 'price': '\$180/night', 'rating': '4.7', 'icon': Icons.hotel},
    {'type': 'cruise', 'name': 'Standard Sunset Cruise', 'subtitle': 'cruise_1d', 'price': '\$120/person', 'rating': '4.6', 'icon': Icons.directions_boat},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search_title'.tr),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => setState(() => _hasSearched = true),
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textLight),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _hasSearched = false);
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.backgroundLight,
              ),
            ),
          ),

          // Category Filter
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategory == cat['key'];
                return Container(
                  margin: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat['icon'] as IconData, size: 16,
                          color: isSelected ? Colors.white : AppColors.textMedium),
                        const SizedBox(width: 4),
                        Text(cat['label'] as String),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textMedium,
                      fontSize: 13,
                    ),
                    onSelected: (_) => setState(() {
                      _selectedCategory = cat['key'] as String;
                      _hasSearched = true;
                    }),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),

          // Results
          Expanded(
            child: !_hasSearched
                ? _buildSuggestions(context)
                : _buildResults(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('popular_searches'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppTheme.spacingM),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('Ha Long Bay Cruise'),
              _buildSuggestionChip('Luxury Hotel'),
              _buildSuggestionChip('Seafood Restaurant'),
              _buildSuggestionChip('Island Tour'),
              _buildSuggestionChip('Bai Chay Beach'),
              _buildSuggestionChip('Yen Tu Mountain'),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text('recent_searches'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppTheme.spacingM),
          _buildRecentItem(context, 'Hotel Paradise', Icons.hotel),
          _buildRecentItem(context, 'Sunset Cruise', Icons.directions_boat),
          _buildRecentItem(context, 'Nhà hàng Phố Biển', Icons.restaurant),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 13)),
      onPressed: () {
        _searchController.text = text;
        setState(() => _hasSearched = true);
      },
      backgroundColor: AppColors.primaryBlue.withOpacity(0.08),
      side: BorderSide.none,
    );
  }

  Widget _buildRecentItem(BuildContext context, String text, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textLight),
      title: Text(text),
      trailing: const Icon(Icons.north_west, size: 16, color: AppColors.textLight),
      onTap: () {
        _searchController.text = text;
        setState(() => _hasSearched = true);
      },
    );
  }

  Widget _buildResults(BuildContext context) {
    final filtered = _selectedCategory == 'all'
        ? _results
        : _results.where((r) => r['type'] == _selectedCategory.replaceAll('s', '')).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textLight),
            const SizedBox(height: AppTheme.spacingM),
            Text('no_results'.tr, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textLight)),
            Text('try_different'.tr, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppTheme.spacingM),
            leading: Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Icon(item['icon'] as IconData, color: AppColors.primaryBlue),
            ),
            title: Text(item['name'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(item['subtitle'] as String, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.accentGold),
                    Text(' ${item['rating']}', style: Theme.of(context).textTheme.bodySmall),
                    const Spacer(),
                    Text(item['price'] as String, style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
