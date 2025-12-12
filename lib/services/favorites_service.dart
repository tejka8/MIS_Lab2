import '../models/recepie.dart';

class FavoritesService {
  static final List<Recipe> _favorites = [];

  static List<Recipe> get favorites => _favorites;

  static void toggleFavorite(Recipe recipe) {
    final index = _favorites.indexWhere((r) => r.id == recipe.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(recipe.copyWith(isFavorite: true));
    }
  }

  static bool isFavorite(String id) {
    return _favorites.any((r) => r.id == id);
  }
}
