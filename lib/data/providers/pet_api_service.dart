import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/pet_dto.dart';

class PetApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final String apiKey = ApiConstants.apiKey;

  Future<List<PetDto>> getAll() async {
    print('API KEY: ${ApiConstants.apiKey}');
    final response = await http.get(
      Uri.parse('$baseUrl/api/Pet'),
      headers: {
        'x-api-key': apiKey,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PetDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch pets: ${response.body}');
  }

  Future<PetDto?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Pet/$id'),
      headers: {
        'x-api-key': apiKey,
      },
    );
    if (response.statusCode == 200) {
      return PetDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> create(PetDto dto, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Pet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create pet');
    }
  }

  Future<void> update(int id, PetDto dto, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Pet/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update pet');
    }
  }

  Future<void> delete(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/Pet/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete pet');
    }
  }
}