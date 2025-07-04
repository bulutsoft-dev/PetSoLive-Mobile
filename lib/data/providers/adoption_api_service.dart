import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/adoption_dto.dart';
import 'package:flutter/foundation.dart';

class AdoptionApiService {
  final String baseUrl = ApiConstants.baseUrl;

  // In-memory cache: petId -> AdoptionDto?
  static final Map<int, AdoptionDto?> _cache = {};

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

  Future<AdoptionDto?> fetchAdoptionByPetId(int petId) async {
    if (_cache.containsKey(petId)) {
      debugPrint('AdoptionApiService.fetchAdoptionByPetId: cache hit for petId=$petId');
      return _cache[petId]!;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/Adoption/pet/$petId'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    debugPrint('AdoptionApiService.fetchAdoptionByPetId: petId=$petId statusCode=${response.statusCode} body=${response.body}');
    if (response.statusCode == 200) {
      final adoption = response.body.isNotEmpty ? AdoptionDto.fromJson(jsonDecode(response.body)) : null;
      _cache[petId] = adoption;
      return adoption;
    } else {
      debugPrint('AdoptionApiService.fetchAdoptionByPetId: ERROR statusCode=${response.statusCode} body=${response.body}');
      return null;
    }
  }
}