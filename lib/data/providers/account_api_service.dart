// © 2025 PetSoLive & Bulutsoft. Tüm hakları saklıdır.
// Hesap işlemleri API servisi

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/auth_dto.dart';
import '../models/register_dto.dart';
import '../models/auth_response_dto.dart';
import 'package:flutter/foundation.dart';

class AccountApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<AuthResponseDto> login(AuthDto dto) async {
    final url = '$baseUrl/api/Account/login';
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    
    debugPrint('Login URL: $url');
    debugPrint('Login headers: $headers');
    debugPrint('Login body: $body');
    
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    
    debugPrint('Login response: Status=${response.statusCode}, Body=${response.body}');
    
    if (response.statusCode == 200) {
      return AuthResponseDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed: Status=${response.statusCode}, Body=${response.body}');
    }
  }

  /// Kullanıcı kaydı. Başarılı olursa AuthResponseDto döner.
  Future<AuthResponseDto?> register(RegisterDto dto) async {
    final url = '$baseUrl/api/Account/register';
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    
    debugPrint('Register URL: $url');
    debugPrint('Register headers: $headers');
    debugPrint('Register body: $body');
    
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    
    debugPrint('Register response: Status=${response.statusCode}, Body=${response.body}');
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Register response JSON: ' + json.toString());
      if (json['token'] == null || json['user'] == null) {
        // Sadece başarılı mesajı döndüyse özel bir durum döndür
        if (json['message'] != null) {
          throw Exception('REGISTER_SUCCESS_MESSAGE:' + json['message']);
        }
        throw Exception('Beklenen kullanıcı verisi veya token dönmedi. Backend response: ' + response.body);
      }
      return AuthResponseDto.fromJson(json);
    } else {
      throw Exception('Register failed: Status=${response.statusCode}, Body=${response.body}');
    }
  }

  /// Kullanıcı kaydı (profil resmi ile). Başarılı olursa AuthResponseDto döner.
  Future<AuthResponseDto?> registerWithImage(RegisterDto dto, File profileImage) async {
    // API 415 hatası verdiği için multipart yerine JSON kullanacağız
    // Profil resmini base64'e çevirip JSON içinde göndereceğiz
    
    try {
      // Resmi base64'e çevir
      final bytes = await profileImage.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // JSON body oluştur
      final jsonBody = {
        'username': dto.username,
        'email': dto.email,
        'password': dto.password,
        'phoneNumber': dto.phoneNumber,
        'address': dto.address,
        'dateOfBirth': dto.dateOfBirth.toIso8601String(),
        'city': dto.city,
        'district': dto.district,
        'profileImageBase64': base64Image,
      };
      
      final url = '$baseUrl/api/Account/register';
      final headers = {
        'Content-Type': 'application/json',
        'x-api-key': ApiConstants.apiKey,
      };
      
      debugPrint('Register with image URL: $url');
      debugPrint('Register with image headers: $headers');
      debugPrint('Register with image body keys: ${jsonBody.keys.toList()}');
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(jsonBody),
      );
      
      final responseBody = response.body;
      debugPrint('Register with image response: Status=${response.statusCode}, Body=$responseBody');
      
      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody);
        if (json['token'] == null || json['user'] == null) {
          // Sadece başarılı mesajı döndüyse özel bir durum döndür
          if (json['message'] != null) {
            throw Exception('REGISTER_SUCCESS_MESSAGE:' + json['message']);
          }
          throw Exception('Beklenen kullanıcı verisi veya token dönmedi. Backend response: ' + responseBody);
        }
        return AuthResponseDto.fromJson(json);
      } else {
        throw Exception('Register failed: Status=${response.statusCode}, Body=$responseBody');
      }
    } catch (e) {
      debugPrint('Error in registerWithImage: $e');
      rethrow;
    }
  }
}