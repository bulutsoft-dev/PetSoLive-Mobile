import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/veterinarian_dto.dart';

class VeterinarianApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<VeterinarianDto>> getAll() async {
    final url = '$baseUrl/api/Veterinarian';
    final headers = {
      'Authorization': 'Bearer ${ApiConstants.apiKey}',
      'x-api-key': ApiConstants.apiKey,
    };
    print('[VETERINARIAN GETALL] URL: $url');
    print('[VETERINARIAN GETALL] Headers: ' + headers.toString());
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    print('[VETERINARIAN GETALL] Status: ${response.statusCode}');
    print('[VETERINARIAN GETALL] Response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => VeterinarianDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch veterinarians');
  }

  Future<VeterinarianDto?> register(VeterinarianDto dto, String token) async {
    final url = '$baseUrl/api/Veterinarian/register';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    print('[VETERINARIAN REGISTER] URL: $url');
    print('[VETERINARIAN REGISTER] Headers: ' + headers.toString());
    print('[VETERINARIAN REGISTER] Body: $body');
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print('[VETERINARIAN REGISTER] Status: ${response.statusCode}');
    print('[VETERINARIAN REGISTER] Response: ${response.body}');
    if (response.statusCode == 200) {
      return VeterinarianDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to register veterinarian: ${response.body}');
  }

  Future<void> approve(int id, String token) async {
    final url = '$baseUrl/api/Veterinarian/$id/approve';
    final headers = {
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    print('[VETERINARIAN APPROVE] URL: $url');
    print('[VETERINARIAN APPROVE] Headers: ' + headers.toString());
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
    );
    print('[VETERINARIAN APPROVE] Status: ${response.statusCode}');
    print('[VETERINARIAN APPROVE] Response: ${response.body}');
    if (response.statusCode != 204) {
      throw Exception('Failed to approve veterinarian');
    }
  }

  Future<void> reject(int id, String token) async {
    final url = '$baseUrl/api/Veterinarian/$id/reject';
    final headers = {
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    print('[VETERINARIAN REJECT] URL: $url');
    print('[VETERINARIAN REJECT] Headers: ' + headers.toString());
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
    );
    print('[VETERINARIAN REJECT] Status: ${response.statusCode}');
    print('[VETERINARIAN REJECT] Response: ${response.body}');
    if (response.statusCode != 204) {
      throw Exception('Failed to reject veterinarian');
    }
  }
}