import 'package:flutter/material.dart';
import 'package:lab2_223095/screens/favorite_screen.dart';
import '../models/category.dart';
import '../services/api_services.dart';
import '../widgets/category_card.dart';
import 'category_meals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  late Future<List<Category>> _categoriesFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _filtered = [];

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _api.fetchCategories();
    _categoriesFuture.then((list) {
      setState(() {
        _allCategories = list;
        _filtered = list;
      });
    });
  }

  void _filter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _allCategories
          : _allCategories
          .where((c) =>
      c.name.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesPage(allMeals: []), // стави ја листата со рецепти тука
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filter('');
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _filter,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(child: Text('No categories found'))
                      : GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final cat = _filtered[index];
                      return CategoryCard(
                        category: cat,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>CategoryMealsScreen(categoryName: cat.name)),
                          );
                        },
                      );
                    },
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
