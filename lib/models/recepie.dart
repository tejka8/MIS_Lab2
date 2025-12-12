class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Recipe copyWith({bool? isFavorite}) {
    return Recipe(
      id: id,
      title: title,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
