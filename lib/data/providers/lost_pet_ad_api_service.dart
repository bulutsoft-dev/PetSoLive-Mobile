import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
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
    final url = Uri.parse('$baseUrl/api/LostPetAd');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    debugPrint('[LOST PET AD CREATE] URL: $url');
    debugPrint('[LOST PET AD CREATE] Headers: ' + headers.toString());
    debugPrint('[LOST PET AD CREATE] Body: $body');
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    debugPrint('[LOST PET AD CREATE] Status: ${response.statusCode}');
    debugPrint('[LOST PET AD CREATE] Response: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create lost pet ad: ${response.statusCode} ${response.body}');
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