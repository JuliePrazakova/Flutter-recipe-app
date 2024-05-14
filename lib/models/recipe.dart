class Recipe {
  final String id;
  final String name;
  final String categoryId;
  final String image;
  final List<String> ingredients;
  final List<String> steps;
  final String userId;

  Recipe({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.userId,
  });

  factory Recipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      name: data['name'],
      categoryId: data['categoryId'],
      image: data['image'],
      ingredients: List<String>.from(data['ingredients']),
      steps: List<String>.from(data['steps']),
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'categoryId': categoryId,
      'image': image,
      'ingredients': ingredients,
      'steps': steps,
      'userId': userId,
    };
  }
}
