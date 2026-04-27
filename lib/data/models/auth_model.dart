class AuthModel {
  final String token;
  final Map<String, dynamic> user;

  AuthModel({required this.token, required this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      user:  Map<String, dynamic>.from(json['user'] ?? {}),
    );
  }
}
