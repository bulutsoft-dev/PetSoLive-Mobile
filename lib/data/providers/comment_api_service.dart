import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/comment_dto.dart';

class CommentApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<CommentDto>> getComments() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => CommentDto.fromJson(e)).toList();
    } else {
      throw Exception('Yorumlar alınamadı');
    }
  }

  Future<CommentDto> getComment(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/comments/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return CommentDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Yorum alınamadı');
    }
  }

  Future<void> createComment(CommentDto comment) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(comment.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Yorum oluşturulamadı');
    }
  }

  Future<void> updateComment(int id, CommentDto comment) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/comments/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(comment.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Yorum güncellenemedi');
    }
  }

  Future<void> deleteComment(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/comments/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Yorum silinemedi');
    }
  }
} 