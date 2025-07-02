import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/veterinarian_dto.dart';

class VeterinarianApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<VeterinarianDto>> getVeterinarians() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/veterinarians'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => VeterinarianDto.fromJson(e)).toList();
    } else {
      throw Exception('Veterinerler alınamadı');
    }
  }

  Future<VeterinarianDto> getVeterinarian(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/veterinarians/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return VeterinarianDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Veteriner alınamadı');
    }
  }

  Future<void> createVeterinarian(VeterinarianDto vet) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/veterinarians'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(vet.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Veteriner oluşturulamadı');
    }
  }

  Future<void> updateVeterinarian(int id, VeterinarianDto vet) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/veterinarians/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(vet.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Veteriner güncellenemedi');
    }
  }

  Future<void> deleteVeterinarian(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/veterinarians/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Veteriner silinemedi');
    }
  }
} 