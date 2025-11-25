import 'package:flutter/material.dart';

import '../models/meal_summary.dart';
import '../services/api_services.dart';
import '../widgets/meal_card.dart';
import 'meal_details.dart';


class CategoryMealsScreen extends StatefulWidget {
  final String categoryName;
  const CategoryMealsScreen({super.key, required this.categoryName});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  final ApiService api = ApiService();
  late Future<List<MealSummary>> _futureMeals;
  List<MealSummary> _all = [];
  List<MealSummary> _displayed = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchingRemote = false;

  @override
  void initState() {
    super.initState();
    _futureMeals = api.fetchMealsByCategory(widget.categoryName);
    _futureMeals.then((list) {
      setState(() {
        _all = list;
        _displayed = list;
      });
    }).catchError((e) {});
  }

  void _filterLocal(String q) {
    final qLower = q.toLowerCase();
    setState(() {
      _displayed = _all.where((m) => m.name.toLowerCase().contains(qLower)).toList();
    });
  }

  Future<void> _searchRemote(String q) async {
    if (q.trim().isEmpty) {
      setState(() {
        _displayed = List.from(_all);
      });
      return;
    }
    setState(() => _isSearchingRemote = true);
    try {
      final results = await api.searchMeals(q);
      // best-effort: show search results (search endpoint is global)
      setState(() {
        _displayed = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search error: $e')));
    } finally {
      setState(() => _isSearchingRemote = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildGrid() {
    if (_displayed.isEmpty) {
      return const Center(child: Text('Нема резултати'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 200,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _displayed.length,
      itemBuilder: (context, index) {
        final meal = _displayed[index];
        return MealCard(
          meal: meal,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => MealDetailScreen(mealId: meal.id),
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
        title: Text(widget.categoryName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => _filterLocal(v),
              onSubmitted: (v) => _searchRemote(v),
              decoration: InputDecoration(
                hintText: 'Пребарување јадења (ENTER за глобално пребарување)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.sync),
                  tooltip: 'Глобално пребарување',
                  onPressed: () => _searchRemote(_searchController.text),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<MealSummary>>(
        future: _futureMeals,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting && _all.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError && _all.isEmpty) {
            return Center(child: Text('Грешка: ${snap.error}'));
          } else {
            return Stack(
              children: [
                _buildGrid(),
                if (_isSearchingRemote)
                  const Positioned(
                    bottom: 16,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Remote search...'),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
