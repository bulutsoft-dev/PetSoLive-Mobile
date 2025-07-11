import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/help_request_dto.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

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

  Future<void> createMultipart(HelpRequestDto dto, String token, File? imageFile, String? imageUrl) async {
    final url = Uri.parse('$baseUrl/api/HelpRequest');
    var request = http.MultipartRequest('POST', url);
    request.fields['id'] = dto.id.toString();
    request.fields['title'] = dto.title;
    request.fields['description'] = dto.description;
    request.fields['emergencyLevel'] = dto.emergencyLevel.name[0].toUpperCase() + dto.emergencyLevel.name.substring(1).toLowerCase();
    request.fields['createdAt'] = dto.createdAt.toIso8601String();
    request.fields['userId'] = dto.userId.toString();
    request.fields['userName'] = dto.userName;
    request.fields['location'] = dto.location;
    if (dto.contactName != null) request.fields['contactName'] = dto.contactName!;
    if (dto.contactPhone != null) request.fields['contactPhone'] = dto.contactPhone!;
    if (dto.contactEmail != null) request.fields['contactEmail'] = dto.contactEmail!;
    if (imageUrl != null) request.fields['imageUrl'] = imageUrl;
    request.fields['status'] = dto.status.name[0].toUpperCase() + dto.status.name.substring(1).toLowerCase();
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-api-key'] = ApiConstants.apiKey;
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }
    debugPrint('[HELP REQUEST CREATE MULTIPART] URL: $url');
    debugPrint('[HELP REQUEST CREATE MULTIPART] Fields: ' + request.fields.toString());
    debugPrint('[HELP REQUEST CREATE MULTIPART] Headers: ' + request.headers.toString());
    if (imageFile != null) debugPrint('[HELP REQUEST CREATE MULTIPART] File: ${imageFile.path}');
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint('[HELP REQUEST CREATE MULTIPART] Status: ${response.statusCode}');
    debugPrint('[HELP REQUEST CREATE MULTIPART] Response: $respStr');
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('[HELP REQUEST CREATE MULTIPART] ERROR: ${response.statusCode} $respStr');
      throw Exception('Failed to create help request: $respStr');
    }
  }

  Future<void> update(int id, HelpRequestDto dto, String token) async {
    debugPrint('[API] PUT /api/HelpRequest/$id başlatılıyor...');
    final url = Uri.parse('$baseUrl/api/HelpRequest/$id');
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': ApiConstants.apiKey,
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(dto.toJson());
    debugPrint('[API] PUT URL: $url');
    debugPrint('[API] PUT Headers: $headers');
    debugPrint('[API] PUT Body: $body');
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );
    debugPrint('[API] PUT Status: ${response.statusCode}');
    debugPrint('[API] PUT Response: ${response.body}');
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