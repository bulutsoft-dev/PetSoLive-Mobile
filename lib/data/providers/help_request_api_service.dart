import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/help_request_dto.dart';

class HelpRequestApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<HelpRequestDto>> getHelpRequests() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/helprequests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => HelpRequestDto.fromJson(e)).toList();
    } else {
      throw Exception('Yardım talepleri alınamadı');
    }
  }

  Future<HelpRequestDto> getHelpRequest(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/helprequests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return HelpRequestDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Yardım talebi alınamadı');
    }
  }

  Future<void> createHelpRequest(HelpRequestDto helpRequest) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/helprequests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(helpRequest.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Yardım talebi oluşturulamadı');
    }
  }

  Future<void> updateHelpRequest(int id, HelpRequestDto helpRequest) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/helprequests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(helpRequest.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Yardım talebi güncellenemedi');
    }
  }

  Future<void> deleteHelpRequest(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/helprequests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Yardım talebi silinemedi');
    }
  }
} 