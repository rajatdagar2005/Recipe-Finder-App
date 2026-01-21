
import '../models/recipe.dart';
import '../services/api_service.dart';

abstract class IRecipeRepository {
  Future<List<Recipe>> searchRecipes(String query);
  Future<List<String>> getCategories();
  Future<List<String>> getAreas();
  Future<Recipe?> getRecipeDetails(String id);
}

class RecipeRepository implements IRecipeRepository {
  final ApiService _apiService;

  RecipeRepository(this._apiService);

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    return await _apiService.searchRecipes(query);
  }

  @override
  Future<List<String>> getCategories() async {
    return await _apiService.getCategories();
  }

  @override
  Future<List<String>> getAreas() async {
    return await _apiService.getAreas();
  }

  @override
  Future<Recipe?> getRecipeDetails(String id) async {
    return await _apiService.getRecipeDetails(id);
  }
}
