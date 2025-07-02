import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/veterinarian_dto.dart';

class VeterinarianApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<VeterinarianDto>> getAll() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Veterinarian'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => VeterinarianDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch veterinarians');
  }

  Future<VeterinarianDto?> register(VeterinarianDto dto, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Veterinarian/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return VeterinarianDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to register veterinarian');
  }

  Future<void> approve(int id, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Veterinarian/$id/approve'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to approve veterinarian');
    }
  }

  Future<void> reject(int id, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Veterinarian/$id/reject'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to reject veterinarian');
    }
  }
}