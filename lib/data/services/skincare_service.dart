import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class SkincareService {
  static Future<Map<String, dynamic>> getRecommendations(
      int page, String token) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.skincare}?page=$page&per_page=10"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Sesi habis. Silakan login ulang.");
    } else {
      throw Exception("Gagal memuat rekomendasi.");
    }
  }

  static Future<Map<String, dynamic>> generateRecommendation(
      String skinConcern, String skinType, String token) async {
    final response = await http.post(
      Uri.parse(ApiConstants.generate),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "skin_concern": skinConcern,
        "skin_type": skinType,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Sesi habis. Silakan login ulang.");
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal generate rekomendasi.');
    }
  }

  static Future<void> deleteRecommendation(int id, String token) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.skincare}/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 401) {
      throw Exception("Sesi habis. Silakan login ulang.");
    }

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus rekomendasi.");
    }
  }
}
