
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String area;
  @HiveField(4)
  final String instructions;
  @HiveField(5)
  final String thumbnailUrl;
  @HiveField(6)
  final String? youtubeUrl;
  @HiveField(7)
  final List<String> ingredients;
  @HiveField(8)
  final List<String> measures;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    this.youtubeUrl,
    required this.ingredients,
    required this.measures,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString());
        measures.add(measure?.toString() ?? "");
      }
    }

    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? 'Unknown Recipe',
      category: json['strCategory'] ?? 'General',
      area: json['strArea'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? '',
      thumbnailUrl: json['strMealThumb'] ?? '',
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnailUrl,
      'strYoutube': youtubeUrl,
      'ingredients': ingredients,
      'measures': measures,
    };
  }
}

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    return Recipe(
      id: reader.read(),
      name: reader.read(),
      category: reader.read(),
      area: reader.read(),
      instructions: reader.read(),
      thumbnailUrl: reader.read(),
      youtubeUrl: reader.read(),
      ingredients: (reader.read() as List).cast<String>(),
      measures: (reader.read() as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.category);
    writer.write(obj.area);
    writer.write(obj.instructions);
    writer.write(obj.thumbnailUrl);
    writer.write(obj.youtubeUrl);
    writer.write(obj.ingredients);
    writer.write(obj.measures);
  }
}
