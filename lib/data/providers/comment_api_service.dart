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
    final response = await http.delete(
      Uri.parse('$baseUrl/api/Comment/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete comment');
    }
  }
}