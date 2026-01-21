
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_provider.dart';
import '../widgets/recipe_card.dart';
import '../core/constants.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.favorites)),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet. Start exploring!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecipeCard(recipe: favorites[index], isList: true),
              ),
            ),
    );
  }
}
