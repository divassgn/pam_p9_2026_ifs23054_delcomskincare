class SkincareRecommendation {
  final int id;
  final int userId;
  final String skinConcern;
  final String skinType;
  final String productName;
  final String productType;
  final String keyIngredients;
  final String howToUse;
  final String advice;
  final String createdAt;

  SkincareRecommendation({
    required this.id,
    required this.userId,
    required this.skinConcern,
    required this.skinType,
    required this.productName,
    required this.productType,
    required this.keyIngredients,
    required this.howToUse,
    required this.advice,
    required this.createdAt,
  });

  factory SkincareRecommendation.fromJson(Map<String, dynamic> json) {
    return SkincareRecommendation(
      id:             json['id'],
      userId:         json['user_id'],
      skinConcern:    json['skin_concern'],
      skinType:       json['skin_type'] ?? 'normal',
      productName:    json['product_name'],
      productType:    json['product_type'],
      keyIngredients: json['key_ingredients'],
      howToUse:       json['how_to_use'],
      advice:         json['advice'],
      createdAt:      json['created_at'],
    );
  }
}
