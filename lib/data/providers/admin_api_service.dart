import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class AdminApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<bool> isUserAdmin(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Admin/is-admin/$userId'));
    if (response.statusCode == 200) {
      return response.body == 'true';
    } else {
      throw Exception('Failed to check admin status');
    }
  }
}