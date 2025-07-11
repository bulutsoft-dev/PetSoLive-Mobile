import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/pet_dto.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class PetApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final String apiKey = ApiConstants.apiKey;

  Future<List<PetDto>> getAll() async {
    // print('API KEY: ${ApiConstants.apiKey}');
    final response = await http.get(
      Uri.parse('$baseUrl/api/Pet'),
      headers: {
        'x-api-key': apiKey,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PetDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch pets: ${response.body}');
  }

  Future<PetDto?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Pet/$id'),
      headers: {
        'x-api-key': apiKey,
      },
    );
    if (response.statusCode == 200) {
      return PetDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> create(PetDto dto, String token) async {
    final url = '$baseUrl/api/Pet';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': apiKey,
    };
    final body = jsonEncode(dto.toJson());
    debugPrint('[PET CREATE] URL: $url');
    debugPrint('[PET CREATE] Headers: ' + headers.toString());
    debugPrint('[PET CREATE] Body: $body');
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    debugPrint('[PET CREATE] Status: ${response.statusCode}');
    debugPrint('[PET CREATE] Response: ${response.body}');
    if (response.statusCode != 201) {
      throw Exception('Failed to create pet: \nStatus: ${response.statusCode}\nBody: ${response.body}');
    }
  }

  Future<void> createMultipart({
    required String name,
    required String species,
    required String breed,
    required int age,
    required String gender,
    required String color,
    required String description,
    required String microchipId,
    required String vaccinationStatus,
    required File imageFile,
    required String token,
    // diğer alanlar...
  }) async {
    final url = '$baseUrl/api/Pet';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = name;
    request.fields['species'] = species;
    request.fields['breed'] = breed;
    request.fields['age'] = age.toString();
    request.fields['gender'] = gender;
    request.fields['color'] = color;
    request.fields['description'] = description;
    request.fields['microchipId'] = microchipId;
    request.fields['vaccinationStatus'] = vaccinationStatus;
    // ... diğer alanlar ...
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-api-key'] = apiKey;
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint('[PET CREATE MULTIPART] Status: ${response.statusCode}');
    debugPrint('[PET CREATE MULTIPART] Response: $respStr');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create pet: $respStr');
    }
  }

  Future<int> updateWithResponse(int id, PetDto dto, String token) async {
    final url = '$baseUrl/api/Pet/$id';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': apiKey,
    };
    final body = jsonEncode(dto.toJson());
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    return response.statusCode;
  }

  Future<void> update(int id, PetDto dto, String token) async {
    final url = '$baseUrl/api/Pet/$id';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': apiKey,
    };
    final body = jsonEncode(dto.toJson());
    debugPrint('[PET UPDATE] URL: $url');
    debugPrint('[PET UPDATE] Headers: ' + headers.toString());
    debugPrint('[PET UPDATE] Body: $body');
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    debugPrint('[PET UPDATE] Status: ${response.statusCode}');
    debugPrint('[PET UPDATE] Response Body: ${response.body}');
    debugPrint('[PET UPDATE] Response Headers: ${response.headers}');
    if (response.statusCode != 200) {
      throw Exception('Failed to update pet: \nStatus: ${response.statusCode}\nBody: ${response.body}');
    }
  }

  Future<void> delete(int id, String token) async {
    final url = '$baseUrl/api/Pet/$id';
    final headers = {
      'Authorization': 'Bearer $token',
      'x-api-key': apiKey,
    };
    debugPrint('[PET DELETE] URL: $url');
    debugPrint('[PET DELETE] Headers: ' + headers.toString());
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );
    debugPrint('[PET DELETE] Status: ${response.statusCode}');
    debugPrint('[PET DELETE] Response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete pet: \nStatus: ${response.statusCode}\nBody: ${response.body}');
    }
  }

  Future<PetDto> fetchPet(int id) async {
    final pet = await getById(id);
    if (pet == null) throw Exception('Pet not found');
    return pet;
  }
}