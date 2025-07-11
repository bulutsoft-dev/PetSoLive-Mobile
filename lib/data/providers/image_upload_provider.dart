import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageUploadProvider {
  static const String _apiKey = '314bbcee2e4f10dd079a48f5240c7fb7'; // IMGBB API KEY

  static Future<String> uploadToImgbb(File imageFile) async {
    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['data']['url'];
    } else {
      throw Exception('Resim yüklenemedi');
    }
  }
} 