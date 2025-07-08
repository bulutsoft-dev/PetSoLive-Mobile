// © 2025 PetSoLive & Bulutsoft. Tüm hakları saklıdır.
// Hesap işlemleri API servisi

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/auth_dto.dart';
import '../models/register_dto.dart';
import '../models/auth_response_dto.dart';
import 'package:flutter/foundation.dart';

class AccountApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<AuthResponseDto> login(AuthDto dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Account/login'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': ApiConstants.apiKey,
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return AuthResponseDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed:  ${response.body}');
    }
  }

  /// Kullanıcı kaydı. Başarılı olursa AuthResponseDto döner.
  Future<AuthResponseDto?> register(RegisterDto dto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Account/register'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': ApiConstants.apiKey,
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Register response: ' + json.toString());
      if (json['token'] == null || json['user'] == null) {
        // Sadece başarılı mesajı döndüyse özel bir durum döndür
        if (json['message'] != null) {
          throw Exception('REGISTER_SUCCESS_MESSAGE:' + json['message']);
        }
        throw Exception('Beklenen kullanıcı verisi veya token dönmedi. Backend response: ' + response.body);
      }
      return AuthResponseDto.fromJson(json);
    } else {
      throw Exception('Register failed: ${response.body}');
    }
  }
}