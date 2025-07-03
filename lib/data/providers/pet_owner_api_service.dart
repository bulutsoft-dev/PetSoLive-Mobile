import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/pet_owner_dto.dart';

class PetOwnerApiService {
  final String baseUrl = ApiConstants.baseUrl;

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
    return await getByPetId(petId);
  }
}