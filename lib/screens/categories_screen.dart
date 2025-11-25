import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_services.dart';
import '../widgets/category_card.dart';
import 'category_meals.dart';
import 'meal_details.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService api = ApiService();
  late Future<List<Category>> _futureCategories;
  List<Category> _all = [];
  List<Category> _filtered = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCategories = api.fetchCategories();
    _futureCategories.then((list) {
      setState(() {
        _all = list;
        _filtered = list;
      });
    }).catchError((e) {});
  }

  void _onSearchChanged(String q) {
    final qLower = q.toLowerCase();
    setState(() {
      _filtered = _all.where((c) => c.name.toLowerCase().contains(qLower)).toList();
    });
  }

  Future<void> _openRandom() async {
    try {
      final meal = await api.randomMeal();
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: meal.id, initialMeal: meal),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не успеа да вчита рандом рецепт: $e')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildGrid() {
    if (_filtered.isEmpty) {
      return const Center(child: Text('Нема категории'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 220,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final cat = _filtered[index];
        return CategoryCard(
          category: cat,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CategoryMealsScreen(categoryName: cat.name),
            ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Random recipe',
            onPressed: _openRandom,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Пребарување категории...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Грешка: ${snap.error}'));
          } else {
            return _buildGrid();
          }
        },
      ),
    );
  }
}
