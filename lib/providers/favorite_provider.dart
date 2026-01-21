
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';

final favoriteBoxProvider = Provider<Box<Recipe>>((ref) {
  return Hive.box<Recipe>('favorites');
});

class FavoriteNotifier extends StateNotifier<List<Recipe>> {
  final Box<Recipe> _box;

  FavoriteNotifier(this._box) : super(_box.values.toList());

  bool isFavorite(String id) => _box.containsKey(id);

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe.id)) {
      _box.delete(recipe.id);
    } else {
      _box.put(recipe.id, recipe);
    }
    state = _box.values.toList();
  }

  void removeFavorite(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Recipe>>((ref) {
  return FavoriteNotifier(ref.watch(favoriteBoxProvider));
});
