import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/comment_dto.dart';

class CommentApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<CommentDto>> getByHelpRequestId(int helpRequestId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Comment/help-request/$helpRequestId'),
      headers: {
        'x-api-key': ApiConstants.apiKey,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => CommentDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch comments');
  }

  Future<void> add(CommentDto dto, String token) async {
    final url = Uri.parse('$baseUrl/api/Comment');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    // Debug printler
    print('[COMMENT ADD] URL: $url');
    print('[COMMENT ADD] Headers: ' + headers.toString());
    print('[COMMENT ADD] Body: $body');
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print('[COMMENT ADD] Status: ${response.statusCode}');
    print('[COMMENT ADD] Response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }

  Future<void> delete(int id, String token) async {
    final url = Uri.parse('$baseUrl/api/Comment/$id');
    final headers = {
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    print('[COMMENT DELETE] URL: $url');
    print('[COMMENT DELETE] Headers: ' + headers.toString());
    final response = await http.delete(
      url,
      headers: headers,
    );
    print('[COMMENT DELETE] Status: ${response.statusCode}');
    print('[COMMENT DELETE] Response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }

  Future<void> update(int id, CommentDto dto, String token) async {
    final url = Uri.parse('$baseUrl/api/Comment/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': ApiConstants.apiKey,
    };
    final body = jsonEncode(dto.toJson());
    print('[COMMENT UPDATE] URL: $url');
    print('[COMMENT UPDATE] Headers: ' + headers.toString());
    print('[COMMENT UPDATE] Body: $body');
    print('[COMMENT UPDATE] Token: $token');
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );
    print('[COMMENT UPDATE] Status: ${response.statusCode}');
    print('[COMMENT UPDATE] Response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to update comment');
    }
  }
}