
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/recipe.dart';
import '../providers/favorite_provider.dart';
import '../core/constants.dart';

class DetailPage extends ConsumerStatefulWidget {
  final Recipe recipe;
  const DetailPage({super.key, required this.recipe});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.recipe.youtubeUrl != null && widget.recipe.youtubeUrl!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.recipe.youtubeUrl!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false, hideControls: false),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isFavorite = ref.watch(favoriteProvider.notifier).isFavorite(widget.recipe.id);
    final favorites = ref.watch(favoriteProvider);
    final isFavorite = favorites.any((r) => r.id == widget.recipe.id);

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController ?? YoutubePlayerController(initialVideoId: ''),
      ),
      builder: (context, player) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                actions: [
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFavorite),
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                    onPressed: () => ref.read(favoriteProvider.notifier).toggleFavorite(widget.recipe),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: GestureDetector(
                    onTap: () => _showFullscreenImage(context),
                    child: Hero(
                      tag: 'recipe-image-${widget.recipe.id}',
                      child: CachedNetworkImage(
                        imageUrl: widget.recipe.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.recipe.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildChip(widget.recipe.category, AppColors.primary),
                          const SizedBox(width: 8),
                          _buildChip(widget.recipe.area, Colors.blueGrey),
                        ],
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: AppStrings.overview),
                    Tab(text: AppStrings.ingredients),
                    Tab(text: AppStrings.instructions),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverview(player),
                      _buildIngredients(),
                      _buildInstructions(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  void _showFullscreenImage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
      body: PhotoView(imageProvider: CachedNetworkImageProvider(widget.recipe.thumbnailUrl)),
    )));
  }

  Widget _buildOverview(Widget youtubePlayer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_youtubeController != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: youtubePlayer,
              ),
            ),
          Text("Description", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            "Explore the culinary wonders of ${widget.recipe.area}. This ${widget.recipe.category} dish is expertly crafted. Follow the detailed tabs for ingredients and step-by-step instructions.",
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.recipe.ingredients.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return Row(
          children: [
            const Icon(Icons.check_circle_outline, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.recipe.ingredients[index], style: const TextStyle(fontSize: 16))),
            Text(widget.recipe.measures[index], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ],
        );
      },
    );
  }

  Widget _buildInstructions() {
    final steps = widget.recipe.instructions.split('\r\n').where((s) => s.trim().isNotEmpty).toList();
    if (steps.isEmpty) return const Center(child: Text("No instructions provided."));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 14, backgroundColor: AppColors.primary, child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Expanded(child: Text(steps[index], style: const TextStyle(fontSize: 15, height: 1.6))),
            ],
          ),
        );
      },
    );
  }
}
