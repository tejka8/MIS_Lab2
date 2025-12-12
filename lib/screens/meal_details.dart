import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/meal_details.dart';
import '../services/api_services.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealDetail? initialMeal;

  const MealDetailScreen({super.key, required this.mealId, this.initialMeal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  late Future<MealDetail> _futureDetail;

  @override
  void initState() {
    super.initState();
    // Ако има почетен објект, користи го; инаку превземи од API
    _futureDetail = widget.initialMeal != null
        ? Future.value(widget.initialMeal!)
        : api.lookupMeal(widget.mealId);
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не можам да отворa YouTube')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепт'),
      ),
      body: FutureBuilder<MealDetail>(
        future: _futureDetail,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Грешка: ${snap.error}'));
          }

          final meal = snap.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  imageUrl: meal.thumb,
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) =>
                  const SizedBox(height: 220, child: Center(child: Icon(Icons.broken_image))),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (meal.category.isNotEmpty) Chip(label: Text(meal.category)),
                          const SizedBox(width: 8),
                          if (meal.area.isNotEmpty) Chip(label: Text(meal.area)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Состојки:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...meal.ingredients.map(
                            (m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            '• ${m['ingredient']} — ${m['measure']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Упатство:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(meal.instructions, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 12),
                      if (meal.youtube.isNotEmpty)
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Отвори YouTube'),
                            onPressed: () => _openYoutube(meal.youtube),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
