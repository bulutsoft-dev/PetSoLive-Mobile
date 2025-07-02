import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/lost_pet_ad_dto.dart';

class LostPetAdApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<LostPetAdDto>> getLostPetAds() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/lostpetads'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => LostPetAdDto.fromJson(e)).toList();
    } else {
      throw Exception('Kayıp ilanlar alınamadı');
    }
  }

  Future<LostPetAdDto> getLostPetAd(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/lostpetads/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode == 200) {
      return LostPetAdDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Kayıp ilan alınamadı');
    }
  }

  Future<void> createLostPetAd(LostPetAdDto ad) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/lostpetads'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(ad.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Kayıp ilan oluşturulamadı');
    }
  }

  Future<void> updateLostPetAd(int id, LostPetAdDto ad) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/lostpetads/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
      body: json.encode(ad.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Kayıp ilan güncellenemedi');
    }
  }

  Future<void> deleteLostPetAd(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/lostpetads/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConstants.apiKey}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Kayıp ilan silinemedi');
    }
  }
} 