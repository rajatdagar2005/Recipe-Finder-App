
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/recipe.dart';
import '../views/detail_page.dart';
import '../core/constants.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isList;

  const RecipeCard({super.key, required this.recipe, this.isList = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(recipe: recipe))),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: isList ? _buildListLayout() : _buildGridLayout(),
      ),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Hero(
            tag: 'recipe-image-${recipe.id}',
            child: CachedNetworkImage(
              imageUrl: recipe.thumbnailUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text('${recipe.area} • ${recipe.category}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListLayout() {
    return Row(
      children: [
        Hero(
          tag: 'recipe-image-${recipe.id}',
          child: CachedNetworkImage(
            imageUrl: recipe.thumbnailUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text('${recipe.area} • ${recipe.category}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
        const SizedBox(width: 8),
      ],
    );
  }
}
