import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/providers/image_upload_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SimpleImagePickAndUpload extends StatefulWidget {
  final String? initialUrl;
  final File? initialFile;
  final void Function(String url, File file) onImageUploaded;
  final double size;
  final String? label;

  const SimpleImagePickAndUpload({
    Key? key,
    this.initialUrl,
    this.initialFile,
    required this.onImageUploaded,
    this.size = 120,
    this.label,
  }) : super(key: key);

  @override
  State<SimpleImagePickAndUpload> createState() => _SimpleImagePickAndUploadState();
}

class _SimpleImagePickAndUploadState extends State<SimpleImagePickAndUpload> {
  File? _selectedFile;
  String? _uploadedUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _selectedFile = widget.initialFile;
    _uploadedUrl = widget.initialUrl;
  }

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _isUploading = true;
      });
      try {
        final url = await ImageUploadProvider.uploadToImgbb(_selectedFile!);
        setState(() {
          _uploadedUrl = url;
          _isUploading = false;
        });
        widget.onImageUploaded(url, _selectedFile!);
      } catch (e) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('form.image_upload_failed'.tr(args: [e.toString()]))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
        ],
        Center(
          child: GestureDetector(
            onTap: _isUploading ? null : _pickAndUpload,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  child: _selectedFile != null
                      ? Image.file(_selectedFile!, width: widget.size, height: widget.size, fit: BoxFit.cover)
                      : (_uploadedUrl != null
                          ? Image.network(_uploadedUrl!, width: widget.size, height: widget.size, fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: widget.size,
                                height: widget.size,
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey[400]),
                              ),
                            )
                          : Container(
                              width: widget.size,
                              height: widget.size,
                              color: Colors.grey[200],
                              child: Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                            )),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: _isUploading
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(Icons.camera_alt, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 