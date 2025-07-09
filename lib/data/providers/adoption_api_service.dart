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
    final url = Uri.parse('$baseUrl/api/Adoption');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    debugPrint('[ADOPTION CREATE] URL: ' + url.toString());
    debugPrint('[ADOPTION CREATE] Headers: ' + headers.toString());
    debugPrint('[ADOPTION CREATE] Body JSON: ' + body);
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    debugPrint('[ADOPTION CREATE] Status: ${response.statusCode}');
    debugPrint('[ADOPTION CREATE] Response Body: ${response.body}');
    debugPrint('[ADOPTION CREATE] Response Headers: ${response.headers}');
    if (response.statusCode != 200) {
      throw Exception('Failed to create adoption: Status: ${response.statusCode} Body: ${response.body}');
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