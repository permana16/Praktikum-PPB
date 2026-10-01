import 'package:flutter/material.dart';

import 'models/coffe_item.dart';
import 'widgets/category_filter.dart';
import 'widgets/coffe_card.dart';

class KopiKitaScreen extends StatefulWidget {
  const KopiKitaScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  @override
  State<KopiKitaScreen> createState() =>
      _KopiKitaScreenState();
}

class _KopiKitaScreenState
    extends State<KopiKitaScreen> {
  String _selectedCategory = 'Semua';

  List<CoffeeItem> get _filteredItems {
    if (_selectedCategory == 'Semua') {
      return CoffeeItem.sampleData;
    }

    return CoffeeItem.sampleData.where((item) {
      return item.category == _selectedCategory;
    }).toList();
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KopiKita ☕',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            tooltip: widget.themeMode == ThemeMode.dark
                ? 'Aktifkan Light Mode'
                : 'Aktifkan Dark Mode',
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ATURAN 4:
          // Smartphone < 600dp
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout();
          }

          // Tablet / Landscape >= 600dp
          return _buildTabletLayout();
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader(),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: CategoryFilter(
            selectedCategory: _selectedCategory,
            onCategorySelected: _changeCategory,
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              20,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: CoffeeCard(
                  item: item,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildHeader(),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: CategoryFilter(
            selectedCategory: _selectedCategory,
            onCategorySelected: _changeCategory,
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20,
            ),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              // WAJIB 2 KOLOM
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              // Menjaga proporsi card.
              childAspectRatio: 1.55,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return CoffeeCard(
                item: _filteredItems[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        12,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.coffee_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang di KopiKita',
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Nikmati kopi, minuman segar, '
                  'dan bakery favoritmu.',
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}