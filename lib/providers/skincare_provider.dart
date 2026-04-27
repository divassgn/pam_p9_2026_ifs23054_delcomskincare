import 'package:flutter/material.dart';
import '../data/models/skincare_model.dart';
import '../data/services/skincare_service.dart';

class SkincareProvider extends ChangeNotifier {
  List<SkincareRecommendation> recommendations = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isGenerating = false;

  Future<void> fetchRecommendations(String token) async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await SkincareService.getRecommendations(page, token);
      final List data = result["data"];

      if (data.isEmpty) {
        hasMore = false;
      } else {
        recommendations.addAll(
          data.map((e) => SkincareRecommendation.fromJson(e)).toList(),
        );
        page++;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generate(
      String skinConcern, String skinType, String token) async {
    isGenerating = true;
    notifyListeners();

    try {
      await SkincareService.generateRecommendation(skinConcern, skinType, token);
      recommendations.clear();
      page = 1;
      hasMore = true;
      await fetchRecommendations(token);
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id, String token) async {
    await SkincareService.deleteRecommendation(id, token);
    recommendations.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void clear() {
    recommendations.clear();
    page = 1;
    hasMore = true;
    notifyListeners();
  }
}
