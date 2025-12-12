import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle; // callback за toggle на омилен

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Слика
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: category.thumb,
                  fit: BoxFit.cover,
                  placeholder: (c, s) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            // Текст и икона
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            category.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: onFavoriteToggle,
                          iconSize: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),

                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        category.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
