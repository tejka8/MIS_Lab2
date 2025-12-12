import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_card.dart';
import 'meal_details.dart';

class FavoritesPage extends StatelessWidget {
  final List<MealSummary> allMeals;

  const FavoritesPage({super.key, required this.allMeals});

  @override
  Widget build(BuildContext context) {
    final favorites = allMeals.where((m) => m.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('Нема омилени'))
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 200,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final meal = favorites[index];
          return MealCard(
            meal: meal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(mealId: meal.id),
                ),
              );
            },
            onFavoriteToggle: () {
              meal.isFavorite = !meal.isFavorite;
            },
          );
        },
      ),
    );
  }
}
