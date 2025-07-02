import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/admin_dto.dart';

class AdminApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<AdminDto>> getAdmins() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/admins'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => AdminDto.fromJson(e)).toList();
    } else {
      throw Exception('Adminler alınamadı');
    }
  }

  Future<AdminDto> getAdmin(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/admins/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return AdminDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Admin alınamadı');
    }
  }

  Future<void> createAdmin(AdminDto admin) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admins'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(admin.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Admin oluşturulamadı');
    }
  }

  Future<void> updateAdmin(int id, AdminDto admin) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/admins/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(admin.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Admin güncellenemedi');
    }
  }

  Future<void> deleteAdmin(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/admins/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Admin silinemedi');
    }
  }
} 