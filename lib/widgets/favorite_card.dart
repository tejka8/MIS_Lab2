import 'package:flutter/material.dart';
import '../models/recepie.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(recipe.imageUrl, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                    IconButton(
                      icon: Icon(
                        recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: onFavoriteToggle,
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
