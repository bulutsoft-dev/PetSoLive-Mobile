import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/help_request_dto.dart';
import 'package:flutter/foundation.dart';

class HelpRequestApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<HelpRequestDto>> getAll() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/HelpRequest'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => HelpRequestDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch help requests');
  }

  Future<HelpRequestDto?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/HelpRequest/$id'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      return HelpRequestDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> create(HelpRequestDto dto, String token) async {
    final url = Uri.parse('$baseUrl/api/HelpRequest');
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': ApiConstants.apiKey,
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(dto.toJson());
    // Debug printler
    // ignore: avoid_print
    print('[HELP REQUEST CREATE] URL: $url');
    // ignore: avoid_print
    print('[HELP REQUEST CREATE] Headers: ' + headers.toString());
    // ignore: avoid_print
    print('[HELP REQUEST CREATE] Body: $body');
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    // ignore: avoid_print
    print('[HELP REQUEST CREATE] Status:  [33m${response.statusCode} [0m');
    // ignore: avoid_print
    print('[HELP REQUEST CREATE] Response: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      // ignore: avoid_print
      print('[HELP REQUEST CREATE] ERROR: ${response.statusCode} ${response.body}');
      throw Exception('Failed to create help request: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> update(int id, HelpRequestDto dto, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/HelpRequest/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': ApiConstants.apiKey,
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update help request');
    }
  }

  Future<void> delete(int id, String token) async {
    debugPrint('[API] DELETE /api/HelpRequest/$id başlatılıyor...');
    final response = await http.delete(
      Uri.parse('$baseUrl/api/HelpRequest/$id'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint('[API] DELETE URL: $baseUrl/api/HelpRequest/$id');
    debugPrint('[API] DELETE Headers: x-api-key: ${ApiConstants.apiKey}, Authorization: Bearer $token');
    debugPrint('[API] DELETE Status: ${response.statusCode}');
    debugPrint('[API] DELETE Response: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete help request');
    }
  }
}