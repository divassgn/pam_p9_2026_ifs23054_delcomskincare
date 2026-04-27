import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/auth_model.dart';

class AuthService {
  static Future<AuthModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthModel.fromJson(jsonDecode(response.body));
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'Login gagal');
    }
  }
}
