
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder/widgets/recipe_card.dart';
import 'package:recipe_finder/models/recipe.dart';

void main() {
  final testRecipe = Recipe(
    id: '1', name: 'Test Recipe', category: 'Test', 
    area: 'TestLand', instructions: 'Cook it', 
    thumbnailUrl: 'https://example.com/image.jpg', 
    ingredients: [], measures: []
  );

  testWidgets('RecipeCard displays name and area', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: RecipeCard(recipe: testRecipe)),
    ));

    expect(find.text('Test Recipe'), findsOneWidget);
    expect(find.textContaining('TestLand'), findsOneWidget);
  });

  testWidgets('Search Bar UI check', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: TextField(
          decoration: InputDecoration(hintText: 'Search recipes...'),
        ),
      ),
    ));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search recipes...'), findsOneWidget);
  });
}
