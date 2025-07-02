import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/user_dto.dart';

class UserApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<UserDto>> getUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => UserDto.fromJson(e)).toList();
    } else {
      throw Exception('Kullanıcılar alınamadı');
    }
  }

  Future<UserDto> getUser(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return UserDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Kullanıcı alınamadı');
    }
  }

  Future<void> createUser(UserDto user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Kullanıcı oluşturulamadı');
    }
  }

  Future<void> updateUser(int id, UserDto user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Kullanıcı güncellenemedi');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Kullanıcı silinemedi');
    }
  }
} 