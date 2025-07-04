import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/auth_dto.dart';
import '../models/register_dto.dart';
import '../models/auth_response_dto.dart';

class AccountApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<AuthResponseDto> login(AuthDto dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Account/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return AuthResponseDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> register(RegisterDto dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Account/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Register failed: ${response.body}');
    }
  }
}