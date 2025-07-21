import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/pet_dto.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/pet_list_item.dart';

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

  Future<void> createPetMultipart({
    required String name,
    required String species,
    required String breed,
    required int age,
    required String gender,
    required double weight,
    required String color,
    required DateTime dateOfBirth,
    required String description,
    required String microchipId,
    required String vaccinationStatus,
    required bool? isNeutered,
    required File imageFile,
    required String token,
  }) async {
    final url = '$baseUrl/api/Pet';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'name': name,
      'species': species,
      'breed': breed,
      'age': age.toString(),
      'gender': gender,
      'weight': weight.toString(),
      'color': color,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'description': description,
      'microchipId': microchipId,
      'vaccinationStatus': vaccinationStatus,
      if (isNeutered != null) 'isNeutered': isNeutered.toString(),
    });
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-api-key'] = apiKey;
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint('[PET CREATE MULTIPART] Status:  [32m${response.statusCode} [0m');
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

  Future<void> updatePetMultipart({
    required int id,
    required String name,
    required String species,
    required String breed,
    required int age,
    required String gender,
    required double weight,
    required String color,
    required DateTime dateOfBirth,
    required String description,
    required String microchipId,
    required String vaccinationStatus,
    required bool? isNeutered,
    required File imageFile,
    required String token,
  }) async {
    final url = '$baseUrl/api/Pet/$id';
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.fields.addAll({
      'name': name,
      'species': species,
      'breed': breed,
      'age': age.toString(),
      'gender': gender,
      'weight': weight.toString(),
      'color': color,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'description': description,
      'microchipId': microchipId,
      'vaccinationStatus': vaccinationStatus,
      if (isNeutered != null) 'isNeutered': isNeutered.toString(),
    });
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-api-key'] = apiKey;
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint('[PET UPDATE MULTIPART] Status: ${response.statusCode}');
    debugPrint('[PET UPDATE MULTIPART] Response: $respStr');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update pet: $respStr');
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

  Future<Map<String, dynamic>> fetchPets({
    int page = 1,
    int pageSize = 20,
    String? species,
    String? color,
    String? breed,
    String? adoptedStatus,
    String? search,
    int? ownerId,
  }) async {
    final queryParameters = {
      'page': '$page',
      'pageSize': '$pageSize',
      if (species != null && species.isNotEmpty) 'species': species,
      if (color != null && color.isNotEmpty) 'color': color,
      if (breed != null && breed.isNotEmpty) 'breed': breed,
      if (adoptedStatus != null && adoptedStatus.isNotEmpty) 'adoptedStatus': adoptedStatus,
      if (search != null && search.isNotEmpty) 'search': search,
      if (ownerId != null) 'ownerId': ownerId.toString(),
    };

    final uri = Uri.parse('$baseUrl/api/Pet/advanced-list?${Uri(queryParameters: queryParameters).query}');
    final response = await http.get(uri, headers: {'x-api-key': apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List petsJson = data['pets'];
      final pets = petsJson.map((json) => PetListItem.fromJson(json)).toList();
      return {
        'pets': pets,
        'totalCount': data['totalCount'],
      };
    } else {
      throw Exception('Failed to load pets');
    }
  }
}