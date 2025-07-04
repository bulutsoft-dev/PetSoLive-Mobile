import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/adoption_request_dto.dart';
import 'package:flutter/foundation.dart';

class AdoptionRequestApiService {
  final String baseUrl = ApiConstants.baseUrl;

  // In-memory cache: petId -> List<AdoptionRequestDto>
  static final Map<int, List<AdoptionRequestDto>> _cache = {};

  Future<AdoptionRequestDto?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/AdoptionRequest/$id'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    debugPrint('AdoptionRequestApiService.getById: id=$id statusCode=${response.statusCode}');
    debugPrint('AdoptionRequestApiService.getById: body=${response.body}');
    if (response.statusCode == 200) {
      return AdoptionRequestDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<AdoptionRequestDto>> getAllByPetId(int petId) async {
    // Önce cache'e bak
    if (_cache.containsKey(petId)) {
      debugPrint('AdoptionRequestApiService.getAllByPetId: cache hit for petId=$petId');
      return _cache[petId]!;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/AdoptionRequest/pet/$petId'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    debugPrint('AdoptionRequestApiService.getAllByPetId: petId=$petId statusCode=${response.statusCode} body=${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final requests = data.map((e) => AdoptionRequestDto.fromJson(e)).toList();
      for (final req in requests) {
        debugPrint('AdoptionRequest: id=${req.id}, petId=${req.petId}, userId=${req.userId}, userName=${req.userName}, status=${req.status}, date=${req.requestDate}, message=${req.message}');
      }
      _cache[petId] = requests; // Cache'e yaz
      return requests;
    } else {
      debugPrint('AdoptionRequestApiService.getAllByPetId: ERROR statusCode=${response.statusCode} body=${response.body}');
      return [];
    }
  }
}