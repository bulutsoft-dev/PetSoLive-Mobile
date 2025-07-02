import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/adoption_dto.dart';

class AdoptionApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<AdoptionDto>> getAdoptions() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adoptions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => AdoptionDto.fromJson(e)).toList();
    } else {
      throw Exception('Evlat edinmeler alınamadı');
    }
  }

  Future<AdoptionDto> getAdoption(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adoptions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return AdoptionDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Evlat edinme alınamadı');
    }
  }

  Future<void> createAdoption(AdoptionDto adoption) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/adoptions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(adoption.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Evlat edinme oluşturulamadı');
    }
  }

  Future<void> updateAdoption(int id, AdoptionDto adoption) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/adoptions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(adoption.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Evlat edinme güncellenemedi');
    }
  }

  Future<void> deleteAdoption(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/adoptions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Evlat edinme silinemedi');
    }
  }
} 