import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_details.dart';
import '../models/meal_summary.dart';

class ApiService {
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$_base/categories.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = data['categories'] as List;
      return list.map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories');
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final res = await http.get(Uri.parse('$_base/filter.php?c=$category'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data['meals'] == null) return [];
      final list = data['meals'] as List;
      return list.map((e) => MealSummary.fromJson(e)).toList();
    }
    throw Exception('Failed to load meals for category');
  }

  Future<List<MealSummary>> searchMeals(String query) async {
    final res = await http.get(Uri.parse('$_base/search.php?s=$query'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data['meals'] == null) return [];
      final list = data['meals'] as List;
      return list.map((e) => MealSummary.fromSearchJson(e)).toList();
    }
    throw Exception('Search failed');
  }

  Future<MealDetail> lookupMeal(String id) async {
    final res = await http.get(Uri.parse('$_base/lookup.php?i=$id'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final obj = data['meals'][0] as Map<String, dynamic>;
      return MealDetail.fromJson(obj);
    }
    throw Exception('Failed to load meal detail');
  }

  Future<MealDetail> randomMeal() async {
    final res = await http.get(Uri.parse('$_base/random.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final obj = data['meals'][0] as Map<String, dynamic>;
      return MealDetail.fromJson(obj);
    }
    throw Exception('Failed to load random meal');
  }
}
