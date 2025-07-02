import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/user_dto.dart';

class UserApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<UserDto>> getAll() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/User'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UserDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch users');
  }

  Future<UserDto?> getById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/User/$id'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return UserDto.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<void> update(int id, UserDto dto, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/User/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update user');
    }
  }
}