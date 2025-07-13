import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploadButton extends StatefulWidget {
  final void Function(String url) onImageUploaded;
  final String? initialUrl;
  final String label;
  const ImageUploadButton({Key? key, required this.onImageUploaded, this.initialUrl, this.label = 'Resim Yükle'}) : super(key: key);

  @override
  State<ImageUploadButton> createState() => _ImageUploadButtonState();
}

class _ImageUploadButtonState extends State<ImageUploadButton> {
  bool _isUploading = false;
  String? _uploadedUrl;

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() => _isUploading = true);
    try {
      final bytes = await pickedFile.readAsBytes();
      final apiKey = '314bbcee2e4f10dd079a48f5240c7fb7';
      debugPrint('IMGBB_API_KEY: ' + apiKey);
      final base64Image = base64Encode(bytes);
      final response = await http.post(
        Uri.parse('https://api.imgbb.com/1/upload'),
        body: {
          'key': apiKey,
          'image': base64Image,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['data']['url'];
        setState(() => _uploadedUrl = url);
        widget.onImageUploaded(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yükleme başarısız: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yükleme hatası: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = _uploadedUrl ?? widget.initialUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (url != null && url.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 100, height: 100, color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
        SizedBox(
          width: 160,
          child: ElevatedButton.icon(
            onPressed: _isUploading ? null : _pickAndUpload,
            icon: _isUploading ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(Icons.upload_file),
            label: Text(widget.label),
          ),
        ),
      ],
    );
  }
} 