import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/shimmer_loading.dart';
import 'favorites_page.dart';
import '../core/constants.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recipeProvider);
    final notifier = ref.read(recipeProvider.notifier);
    final filteredRecipes = notifier.filteredRecipes;

    final int activeFilterCount = [
      state.selectedCategory,
      state.selectedArea,
    ].where((e) => e != null).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            ),
          ),
          IconButton(
            icon: Icon(
              state.viewMode == ViewMode.grid
                  ? Icons.list
                  : Icons.grid_view,
            ),
            onPressed: notifier.toggleViewMode,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(notifier),
          _buildFilters(ref, notifier, state, activeFilterCount),
          Expanded(
            child: state.isLoading
                ? const ShimmerLoading()
                : filteredRecipes.isEmpty
                ? const Center(child: Text(AppStrings.noResults))
                : state.viewMode == ViewMode.grid
                ? GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) =>
                  RecipeCard(recipe: filteredRecipes[index]),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecipeCard(
                  recipe: filteredRecipes[index],
                  isList: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SEARCH BAR =================

  Widget _buildSearchBar(RecipeNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: notifier.onSearchChanged,
        decoration: InputDecoration(
          hintText: AppStrings.searchPlaceholder,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ================= FILTER BAR =================

  Widget _buildFilters(
      WidgetRef ref,
      RecipeNotifier notifier,
      RecipeState state,
      int activeFilterCount,
      ) {
    final categories = ref.watch(categoriesProvider);
    final areas = ref.watch(areasProvider);

    return SizedBox(
      height: 72, // ✅ Safe height
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (activeFilterCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                label: SizedBox(
                  width: 120,
                  child: Text(
                    '${AppStrings.clearFilters} ($activeFilterCount)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onPressed: notifier.clearFilters,
                backgroundColor: AppColors.primary.withOpacity(0.1),
              ),
            ),
          _buildDropdownFilter(
            label: state.selectedCategory ?? 'Category',
            items: categories.when(
              data: (d) => d,
              error: (_, __) => [],
              loading: () => [],
            ),
            onSelected: notifier.setCategory,
          ),
          const SizedBox(width: 8),
          _buildDropdownFilter(
            label: state.selectedArea ?? 'Cuisine',
            items: areas.when(
              data: (d) => d,
              error: (_, __) => [],
              loading: () => [],
            ),
            onSelected: notifier.setArea,
          ),
          const SizedBox(width: 8),
          _buildSortFilter(notifier, state),
        ],
      ),
    );
  }

  // ================= CATEGORY / CUISINE =================

  Widget _buildDropdownFilter({
    required String label,
    required List<String> items,
    required Function(String?) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) =>
          items.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        label: SizedBox(
          width: 90, // ✅ CONSTRAIN WIDTH
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SORT =================

  Widget _buildSortFilter(
      RecipeNotifier notifier,
      RecipeState state,
      ) {
    return PopupMenuButton<SortOption>(
      onSelected: notifier.setSortOption,
      itemBuilder: (context) => const [
        PopupMenuItem(value: SortOption.aToZ, child: Text('Name (A-Z)')),
        PopupMenuItem(value: SortOption.zToA, child: Text('Name (Z-A)')),
      ],
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        label: SizedBox(
          width: 60,
          child: Row(
            children: [
              const Icon(Icons.sort, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  state.sortOption == SortOption.aToZ ? 'A-Z' : 'Z-A',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
