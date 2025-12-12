class Category {
  final String id;
  final String name;
  final String description;
  final String thumb;
  bool isFavorite;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.thumb,
    this.isFavorite = false,
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
