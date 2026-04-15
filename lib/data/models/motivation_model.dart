class MotivationModel {
  final int id;
  final String quote;
  final String author;

  const MotivationModel({
    required this.id,
    required this.quote,
    required this.author,
  });

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
      id: json['id'] as int,
      quote: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quote': quote,
        'author': author,
      };
}
