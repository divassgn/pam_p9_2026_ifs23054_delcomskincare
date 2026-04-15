import '../models/motivation_model.dart';
import '../../core/constants/api_constants.dart';

class MotivationService {
  Future<List<MotivationModel>> fetchMotivations() async {
    // TODO: Replace with real HTTP call to ApiConstants.baseUrl
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const MotivationModel(
        id: 1,
        quote: 'The only way to do great work is to love what you do.',
        author: 'Steve Jobs',
      ),
      const MotivationModel(
        id: 2,
        quote: 'In the middle of every difficulty lies opportunity.',
        author: 'Albert Einstein',
      ),
    ];
  }
}
