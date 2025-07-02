import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/help_request_dto.dart';

class HelpRequestApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<HelpRequestDto>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/api/HelpRequest'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => HelpRequestDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch help requests');
  }

  Future<HelpRequestDto?> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/HelpRequest/$id'));
    if (response.statusCode == 200) {
      return HelpRequestDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> create(HelpRequestDto dto, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/HelpRequest'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create help request');
    }
  }

  Future<void> update(int id, HelpRequestDto dto, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/HelpRequest/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update help request');
    }
  }

  Future<void> delete(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/HelpRequest/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete help request');
    }
  }
}