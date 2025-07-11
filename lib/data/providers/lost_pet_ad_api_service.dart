import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../core/constants/api_constants.dart';
import '../models/lost_pet_ad_dto.dart';

class LostPetAdApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<LostPetAdDto>> getAll() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/LostPetAd'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LostPetAdDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch lost pet ads: ${response.body}');
  }

  Future<LostPetAdDto?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/LostPetAd/$id'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      return LostPetAdDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> create(LostPetAdDto dto, String token) async {
    final url = Uri.parse('$baseUrl/api/LostPetAd');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    debugPrint('[LOST PET AD CREATE] URL: $url');
    debugPrint('[LOST PET AD CREATE] Headers: ' + headers.toString());
    debugPrint('[LOST PET AD CREATE] Body: $body');
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    debugPrint('[LOST PET AD CREATE] Status: ${response.statusCode}');
    debugPrint('[LOST PET AD CREATE] Response: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create lost pet a d: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> createMultipart(LostPetAdDto dto, String token, File imageFile, String imageUrl) async {
    final url = Uri.parse('$baseUrl/api/LostPetAd');
    var request = http.MultipartRequest('POST', url);
    request.fields['petName'] = dto.petName;
    request.fields['description'] = dto.description;
    request.fields['lastSeenDate'] = dto.lastSeenDate.toIso8601String();
    request.fields['userId'] = dto.userId.toString();
    request.fields['lastSeenCity'] = dto.lastSeenCity;
    request.fields['lastSeenDistrict'] = dto.lastSeenDistrict;
    request.fields['createdAt'] = dto.createdAt.toIso8601String();
    request.fields['userName'] = dto.userName;
    request.fields['ImageUrl'] = imageUrl;
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-api-key'] = ApiConstants.apiKey;
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    debugPrint('[LOST PET AD CREATE MULTIPART] URL: $url');
    debugPrint('[LOST PET AD CREATE MULTIPART] Fields: ' + request.fields.toString());
    debugPrint('[LOST PET AD CREATE MULTIPART] Headers: ' + request.headers.toString());
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint('[LOST PET AD CREATE MULTIPART] Status: ${response.statusCode}');
    debugPrint('[LOST PET AD CREATE MULTIPART] Response: $respStr');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create lost pet ad: $respStr');
    }
  }

  Future<void> update(int id, LostPetAdDto dto, String token) async {
    final url = Uri.parse('$baseUrl/api/LostPetAd/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    debugPrint('[LOST PET AD UPDATE] URL: $url');
    debugPrint('[LOST PET AD UPDATE] Headers: ' + headers.toString());
    debugPrint('[LOST PET AD UPDATE] Body: $body');
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );
    debugPrint('[LOST PET AD UPDATE] Status: ${response.statusCode}');
    debugPrint('[LOST PET AD UPDATE] Response: ${response.body}');
    if (response.statusCode != 204) {
      throw Exception('Failed to update lost pet ad');
    }
  }

  Future<void> updateMultipart(LostPetAdDto dto, String token, File imageFile, String imageUrl) async {
    final url = Uri.parse('$baseUrl/api/LostPetAd/${dto.id}');
    var request = http.MultipartRequest('PUT', url);
    request.fields['petName'] = dto.petName;
    request.fields['description'] = dto.description;
    request.fields['lastSeenDate'] = dto.lastSeenDate.toIso8601String();
    request.fields['userId'] = dto.userId.toString();
    request.fields['lastSeenCity'] = dto.lastSeenCity;
    request.fields['lastSeenDistrict'] = dto.lastSeenDistrict;
    request.fields['createdAt'] = dto.createdAt.toIso8601String();
    request.fields['userName'] = dto.userName;
    request.fields['ImageUrl'] = imageUrl;
    request.headers['Authorization'] = 'Bearer ' + token;
    request.headers['x-api-key'] = ApiConstants.apiKey;
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    debugPrint('[LOST PET AD UPDATE MULTIPART] URL: $url');
    debugPrint('[LOST PET AD UPDATE MULTIPART] Fields: ' + request.fields.toString());
    debugPrint('[LOST PET AD UPDATE MULTIPART] Headers: ' + request.headers.toString());
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint('[LOST PET AD UPDATE MULTIPART] Status: ${response.statusCode}');
    debugPrint('[LOST PET AD UPDATE MULTIPART] Response: $respStr');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update lost pet ad: $respStr');
    }
  }

  Future<void> delete(int id, String token) async {
    final url = Uri.parse('$baseUrl/api/LostPetAd/$id');
    final headers = {
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    debugPrint('[LOST PET AD DELETE] URL: $url');
    debugPrint('[LOST PET AD DELETE] Headers: ' + headers.toString());
    final response = await http.delete(
      url,
      headers: headers,
    );
    debugPrint('[LOST PET AD DELETE] Status: ${response.statusCode}');
    debugPrint('[LOST PET AD DELETE] Response: ${response.body}');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete lost pet ad');
    }
  }
}