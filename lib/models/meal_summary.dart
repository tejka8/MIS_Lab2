
class MealSummary {
  final String id;
  final String name;
  final String thumb;
  bool isFavorite;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumb,
    this.isFavorite = false,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      isFavorite: false,
    );
  }

  // For search.php mapping (full object)
  factory MealSummary.fromSearchJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      isFavorite: false
    );
  }
}
