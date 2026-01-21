
import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/recipe.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await _dio.get('${ApiEndpoints.searchByName}$query');
      final meals = response.data['meals'] as List?;
      if (meals == null) return [];
      return meals.map((m) => Recipe.fromJson(m)).toList();
    } catch (e) {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<String>> getCategories() async {
    final response = await _dio.get(ApiEndpoints.categories);
    final list = response.data['categories'] as List;
    return list.map((c) => c['strCategory'] as String).toList();
  }

  Future<List<String>> getAreas() async {
    final response = await _dio.get(ApiEndpoints.areas);
    final list = response.data['meals'] as List;
    return list.map((a) => a['strArea'] as String).toList();
  }

  Future<Recipe?> getRecipeDetails(String id) async {
    final response = await _dio.get('${ApiEndpoints.lookup}$id');
    final meals = response.data['meals'] as List?;
    if (meals == null || meals.isEmpty) return null;
    return Recipe.fromJson(meals.first);
  }
}
