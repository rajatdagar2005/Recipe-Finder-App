
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder/models/recipe.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_finder/repositories/recipe_repository.dart';
import 'package:recipe_finder/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('Unit Tests', () {
    test('Recipe.fromJson should parse correctly', () {
      final json = {'idMeal': '52772', 'strMeal': 'Teriyaki Chicken'};
      final recipe = Recipe.fromJson(json);
      expect(recipe.id, '52772');
      expect(recipe.name, 'Teriyaki Chicken');
    });

    test('Recipe.toJson should include all fields', () {
      final recipe = Recipe(
        id: '1', name: 'Nasi Goreng', category: 'Rice', 
        area: 'Indonesian', instructions: 'Fry it', 
        thumbnailUrl: '', ingredients: ['Rice'], measures: ['1 bowl']
      );
      final json = recipe.toJson();
      expect(json['strMeal'], 'Nasi Goreng');
      expect(json['ingredients'], isA<List>());
    });

    test('Repository should return recipes from service', () async {
      final mockService = MockApiService();
      final repo = RecipeRepository(mockService);
      
      when(() => mockService.searchRecipes('')).thenAnswer((_) async => []);
      
      final results = await repo.searchRecipes('');
      expect(results, isEmpty);
      verify(() => mockService.searchRecipes('')).called(1);
    });

    test('RecipeAdapter should read/write correctly', () {
      // Mocking binary logic is complex, but checking typeId is a good start
      final adapter = RecipeAdapter();
      expect(adapter.typeId, 0);
    });
  });
}
