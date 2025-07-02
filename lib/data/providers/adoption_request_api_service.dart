import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/adoption_request_dto.dart';

class AdoptionRequestApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<AdoptionRequestDto>> getAdoptionRequests() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adoptionrequests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => AdoptionRequestDto.fromJson(e)).toList();
    } else {
      throw Exception('Evlat edinme talepleri alınamadı');
    }
  }

  Future<AdoptionRequestDto> getAdoptionRequest(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/adoptionrequests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return AdoptionRequestDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Evlat edinme talebi alınamadı');
    }
  }

  Future<void> createAdoptionRequest(AdoptionRequestDto request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/adoptionrequests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(request.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Evlat edinme talebi oluşturulamadı');
    }
  }

  Future<void> updateAdoptionRequest(int id, AdoptionRequestDto request) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/adoptionrequests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(request.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Evlat edinme talebi güncellenemedi');
    }
  }

  Future<void> deleteAdoptionRequest(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/adoptionrequests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Evlat edinme talebi silinemedi');
    }
  }
} 