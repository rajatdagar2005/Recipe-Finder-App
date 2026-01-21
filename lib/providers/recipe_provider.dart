
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../repositories/recipe_repository.dart';
import '../models/recipe.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final recipeRepositoryProvider = Provider<IRecipeRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RecipeRepository(apiService);
});

enum SortOption { aToZ, zToA }
enum ViewMode { grid, list }

class RecipeState {
  final List<Recipe> recipes;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedArea;
  final SortOption sortOption;
  final ViewMode viewMode;

  RecipeState({
    required this.recipes,
    required this.isLoading,
    this.error,
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedArea,
    this.sortOption = SortOption.aToZ,
    this.viewMode = ViewMode.grid,
  });

  // RecipeState copyWith({
  //   List<Recipe>? recipes,
  //   bool? isLoading,
  //   String? error,
  //   String? searchQuery,
  //   String? selectedCategory,
  //   String? selectedArea,
  //   SortOption? sortOption,
  //   ViewMode? viewMode,
  // }) {
  //   return RecipeState(
  //     recipes: recipes ?? this.recipes,
  //     isLoading: isLoading ?? this.isLoading,
  //     error: error ?? this.error,
  //     searchQuery: searchQuery ?? this.searchQuery,
  //     selectedCategory: selectedCategory ?? this.selectedCategory,
  //     selectedArea: selectedArea ?? this.selectedArea,
  //     sortOption: sortOption ?? this.sortOption,
  //     viewMode: viewMode ?? this.viewMode,
  //   );
  // }
  RecipeState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    String? error,
    String? searchQuery,
    Object? selectedCategory = _sentinel,
    Object? selectedArea = _sentinel,
    SortOption? sortOption,
    ViewMode? viewMode,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory == _sentinel
          ? this.selectedCategory
          : selectedCategory as String?,
      selectedArea: selectedArea == _sentinel
          ? this.selectedArea
          : selectedArea as String?,
      sortOption: sortOption ?? this.sortOption,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  static const _sentinel = Object();

}

class RecipeNotifier extends StateNotifier<RecipeState> {
  final IRecipeRepository _repository;
  Timer? _debounce;

  RecipeNotifier(this._repository) : super(RecipeState(recipes: [], isLoading: true)) {
    loadInitialRecipes();
  }

  Future<void> loadInitialRecipes() async {
    state = state.copyWith(isLoading: true);
    try {
      final recipes = await _repository.searchRecipes('');
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      state = state.copyWith(isLoading: true, searchQuery: query);
      try {
        final recipes = await _repository.searchRecipes(query);
        state = state.copyWith(recipes: recipes, isLoading: false);
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    });
  }

  void toggleViewMode() {
    state = state.copyWith(viewMode: state.viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid);
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setArea(String? area) {
    state = state.copyWith(selectedArea: area);
  }

  // void clearFilters() {
  //   state = state.copyWith(selectedCategory: null, selectedArea: null, searchQuery: '');
  //   loadInitialRecipes();
  // }
  void clearFilters() async {
    state = state.copyWith(
      selectedCategory: null,
      selectedArea: null,
      searchQuery: '',
      sortOption: SortOption.aToZ,
    );

    await loadInitialRecipes();
  }


  List<Recipe> get filteredRecipes {
    var list = [...state.recipes];

    if (state.selectedCategory != null) {
      list = list.where((r) => r.category == state.selectedCategory).toList();
    }
    if (state.selectedArea != null) {
      list = list.where((r) => r.area == state.selectedArea).toList();
    }

    if (state.sortOption == SortOption.aToZ) {
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else {
      list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    }

    return list;
  }

  int get activeFilterCount {
    int count = 0;
    if (state.selectedCategory != null) count++;
    if (state.selectedArea != null) count++;
    return count;
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, RecipeState>((ref) {
  return RecipeNotifier(ref.watch(recipeRepositoryProvider));
});

final categoriesProvider = FutureProvider((ref) => ref.watch(recipeRepositoryProvider).getCategories());
final areasProvider = FutureProvider((ref) => ref.watch(recipeRepositoryProvider).getAreas());
