import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/pet_owner_dto.dart';
import 'package:flutter/foundation.dart';

class PetOwnerApiService {
  final String baseUrl = ApiConstants.baseUrl;

  // In-memory cache: petId -> PetOwnerDto?
  static final Map<int, PetOwnerDto?> _cache = {};

  Future<PetOwnerDto?> getByPetId(int petId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/PetOwner/$petId'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      return PetOwnerDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<PetOwnerDto?> fetchPetOwner(int petId) async {
    if (_cache.containsKey(petId)) {
      debugPrint('PetOwnerApiService.fetchPetOwner: cache hit for petId=$petId');
      return _cache[petId]!;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/PetOwner/pet/$petId'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    debugPrint('PetOwnerApiService.fetchPetOwner: petId=$petId statusCode=${response.statusCode} body=${response.body}');
    if (response.statusCode == 200) {
      final owner = response.body.isNotEmpty ? PetOwnerDto.fromJson(jsonDecode(response.body)) : null;
      _cache[petId] = owner;
      return owner;
    } else {
      debugPrint('PetOwnerApiService.fetchPetOwner: ERROR statusCode=${response.statusCode} body=${response.body}');
      return null;
    }
  }
}