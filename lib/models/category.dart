class Category {
  final String id;
  final String name;
  final String description;
  final String thumb;
  bool isFavorite; // <-- додај го ова

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.thumb,
    this.isFavorite = false, // default е false
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'] ?? '',
      name: json['strCategory'] ?? '',
      description: json['strCategoryDescription'] ?? '',
      thumb: json['strCategoryThumb'] ?? '',
      isFavorite: false, // default
    );
  }
}
