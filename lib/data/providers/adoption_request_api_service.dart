import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/adoption_request_dto.dart';

class AdoptionRequestApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<AdoptionRequestDto?> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/AdoptionRequest/$id'));
    if (response.statusCode == 200) {
      return AdoptionRequestDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}