import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://petsolive.com.tr'; // <-- API URL'ni buraya yaz
  static const String _loginEndpoint = '/api/Account/login';
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user';

  // Login fonksiyonu
  Future<bool> login({required String username, required String password}) async {
    final url = Uri.parse('$_baseUrl$_loginEndpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userKey, jsonEncode(user));
        return true;
      } else {
        // Hatalı giriş
        return false;
      }
    } catch (e) {
      // Hata yönetimi
      print('Login error: $e');
      return false;
    }
  }

  // Token'ı getir
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Kullanıcıyı getir
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString == null) return null;
    return jsonDecode(userString);
  }

  // Çıkış yap
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Token ile korumalı istek örneği
  Future<http.Response> getProtected(String endpoint) async {
    final token = await getToken();
    final url = Uri.parse('$_baseUrl$endpoint');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // Register fonksiyonu
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
    required String city,
    required String district,
    String? profileImageUrl,
  }) async {
    final url = Uri.parse('$_baseUrl/api/Account/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'address': address,
          'dateOfBirth': dateOfBirth.toIso8601String(),
          'profileImageUrl': profileImageUrl ?? 'https://www.petsolive.com.tr/',
          'city': city,
          'district': district,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
} 