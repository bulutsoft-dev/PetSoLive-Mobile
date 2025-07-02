import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/pet_dto.dart';

class PetApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<PetDto>> getPets() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pets'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PetDto.fromJson(e)).toList();
    } else {
      throw Exception('Evcil hayvanlar alınamadı');
    }
  }

  Future<PetDto> getPet(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pets/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return PetDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Evcil hayvan alınamadı');
    }
  }

  Future<void> createPet(PetDto pet) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/pets'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(pet.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Evcil hayvan oluşturulamadı');
    }
  }

  Future<void> updatePet(int id, PetDto pet) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/pets/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(pet.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Evcil hayvan güncellenemedi');
    }
  }

  Future<void> deletePet(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/pets/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Evcil hayvan silinemedi');
    }
  }
} 