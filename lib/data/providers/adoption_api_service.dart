import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/adoption_dto.dart';
import 'package:flutter/foundation.dart';

class AdoptionApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<AdoptionDto?> getByPetId(int petId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Adoption/$petId'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    debugPrint('AdoptionApiService.getByPetId: petId=$petId statusCode=${response.statusCode} body=${response.body}');
    if (response.statusCode == 200) {
      return AdoptionDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> create(AdoptionDto dto, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Adoption'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create adoption');
    }
  }
}