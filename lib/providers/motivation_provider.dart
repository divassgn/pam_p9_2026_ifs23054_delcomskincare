import 'package:flutter/material.dart';
import '../data/models/motivation_model.dart';
import '../data/services/motivation_service.dart';

class MotivationProvider extends ChangeNotifier {
  final MotivationService _service = MotivationService();

  List<MotivationModel> _motivations = [];
  bool _isLoading = false;
  String? _error;

  List<MotivationModel> get motivations => _motivations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMotivations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _motivations = await _service.fetchMotivations();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
