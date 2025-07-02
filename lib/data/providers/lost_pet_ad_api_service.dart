import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/lost_pet_ad_dto.dart';

class LostPetAdApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<LostPetAdDto>> getAll() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/LostPetAd'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LostPetAdDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch lost pet ads: ${response.body}');
  }

  Future<LostPetAdDto?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/LostPetAd/$id'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      return LostPetAdDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> create(LostPetAdDto dto, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/LostPetAd'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create lost pet ad');
    }
  }

  Future<void> update(int id, LostPetAdDto dto, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/LostPetAd/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update lost pet ad');
    }
  }

  Future<void> delete(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/LostPetAd/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete lost pet ad');
    }
  }
}