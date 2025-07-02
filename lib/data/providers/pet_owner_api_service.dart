import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/pet_owner_dto.dart';

class PetOwnerApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<PetOwnerDto>> getPetOwners() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/petowners'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PetOwnerDto.fromJson(e)).toList();
    } else {
      throw Exception('Sahipler alınamadı');
    }
  }

  Future<PetOwnerDto> getPetOwner(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/petowners/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return PetOwnerDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Sahip alınamadı');
    }
  }

  Future<void> createPetOwner(PetOwnerDto owner) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/petowners'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(owner.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Sahip oluşturulamadı');
    }
  }

  Future<void> updatePetOwner(int id, PetOwnerDto owner) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/petowners/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(owner.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Sahip güncellenemedi');
    }
  }

  Future<void> deletePetOwner(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/petowners/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Sahip silinemedi');
    }
  }
} 